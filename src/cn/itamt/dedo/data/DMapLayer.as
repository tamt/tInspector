package cn.itamt.dedo.data {
	/**
	 * @author itamt[at]qq.com
	 */
	public class DMapLayer {
		public var index : uint;
		public var name : String;
		public var visible : Boolean;
		public var cells : DMapCellsCollection;

		public function DMapLayer() : void {
		}

		/**
		 * 返回在某个区域内是不是含有动画元素
		 */
		public function hasAnimationInArea(area : DMapArea):Boolean {
			return cells.hasAnimationInArea(area);
		}
	}
}
