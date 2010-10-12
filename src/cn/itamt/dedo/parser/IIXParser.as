package cn.itamt.dedo.parser {
	import cn.itamt.dedo.data.DAnimationsCollection;
	import cn.itamt.dedo.data.DBrushesCollection;
	import cn.itamt.dedo.data.DMap;
	import cn.itamt.dedo.data.DMapCellsCollection;
	import cn.itamt.dedo.data.DMapCharactersCollection;
	import cn.itamt.dedo.data.DMapLayer;
	import cn.itamt.dedo.data.DMapLayersCollection;
	import cn.itamt.dedo.data.DMapsCollection;
	import cn.itamt.dedo.data.DTileCategoriesCollection;
	import cn.itamt.dedo.data.DTilesCollection;
	import cn.itamt.dedo.render.ResourceManager;
	import cn.itamt.utils.Debug;

	import flash.utils.ByteArray;

	/**
	 * @author itamt[at]qq.com
	 */
	public class IIXParser implements IDedoParser {
		private var iix : IIX;
		private var pCellHeight : uint;
		private var pCellWidth : uint;
		private var pVersion : String;
		private var pName : String;
		// 项目中含有的map数量.
		private var mapNum : uint;
		//
		private var pTiles : DTilesCollection;
		private var pMaps : DMapsCollection;
		private var pAnis : DAnimationsCollection;
		private var resMgr : ResourceManager;

		public function IIXParser() {
			resMgr = new ResourceManager();
		}

		public function parse(data : *, onComplete : Function = null) : Boolean {
			iix = new IIX(data as ByteArray);
			if(iix == null)
				return false;

			// 开始解析啦
			iix.position = 0;

			// 解析头部信息
			if(iix.readString(3) != "IIX") {
				return false;
			}
			pVersion = iix.readUint8() + "." + iix.readUint8();

			// 解析基本信息
			pName = iix.readString(128);
			pCellWidth = iix.readUint16();
			pCellHeight = iix.readUint16();
			mapNum = iix.readUint32();

			// 解析图片(tile)信息
			pTiles = new DTilesCollection();
			pTiles.fileName = iix.readString(128);
			pTiles.fileName = "dedo.png";
			var cellW : uint = iix.readUint16();
			var cellH : uint = iix.readUint16();
			if(cellW != this.pCellWidth || cellH != this.pCellHeight) {
				throw new Error("cellW != pCellWidth");
				return;
			}
			var numTiles : uint = iix.readUint16();
			var imgBuilder : IIXTilesImageBuilder = new IIXTilesImageBuilder();
			for(var i : uint = 0; i < numTiles; i++) {
				var bufferLen : uint = iix.readUint32();
				// 对png数据的解析.
				var ba : ByteArray = new ByteArray();
				iix.readBuffer(ba, bufferLen);
				imgBuilder.setTileImg(ba, i);
				pTiles.setValue(i, i);
			}
			resMgr.setTilesImage(pTiles.fileName, imgBuilder.build(numTiles, cellW, cellH));

			// 解析tile的分类信息
			var numTileCategories : uint = iix.readUint32();
			for(i = 0; i < numTileCategories; i++) {
				var catName : String = iix.readString(128);
				var numTilesInCat : uint = iix.readUint16();
				var numTilesByRow : uint = iix.readUint16();
				//				//  跳过
				iix.position += numTilesInCat * 2;
			}

			// 解析图片刷信息
			var auxNames : String = iix.readString(128);
			var numBrushes : uint = iix.readUint16();
			for(i = 0; i < numBrushes; i++) {
				var brushName : String = iix.readString(128);
				var brushCellsX : uint = iix.readUint32();
				var brushCellsY : uint = iix.readUint32();
				// 跳过刷子上的tile信息
				iix.position += brushCellsX * brushCellsY * 4;
				// 跳过刷子上的value信息
				iix.position += brushCellsX * brushCellsY * 4;
			}

			// 解析图片刷分类信息
			var numBrushCategories : uint = iix.readUint32();
			for(i = 0; i < numBrushCategories; i++) {
				var brushCategoryName : String = iix.readString(128);
				numBrushes = iix.readUint16();
				// 跳过刷子分类信息
				iix.position += numBrushes * 2;
			}

			// 解析动画信息
			this.pAnis = new DAnimationsCollection();
			var animationAuxName : String = iix.readString(128);
			var numAnimations : uint = iix.readUint32();
			for(i = 0; i < numAnimations; i++) {
				var animationName : String = iix.readString(128);
				var type : uint = iix.readUint8();
				var delay : uint = iix.readUint32();
				var numFrames : uint = iix.readUint16();
				var frames : Vector.<uint> = new Vector.<uint>();
				for(var fi : uint = 0; fi < numFrames; fi++) {
					frames[fi] = iix.readUint32();
				}
				this.pAnis.setAnimation(i, i, animationName, type, delay, frames);
			}

			// 解析动画分类信息
			var numAnimationCategories : uint = iix.readUint32();
			for(i = 0; i < numAnimationCategories; i++) {
				var animationCategoryName : String = iix.readString(128);
				var numAnimationsInCategory : uint = iix.readUint32();
				if(numAnimations > 0) {
					iix.position += numAnimationsInCategory * 4;
				}
			}

			// 解析地图信息
			var numMaps : uint = iix.readUint32();
			if(numMaps != mapNum) {
				throw new Error("numMaps != mapNum");
				return false;
			}
			pMaps = new DMapsCollection();
			for(i = 0; i < numMaps; i++) {
				var map : DMap = new DMap();

				var mapName : String = iix.readString(128);
				var cellsX : uint = iix.readUint16();
				var cellsY : uint = iix.readUint16();
				var cellsW : uint = iix.readUint16();
				var cellsH : uint = iix.readUint16();
				var numLayers : uint = iix.readUint8();
				Debug.trace('[IIXParser][parse]map:' + "(" + i + "/" + numMaps + ")" + mapName + ", " + cellsX + ", " + cellsY + ", " + cellsW + ", " + cellsH);

				map.index = i;
				map.name = mapName;
				map.cellsx = cellsX;
				map.cellsy = cellsY;
				map.cellheight = cellsH;
				map.cellwidth = cellsW;
				map.layers = new DMapLayersCollection();

				for(var j : uint = 0; j < numLayers; j++) {
					var layerName : String = iix.readString(128);
					var layerVisible : Boolean = Boolean(iix.readUint8());

					Debug.trace('[IIXParser][parse]map layer: ' + layerName + ", " + layerVisible);

					var layer : DMapLayer = new DMapLayer();
					layer.index = j;
					layer.name = layerName;
					layer.visible = layerVisible;
					layer.cells = new DMapCellsCollection();

					for(var k : uint = 0; k < cellsX * cellsY; k++) {
						var img : int = iix.readSint16();
						var value : uint = iix.readUint32();
						layer.cells.setMapCell(k, k % cellsX, uint(k / cellsX), img, value);
					}

					map.layers.setMapLayer(j, layer);
				}

				// 解析跳转点信息
				var numJumps : uint = iix.readUint32();
				for(j = 0; j < numJumps; j++) {
					var cellXaux : uint = iix.readUint16();
					var cellYaux : uint = iix.readUint16();
					var mapIndex : uint = iix.readUint16();
					var jumpToCellX : uint = iix.readUint16();
					var jumpToCellY : uint = iix.readUint16();
				}

				pMaps.setValue(i, map);
			}

			if(iix.bytesAvialiable) {
				throw new Error("多据有余.");
			}

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
			return pTiles;
		}

		public function getTileCategories() : DTileCategoriesCollection {
			return new DTileCategoriesCollection();
		}

		public function getMaps() : DMapsCollection {
			return pMaps;
		}

		public function getBrushes() : DBrushesCollection {
			return new DBrushesCollection();
		}

		public function resourceManager():ResourceManager {
			return resMgr;
		}

		public function getAnimations() : DAnimationsCollection {
			return this.pAnis;
		}

		/**
		 * 返回角色数据
		 * TODO:使用的是测试数据
		 */
		public function getCharacters() : DMapCharactersCollection {
			var charas : DMapCharactersCollection;
			charas = new DMapCharactersCollection();
			charas.setCharacter(0, 0, 10, 10, "tamt");
			return charas;
		}
	}
}
