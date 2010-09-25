package cn.itamt.dedo.parser {
	import cn.itamt.dedo.data.DBrushesCollection;
	import cn.itamt.dedo.data.DMapsCollection;
	import cn.itamt.dedo.data.DTileCategoriesCollection;
	import cn.itamt.dedo.data.DTilesCollection;
	import cn.itamt.utils.Debug;
	import cn.itamt.utils.IIX;

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
		private var tiles : DTilesCollection;
		private var tileCategories : DTileCategoriesCollection;

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
			tiles = new DTilesCollection();
			tiles.fileName = iix.readString(128);
			var cellW : uint = iix.readUint16();
			var cellH : uint = iix.readUint16();
			if(cellW != this.pCellWidth || cellH != this.pCellHeight) {
				throw new Error("cellW != pCellWidth");
				return;
			}
			var numTiles : uint = iix.readUint16();
			for(var i : uint = 0; i < numTiles; i++) {
				var bufferLen : uint = iix.readUint32();
				// 这里放置对png数据的解析.
				// iix.readBuffer(new ByteArray(), bufferLen);
				iix.position += bufferLen;
				tiles.setValue(i, i);
			}

			// 解析tile的分类信息
			tileCategories = new DTileCategoriesCollection();
			var numTileCategories : uint = iix.readUint32();
			Debug.trace('[IIXParser][parse]' + numTileCategories);
			for(i = 0; i < numTileCategories; i++) {
				var catName : String = iix.readString(128);
				Debug.trace('[IIXParser][parse]' + catName);
				var numTilesInCat : uint = iix.readUint16();
				var numTilesByRow : uint = iix.readUint16();
				Debug.trace('[IIXParser][parse]' + numTilesInCat + ", " + numTilesByRow);
				//				//  跳过
				iix.position += numTilesInCat * 2;
			}

			// 解析图片刷信息
			var auxNames : String = iix.readString(128);
			Debug.trace('[IIXParser][parse]' + auxNames);
			var numBrushes : uint = iix.readUint16();
			Debug.trace('[IIXParser][parse]' + numBrushes);
			for(i = 0; i < numBrushes; i++) {
				var brushName : String = iix.readString(128);
				Debug.trace('[IIXParser][parse]' + brushName);
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
				Debug.trace('[IIXParser][parse]' + iix.readString(128));
				numBrushes = iix.readUint16();
				// 跳过刷子分类信息
				iix.position += numBrushes * 2;
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
			// TODO: Auto-generated method stub
			return null;
		}

		public function getTileCategories() : DTileCategoriesCollection {
			// TODO: Auto-generated method stub
			return null;
		}

		public function getMaps() : DMapsCollection {
			// TODO: Auto-generated method stub
			return null;
		}

		public function getBrushes() : DBrushesCollection {
			// TODO: Auto-generated method stub
			return null;
		}

		public function getAnimations() : XML {
			// TODO: Auto-generated method stub
			return null;
		}
	}
}
