package cn.itamt.dedo.data {
	import cn.itamt.utils.Debug;

	/**
	 * @author itamt[at]qq.com
	 */
	public class DMapCharactersCollection extends DCollection {
		private var _imgs : Vector.<int>;
		private var _posx : Vector.<Number>;
		private var _posy : Vector.<Number>;
		private var _names : Vector.<String>;

		public function DMapCharactersCollection():void {
			_imgs = new Vector.<int>();
			_posx = new Vector.<Number>();
			_posy = new Vector.<Number>();
			_names = new Vector.<String>();
		}

		public function setCharacter(index : uint, img : int, x : Number, y : Number, name : String = null):void {
			_imgs[index] = img;
			_posx[index] = x;
			_posy[index] = y;
			_names[index] = name;

			Debug.trace('[DMapCharactersCollection][setCharacter]' + x + ", " + y);
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

		public function getCharacterImg(index : uint):int {
			return _imgs[index];
		}

		public function getCharacterName(index : uint):String {
			return _names[index];
		}

		public function get length():uint {
			return _imgs.length;
		}

		public function getCharacterValue(i : int) : Number {
			return .5;
		}

		public function hasCharacterInArea(area : DMapArea) : Boolean {
			var has : Boolean;
			if(length) {
				for(var i : int = 0; i < length; i++) {
					if(area.contains(getCharacterX(i), getCharacterY(i))) {
						has = true;
						break;
					}
				}
			}
			return has;
		}

		public function getCharactersInArea(area : DMapArea):Vector.<uint> {
			var indexs : Vector.<uint> = new Vector.<uint>;
			if(length) {
				for(var i : uint = 0; i < length; i++) {
					if(area.contains(getCharacterX(i), getCharacterY(i))) {
						indexs.push(i);
					}
				}
			}
			return indexs;
		}
	}
}
