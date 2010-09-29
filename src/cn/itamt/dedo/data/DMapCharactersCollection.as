package cn.itamt.dedo.data {
	/**
	 * @author itamt[at]qq.com
	 */
	public class DMapCharactersCollection {
		private var _ids : Vector.<uint>;
		private var _posx : Vector.<uint>;
		private var _posy : Vector.<uint>;

		public function DMapCharactersCollection():void {
			_ids = new Vector.<uint>();
			_posx = new Vector.<uint>();
			_posy = new Vector.<uint>();
		}

		public function setCharacter(index : uint, id : uint, x : uint, y : uint):void {
			_ids[index] = id;
			_posx[index] = x;
			_posy[index] = y;
		}

		public function getCharacterX(index : uint):uint {
			return _posx[index];
		}
	}
}
