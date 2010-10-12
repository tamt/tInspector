package cn.itamt.dedo.data {
	/**
	 * @author itamt[at]qq.com
	 */
	public class DMapCharactersCollection extends DCollection {
		private var _ids : Vector.<uint>;
		private var _posx : Vector.<uint>;
		private var _posy : Vector.<uint>;
		private var _names : Vector.<String>;

		public function DMapCharactersCollection():void {
			_ids = new Vector.<uint>();
			_posx = new Vector.<uint>();
			_posy = new Vector.<uint>();
			_names = new Vector.<String>();
		}

		public function setCharacter(index : uint, id : uint, x : uint, y : uint, name : String = null):void {
			_ids[index] = id;
			_posx[index] = x;
			_posy[index] = y;
			_names[index] = name;
		}

		public function getCharacterX(index : uint):uint {
			return _posx[index];
		}

		public function getCharacterY(index : uint):uint {
			return _posy[index];
		}

		public function getCharacterId(index : uint):uint {
			return _ids[index];
		}

		public function getCharacterName(index : uint):String {
			return _names[index];
		}

		public function get length():uint {
			return _ids.length;
		}
	}
}
