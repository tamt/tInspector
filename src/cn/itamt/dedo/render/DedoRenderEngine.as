package cn.itamt.dedo.render {
	import cn.itamt.dedo.data.DMap;
	import cn.itamt.dedo.data.DMapCellsCollection;
	import cn.itamt.dedo.data.DMapLayer;
	import cn.itamt.dedo.data.DMapLayersCollection;
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
		private var resMgr : ResourceManager;

		public function DedoRenderEngine():void {
		}

		/*************************************
		 **********public functions***********
		 *************************************/
		/**
		 * render an DedoProject on canvas.
		 * @param canvas		
		 * @param project
		 */
		public function render(canvas : Sprite, map : DMap, tilesManager : TilesManager) : void {
			this.canvas = new BitmapData(map.cellsx * map.cellwidth, map.cellsy * map.cellheight, true, 0xffffffff);
			this.map = map;
			this.tiles = tilesManager;

			if(resMgr == null)
				resMgr = new ResourceManager();

			renderMap();

			canvas.addChild(new Bitmap(this.canvas));
		}

		/*************************************
		 **********private functions**********
		 *************************************/
		private function renderMap():void {
			var layers : DMapLayersCollection = map.layers;
			for(var i : int = layers.length - 1; i > 0; i--) {
				this.renderLayer(layers.getMapLayer(i));
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
					sourceRect.x = map.cellwidth * (tiles.getTilePosX(cells.getMapCellImg(i)));
					sourceRect.y = map.cellheight * (tiles.getTilePosY(cells.getMapCellImg(i)));
					destPoint.x = cells.getMapCellX(i) * map.cellwidth;
					destPoint.y = cells.getMapCellY(i) * map.cellheight;
					this.canvas.copyPixels(resBmd, sourceRect, destPoint, null, null, true);
				}
			}
		}
	}
}
