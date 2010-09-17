package cn.itamt.dedo.parser {
	import cn.itamt.dedo.data.DBrushesCollection;
	import cn.itamt.dedo.data.DMap;
	import cn.itamt.dedo.data.DMapCellsCollection;
	import cn.itamt.dedo.data.DMapLayer;
	import cn.itamt.dedo.data.DMapLayersCollection;
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

		// ////////////////////////////////////
		// ////////实现接口：IMapParser/////////
		// ////////////////////////////////////
		public function parse(xml : *, onComplete : Function = null) : Boolean {
			this.xml = xml as XML;

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
				var mapList : XMLList = xml.maps.map;
				var i : int = 0;
				var mXML : XML;
				for each(mXML in mapList) {
					var map : DMap = new DMap();
					map.index = parseInt(mXML.@index);
					map.name = mXML.@name;
					map.cellsx = parseInt(mXML.@cellsx);
					map.cellsy = parseInt(mXML.@cellsy);
					map.cellheight = parseInt(mXML.@cellheight);
					map.cellwidth = parseInt(mXML.@cellwidth);

					map.layers = new DMapLayersCollection();
					var layerList : XMLList = mXML.layers.layer;
					var layerXML : XML;
					var j : int = 0;
					for each(layerXML in layerList) {
						var layer : DMapLayer = new DMapLayer();
						layer.index = parseInt(layerXML.@index);
						layer.name = layerXML.@name;
						layer.visible = Boolean(parseInt(layerXML.@visible));

						layer.cells = new DMapCellsCollection();
						var cellList : XMLList = layerXML.cell;
						var cellXML : XML;
						var k : int = 0;
						for each(cellXML in cellList) {
							layer.cells.setMapCell(k++, parseInt(cellXML.@x), parseInt(cellXML.@y), parseInt(cellXML.@img), parseInt(cellXML.@value));
						}

						map.layers.setMapLayer(j++, layer);
					}

					pMaps.setValue(i++, map);
				}
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
