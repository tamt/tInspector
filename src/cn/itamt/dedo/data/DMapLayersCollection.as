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

		/**
		 * 返回在某个区域内是不是含有动画元素
		 */
		public function hasAnimationInArea(area : DMapArea):Boolean {
			for(var i : int = 0; i < layers.length; i++) {
				if(layers[i].hasAnimationInArea(area)) {
					return true;
					break;
				}
			}
			return false;
		}
	}
}
