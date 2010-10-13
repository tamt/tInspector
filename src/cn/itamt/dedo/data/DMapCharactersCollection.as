package cn.itamt.dedo.data {
	/**
	 * @author itamt[at]qq.com
	 */
	public class DMapCharactersCollection extends DCollection {
		private var _ids : Vector.<uint>;
		private var _posx : Vector.<Number>;
		private var _posy : Vector.<Number>;
		private var _names : Vector.<String>;

		public function DMapCharactersCollection():void {
			_ids = new Vector.<uint>();
			_posx = new Vector.<Number>();
			_posy = new Vector.<Number>();
			_names = new Vector.<String>();
		}

		public function setCharacter(index : uint, id : uint, x : Number, y : Number, name : String = null):void {
			_ids[index] = id;
			_posx[index] = x;
			_posy[index] = y;
			_names[index] = name;
		}

		public function getCharacterX(index : uint):Number {
			return _posx[index];
		}

		public function getCharacterY(index : uint):Number {
			return _posy[index];
		}

		public function setCharacterX(index : uint, x : Number):void {
			_posx[index] = x;
		}

		public function setCharacterY(index : uint, y : Number):void {
			_posy[index] = y;
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

		public function getCharacterValue(i : int) : Number {
			return .5;
		}
	}
}
