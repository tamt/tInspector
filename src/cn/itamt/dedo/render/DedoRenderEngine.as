package cn.itamt.dedo.render {
	import cn.itamt.dedo.DedoProject;
	import cn.itamt.dedo.data.DMap;
	import cn.itamt.dedo.data.DMapCellsCollection;
	import cn.itamt.dedo.data.DMapLayer;
	import cn.itamt.dedo.data.DMapLayersCollection;
	import cn.itamt.dedo.manager.AnimationsManager;
	import cn.itamt.dedo.manager.TickManager;
	import cn.itamt.dedo.manager.TilesManager;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
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

		public function DedoRenderEngine():void {
		}

		/*************************************
		 **********public functions***********
		 *************************************/
		public function setViewPort(viewContainer : Sprite, w : uint, h : uint):void {
			this.viewContainer = viewContainer;

			this.viewW = w;
			this.viewH = h;

			outputRect = new Rectangle(0, 0, w, h);
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

		/**
		 * 卷轴滚动.
		 * 	@param direction		方向.
		 */
		public function scroll(scrollAmountX : int, scrollAmountY : int):void {
			this.outputBmd.lock();

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

			this.outputBmd.scroll(scrollAmountX, scrollAmountY);
			this.outputBmd.copyPixels(this.canvas, horizCutRect, horizPastePoint);
			this.outputBmd.copyPixels(this.canvas, vertCutRect, vertPastePoint);
			this.outputBmd.copyPixels(this.canvas, cornerCutRect, cornerPastePoint);
			this.outputRect.offset(-scrollAmountX, -scrollAmountY);
			// 绘制超出边缘的黑色区域
			this.renderOffsetArea();

			this.outputBmd.unlock();
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

			if(resMgr == null)
				resMgr = new ResourceManager();

			renderMap();
		}

		public function start():void {
			if(running)
				return;
			tickMgr = new TickManager();
			tickMgr.start();
			tickMgr.onTick(this.update);
			running = true;
		}

		public function setResourceManager(resourceManager : ResourceManager) : void {
			this.resMgr = resourceManager;
		}

		/*************************************
		 **********private functions**********
		 *************************************/
		private function renderMap():void {
			var layers : DMapLayersCollection = map.layers;
			for(var i : int = layers.length - 1; i >= 0; i--) {
				this.renderLayer(layers.getMapLayer(i));
			}

			// render to output view
			if(this.outputBmd) {
				this.outputBmd.copyPixels(this.canvas, this.outputRect, new Point(), null, null, true);
				renderOffsetArea();
			}
		}

		/**
		 * render single layer of a map.
		 */
		private function renderLayer(layer : DMapLayer):void {
			var resBmd : BitmapData = resMgr.getTilesImage(tiles);
			if(resBmd == null) {
				resMgr.listenLoad(tiles.images.fileName, this.renderMap);
			} else {
				var cells : DMapCellsCollection = layer.cells;
				var sourceRect : Rectangle = new Rectangle(0, 0, this.map.cellwidth, this.map.cellheight);
				var destPoint : Point = new Point();
				for(var i : int = 0; i < cells.length; i++) {
					var imgOrAni : int = cells.getMapCellImg(i);
					if(imgOrAni < -1000) {
						// 动画元素
						imgOrAni = this.anis.getAnimationTile(-1001 - imgOrAni, this.anis.getAnimationCurFrame(-1001 - imgOrAni));
					}
					sourceRect.x = map.cellwidth * (tiles.getTilePosX(imgOrAni));
					sourceRect.y = map.cellheight * (tiles.getTilePosY(imgOrAni));
					destPoint.x = cells.getMapCellX(i) * map.cellwidth;
					destPoint.y = cells.getMapCellY(i) * map.cellheight;
					this.canvas.copyPixels(resBmd, sourceRect, destPoint, null, null, true);
				}
			}
		}

		private function renderOffsetArea():void {
			// 绘制超过边缘的黑色区域

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
		}
	}
}
