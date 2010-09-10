package cn.itamt.dedo.parser {
	import cn.itamt.dedo.data.DBrushesCollection;
	import cn.itamt.dedo.data.DMapsCollection;
	import cn.itamt.dedo.data.DTileCategoriesCollection;
	import cn.itamt.dedo.data.DTilesCollection;

	/**
	 * @author itamt[at]qq.com
	 */
	public class TileMapperParser implements IDedoParser {

		private var xml : XML;
		private var pName : String;
		private var pVersion : String;
		private var pCellWidth : uint;
		private var pCellHeight : uint;
		private var pTiles : DTilesCollection;
		private var pMaps : DMapsCollection;
		private var pBrushes : DBrushesCollection;

		
		public function TileMapperParser() : void {
		}

		//////////////////////////////////////
		//////////实现接口：IMapParser/////////
		//////////////////////////////////////

		public function parse(xml : XML) : Boolean {
			this.xml = xml;
			
			pName = this.xml.@name;
			pVersion = this.xml.@version;
			pCellWidth = parseInt(this.xml.@cellwidth);
			pCellHeight = parseInt(this.xml.@cellheight);
			
			return true;
		}

		public function getProjectName() : String {
			return pName;
		}

		public function getProjectVersion() : String {
			return pVersion;
		}

		public function getProjectCellWidth() : uint {
			return pCellWidth;
		}

		public function getProjectCellHeight() : uint {
			return pCellHeight;
		}

		public function getTiles() : DTilesCollection {
			if(pTiles == null) {
				pTiles = new DTilesCollection();
				pTiles.fileName = xml.tiles.images.@filename;
				var imgList : XMLList = xml.tiles.images.image;
				var img : XML;
				var i : int = 0;
				for each(img in imgList) {
					pTiles.setValue(i++, parseInt(img.@index));
				}
			}
			
			return pTiles;
		}

		public function getTileCategories() : DTileCategoriesCollection {
			var collection : DTileCategoriesCollection;
			return collection;
		}

		public function getMaps() : DMapsCollection {
			if(pMaps == null) {
				pMaps = new DMapsCollection();
			}
			
			return pMaps;
		}

		public function getBrushes() : DBrushesCollection {
			var collection : DBrushesCollection;
			
			return collection;
		}

		public function getAnimations() : XML {
			return null;
		}
	}
}
