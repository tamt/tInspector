package cn.itamt.dedo.data {
	/**
	 * @author itamt[at]qq.com
	 */
	public class DMapLayersCollection extends DCollection {
		private var layers : Vector.<DMapLayer>;

		public function DMapLayersCollection() {
			super();

			layers = new Vector.<DMapLayer>();
		}

		public function getMapLayer(index : uint) : DMapLayer {
			return layers[index];
		}

		public function setMapLayer(index : uint, value : DMapLayer) : void {
			layers[index] = value;
		}

		public function get length():uint {
			return layers.length;
		}
	}
}
