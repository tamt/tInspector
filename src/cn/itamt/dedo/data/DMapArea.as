package cn.itamt.dedo.data {
	/**
	 * @author itamt[at]qq.com
	 */
	public class DMapArea {
		private var _left : uint;
		private var _top : uint;
		private var _right : uint;
		private var _bottom : uint;

		private var _width : uint;
		private var _height : uint;

		public function DMapArea(left : uint, top : uint, right : uint, bottom : uint):void {
			this._left = left;
			this._top = top;
			this._right = right;
			this._bottom = bottom;

			_width = _right - _left;
			_height = _bottom - _top;
		}

		public function contains(x : uint, y : uint):Boolean {
			return x >= this.left && x <= this.right && y >= this.top && y <= this.bottom;
		}

		public function toString() : String {
			return "left:" + left + ",top: " + top + ",right:" + right + ",bottom:" + bottom;
		}

		public function get left() : uint {
			return _left;
		}

		public function set left(left : uint) : void {
			_left = left;
//			_right = _left + _width;
		}

		public function get top() : uint {
			return _top;
		}

		public function set top(top : uint) : void {
			_top = top;
//			_bottom = _top + _height;
		}

		public function get right() : uint {
			return _right;
		}

		public function set right(right : uint) : void {
			_right = right;
//			_left = _right - _width;
		}

		public function get bottom() : uint {
			return _bottom;
		}

		public function set bottom(bottom : uint) : void {
			_bottom = bottom;
//			_top = _bottom - _height;
		}

		public function get width() : uint {
			return _width;
		}

		public function get height() : uint {
			return _height;
		}
	}
}
