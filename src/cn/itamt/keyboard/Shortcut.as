package cn.itamt.keyboard {

	/**
	 * 快捷键
	 * @author itamt@qq.com
	 */
	public class Shortcut {

		private var _keycodes : Array;

		public function Shortcut(keycodes : Array) : void {
			_keycodes = keycodes.sort();
		}

		public function get keycodes() : Array {
			return keycodes;
		}

		public function equalKeys(codes : Array) : Boolean {
			codes.sort();
			if(codes.length == _keycodes.length) {
				var i : int = codes.length;
				while(i-- > 0) {
					if(codes[i] != _keycodes[i])return false;
				}
				return true;
			} else {
				return false;
			}
		}

		public function toString() : String {
			return _keycodes + '';
		}
	}
}
