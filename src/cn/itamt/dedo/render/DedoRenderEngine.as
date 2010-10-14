package cn.itamt.dedo.render {
	import cn.itamt.dedo.DedoProject;
	import cn.itamt.dedo.data.DMap;
	import cn.itamt.dedo.data.DMapArea;
	import cn.itamt.dedo.data.DMapCellsCollection;
	import cn.itamt.dedo.data.DMapLayer;
	import cn.itamt.dedo.data.DMapLayersCollection;
	import cn.itamt.dedo.manager.AnimationsManager;
	import cn.itamt.dedo.manager.CharactersManager;
	import cn.itamt.dedo.manager.TickManager;
	import cn.itamt.dedo.manager.TilesManager;
	import cn.itamt.utils.Debug;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Dedo渲染引擎
	 * @author itamt[at]qq.com
	 */
	public class DedoRenderEngine {
		private var canvas : BitmapData;
		private var map : DMap;
		private var tiles : TilesManager;
		private var anis : AnimationsManager;
		private var resMgr : ResourceManager;
		private var viewW : uint = 400;
		private var viewH : uint = 400;
		private var outputRect : Rectangle;
		private var mapArea : DMapArea;
		private var outputBmd : BitmapData;
		private var horizCutRect : Rectangle;
		private var vertCutRect : Rectangle;
		private var cornerCutRect : Rectangle;
		private var horizPastePoint : Point;
		private var vertPastePoint : Point;
		private var cornerPastePoint : Point;
		private var viewContainer : Sprite;
		private var running : Boolean;
		// 计时器
		private var tickMgr : TickManager;
		private var validated : Boolean;
		private var zeroPoint : Point = new Point();
		//
		private var charaMgr : CharactersManager;

		public function DedoRenderEngine():void {
		}

		/*************************************
		 **********public functions***********
		 *************************************/
		public function setViewPort(viewContainer : Sprite, w : uint, h : uint):void {
			this.viewContainer = viewContainer;

			this.viewW = w;
			this.viewH = h;

			outputRect = new Rectangle(0, 0, this.viewW, this.viewH);
			mapArea = new DMapArea(0, 0, this.viewW / 32, this.viewH / 32);
			horizCutRect = new Rectangle();
			vertCutRect = new Rectangle();
			cornerCutRect = new Rectangle();
			horizPastePoint = new Point();
			vertPastePoint = new Point();
			cornerPastePoint = new Point();

			if(this.outputBmd) {
				this.outputBmd.dispose();
			}
			this.outputBmd = new BitmapData(this.viewW, this.viewH, false, 0xffff0000);
			viewContainer.addChild(new Bitmap(this.outputBmd));
		}

		public function getViewArea():DMapArea {
			return this.mapArea;
		}

		/**
		 * 卷轴滚动.
		 * 	@param direction		方向.
		 */
		public function scroll(scrollAmountX : int, scrollAmountY : int):void {
			horizCutRect.x = outputRect.x;
			horizCutRect.y = outputRect.y - scrollAmountY;
			horizCutRect.width = viewW - Math.abs(scrollAmountX);
			horizCutRect.height = Math.abs(scrollAmountY);

			vertCutRect.x = outputRect.x - scrollAmountX;
			vertCutRect.y = outputRect.y;
			vertCutRect.width = Math.abs(scrollAmountX);
			vertCutRect.height = viewH - Math.abs(scrollAmountY);

			cornerCutRect.x = outputRect.x - scrollAmountX;
			cornerCutRect.y = outputRect.y - scrollAmountY;
			cornerCutRect.width = Math.abs(scrollAmountX);
			cornerCutRect.height = Math.abs(scrollAmountY);

			horizPastePoint.x = scrollAmountX;
			horizPastePoint.y = 0;
			vertPastePoint.x = 0;
			vertPastePoint.y = scrollAmountY;
			cornerPastePoint.x = 0;
			cornerPastePoint.y = 0;

			if (scrollAmountX < 0) {
				vertCutRect.x = cornerCutRect.x = outputRect.right;
				cornerPastePoint.x = vertPastePoint.x = viewW - Math.abs(scrollAmountX);

				horizPastePoint.x = 0;
				horizCutRect.x = outputRect.x + Math.abs(scrollAmountX);
			}

			if (scrollAmountY < 0) {
				horizCutRect.y = cornerCutRect.y = outputRect.bottom;
				cornerPastePoint.y = horizPastePoint.y = viewH - Math.abs(scrollAmountY);

				vertCutRect.y = outputRect.y + Math.abs(scrollAmountY);
				vertPastePoint.y = 0;
			}
			this.outputRect.offset(-scrollAmountX, -scrollAmountY);
			this.transformOutputRect2MapRect();

			// 需要重绘
			validate();
		}

		/**
		 * render an DedoProject on canvas.
		 * @param canvas
		 * @param project
		 */
		public function render(map : DMap, project : DedoProject) : void {
			this.canvas = new BitmapData(map.cellsx * map.cellwidth, map.cellsy * map.cellheight, true, 0xffffffff);
			this.map = map;
			this.tiles = project.tilesMgr;
			this.anis = project.animationsMgr;
			this.charaMgr = new CharactersManager(map.characters);
			this.transformOutputRect2MapRect();

			if(resMgr == null)
				resMgr = new ResourceManager();

			renderMap(this.mapArea);
		}

		public function start():void {
			if(running)
				return;
			tickMgr = new TickManager();
			tickMgr.start();
			tickMgr.onTick(updateAnimationTiles);
			running = true;
		}

		public function setResourceManager(resourceManager : ResourceManager) : void {
			this.resMgr = resourceManager;
		}

		public function updateCharacters():void {
			// 查找当前可视范围内的角色元素
			if(this.map.hasCharacterInArea(this.mapArea)) {
				this.renderMap(this.mapArea);
				// 更新canvas的内容
				this.validate();
			}
		}

		/*************************************
		 **********private functions**********
		 *************************************/
		/**
		 * 渲染地图
		 * @param area	要渲染的区域
		 */
		private function renderMap(area : DMapArea = null):void {
			if(area == null)
				area = this.mapArea;
			var layers : DMapLayersCollection = map.layers;
			for(var i : int = layers.length - 1; i >= 0; i--) {
				var layer : DMapLayer = layers.getMapLayer(i);
				if(layer && layer.visible)
					this.renderLayer(layer, area);
			}

			// render to output view
			if(this.outputBmd) {
				this.outputBmd.copyPixels(this.canvas, this.outputRect, zeroPoint, null, null, true);
				renderOffsetArea();
			}
		}

		/**
		 * render single layer of a map.
		 */
		private function renderLayer(layer : DMapLayer, area : DMapArea = null):void {
			var resBmd : BitmapData = resMgr.getTilesImage(tiles);
			if(resBmd == null) {
				resMgr.listenLoad(tiles.images.fileName, this.renderMap);
			} else {
				var cells : DMapCellsCollection = layer.cells;
				var sourceRect : Rectangle = new Rectangle(0, 0, this.map.cellwidth, this.map.cellheight);
				var destPoint : Point = new Point();

				for(var i : int = 0; i < cells.length; i++) {
					var imgOrAni : uint = cells.getMapCellImg(i);
					if(cells.getMapCellIsAnimation(i)) {
						// this cell is an Animation cell.
						imgOrAni = this.anis.getAnimationTile(imgOrAni, this.tickMgr.tick);
					}
					sourceRect.x = map.cellwidth * (tiles.getTilePosX(imgOrAni));
					sourceRect.y = map.cellheight * (tiles.getTilePosY(imgOrAni));
					destPoint.x = cells.getMapCellX(i) * map.cellwidth;
					destPoint.y = cells.getMapCellY(i) * map.cellheight;
					this.canvas.copyPixels(resBmd, sourceRect, destPoint, null, null, true);
				}

				var hasChars : Boolean = charaMgr.hasCharacterInArea(area);
				if(hasChars) {
					var charaIndexs : Vector.<uint> = charaMgr.getCharactersInArea(area);
					for(var k : int = 0; k < charaIndexs.length; k++) {
						var posX : Number = charaMgr.charas.getCharacterX(charaIndexs[k]);
						var posY : Number = charaMgr.charas.getCharacterY(charaIndexs[k]);

						// 绘制会遮住角色层的物体
						var tcells : Vector.<uint> = cells.getMapCellByWorldPos(posX, posY);
						for(var j : int = 0; j < tcells.length; j++) {
							var index : int = tcells[j];
							if(cells.getMapCellValue(index) < charaMgr.charas.getCharacterValue(charaIndexs[k])) {
								var img : uint = charaMgr.charas.getCharacterImg(charaIndexs[k]);
								img = this.anis.getAnimationTile(img, charaMgr.charas.getCharacterFrame(charaIndexs[k]));
								sourceRect.x = map.cellwidth * (tiles.getTilePosX(img));
								sourceRect.y = map.cellheight * (tiles.getTilePosY(img));
								destPoint.x = map.cellwidth * posX;
								destPoint.y = map.cellheight * posY;
								this.canvas.copyPixels(resBmd, sourceRect, destPoint, null, null, true);
							}
						}
					}
				}
			}
		}

		private function renderOffsetArea():void {
			if(this.outputRect.left < 0) {
				this.outputBmd.fillRect(new Rectangle(0, 0, -this.outputRect.left, this.outputBmd.height), 0xff000000);
			} else if(this.outputRect.right > this.canvas.rect.right) {
				this.outputBmd.fillRect(new Rectangle(this.outputBmd.rect.right - (this.outputRect.right - this.canvas.rect.right), 0, this.outputRect.right - this.canvas.rect.right, this.outputBmd.height), 0xff000000);
			}
			if(this.outputRect.top < 0) {
				this.outputBmd.fillRect(new Rectangle(0, 0, this.outputBmd.width, -this.outputRect.top), 0xff000000);
			} else if(this.outputRect.bottom > this.canvas.rect.bottom) {
				this.outputBmd.fillRect(new Rectangle(0, this.outputBmd.rect.bottom - (this.outputRect.bottom - this.canvas.rect.bottom), this.outputBmd.width, this.outputRect.bottom - this.canvas.rect.bottom), 0xff000000);
			}
		}

		private function update() : void {
			this.outputBmd.lock();
			this.outputBmd.copyPixels(this.canvas, this.outputRect, zeroPoint);
			this.renderOffsetArea();
			this.outputBmd.unlock();
		}

		private function validate() : void {
			if(this.validated)
				return;
			this.validated = true;
			this.viewContainer.stage.invalidate();
			this.viewContainer.stage.addEventListener(Event.RENDER, function(evt : Event):void {
				viewContainer.stage.removeEventListener(Event.RENDER, arguments.callee);
				validated = false;
				update();
			});
		}

		/**
		 * 更新动画
		 */
		private function updateAnimationTiles() : void {
			// 查找当前可视范围内的动画元素
			if(this.map.hasAnimationInArea(this.mapArea)) {
				this.renderMap(this.mapArea);
				// 更新canvas的内容
				this.validate();
			}
		}

		private function transformOutputRect2MapRect() : void {
			this.mapArea.left = Math.floor(this.outputRect.left < 0 ? 0 : this.outputRect.left / map.cellwidth);
			this.mapArea.top = Math.floor(this.outputRect.top < 0 ? 0 : this.outputRect.top / map.cellheight);
			this.mapArea.right = Math.ceil(this.outputRect.right < 0 ? 0 : this.outputRect.right / map.cellwidth);
			this.mapArea.bottom = Math.ceil(this.outputRect.bottom < 0 ? 0 : this.outputRect.bottom / map.cellheight);

			Debug.trace('[DedoRenderEngine][transformOutputRect2MapRect]' + this.mapArea.toString());
		}
	}
}
