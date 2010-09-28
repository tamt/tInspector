package cn.itamt.dedo.manager {
	import cn.itamt.dedo.data.DTileCategoriesCollection;
	import cn.itamt.dedo.data.DTilesCollection;
	import cn.itamt.utils.Debug;

	/**
	 * @author itamt[at]qq.com
	 */
	public class TilesManager {
		public var images : DTilesCollection;
		public var categories : DTileCategoriesCollection;
		private var tilesX : uint;
		private var tilesY : uint;

		public function TilesManager(images : DTilesCollection, categories : DTileCategoriesCollection) : void {
			this.images = images;
			this.categories = categories;

			tilesX = uint(Math.sqrt(this.images.length));
			tilesY = Math.ceil(this.images.length / tilesX);
		}

		public function getTilePosX(tileIndex : int) : uint {
			if(tileIndex < -1000) {
				Debug.trace('[TilesManager][getTilePosX]' + tileIndex);
			}
			return tileIndex % tilesX;
		}

		public function getTilePosY(tileIndex : int) : uint {
			return tileIndex / tilesX;
		}
	}
}
