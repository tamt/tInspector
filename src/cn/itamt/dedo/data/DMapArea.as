package cn.itamt.dedo.data {
	import cn.itamt.utils.Debug;
	/**
	 * @author itamt[at]qq.com
	 */
	public class DMapArea {
		public var left : uint;
		public var top : uint;
		public var right : uint;
		public var bottom : uint;

		public function DMapArea(left : uint, top : uint, right : uint, bottom : uint):void {
			this.left = left;
			this.top = top;
			this.right = right;
			this.bottom = bottom;
		}

		public function contains(x : uint, y : uint):Boolean {
			return x >= this.left && x <= this.right && y >= this.top && y <= this.bottom;
		}

		public function toString() : String {
			return "left:" + left + ",top: " + top + ",right:" + right + ",bottom:" + bottom;
		}
	}
}
