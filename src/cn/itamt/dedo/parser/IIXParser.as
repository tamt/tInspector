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
			Debug.trace('[IIXParser][parse]' + pName + ", " + pCellWidth + ", " + pCellHeight);
			mapNum = iix.readUint32();
			Debug.trace('[IIXParser][parse] map num: ' + mapNum);

			// 解析图片(tile)信息
			tiles = new DTilesCollection();
			tiles.fileName = iix.readString(128);
			Debug.trace('[IIXParser][parse]' + tiles.fileName);
			var cellW : uint = iix.readUint16();
			var cellH : uint = iix.readUint16();
			if(cellW != this.pCellWidth || cellH != this.pCellHeight) {
				throw new Error("cellW != pCellWidth");
				return;
			}
			var numTiles : uint = iix.readUint16();
			Debug.trace('[IIXParser][parse] tiles num: ' + numTiles);
			for(var i : uint = 0; i < numTiles; i++) {
				var bufferLen : uint = iix.readUint32();
				Debug.trace('[IIXParser][parse]' + bufferLen);
				iix.readBuffer(new ByteArray(), bufferLen);
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
