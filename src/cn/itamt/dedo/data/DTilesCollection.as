package cn.itamt.dedo.data {
	/**
	 * @author itamt[at]qq.com
	 */
	public class DTilesCollection extends DCollection {
		public var fileName : String;
		public var imgIndexs : Vector.<uint>;

		public function DTilesCollection() {
			super();

			imgIndexs = new Vector.<uint>();
		}

		public function getValue(index : uint) : uint {
			return imgIndexs[index];
		}

		public function setValue(index : uint, value : uint) : void {
			imgIndexs[index] = value;
		}

		public function get length():uint {
			return this.imgIndexs.length;
		}
	}
}
