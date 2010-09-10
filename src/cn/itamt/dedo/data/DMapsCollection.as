package cn.itamt.dedo.data {

	/**
	 * @author itamt[at]qq.com
	 */
	public class DMapsCollection extends DCollection {

		private var maps : Vector.<DMap>;

		public function DMapsCollection() {
			super();
			
			maps = new Vector.<DMap>();
		}

		public function getMap(index : uint) : DMap {
			return maps[index];
		}

		public function setValue(index : uint, value : DMap) : void {
			maps[index] = value;
		}
	}
}
