package cn.itamt.dedo.data {
	/**
	 * @author itamt[at]qq.com
	 */
	public class DMap {
		public var index : uint;
		public var name : String;
		public var cellsx : uint;
		public var cellsy : uint;
		public var cellwidth : uint;
		public var cellheight : uint;
		public var layers : DMapLayersCollection;
		public var jumps : DMapJumpsCollection;
		public var characters : DMapCharactersCollection;
		public var blocks : DMapBlocksCollection;

		public function DMap() : void {
		}

		/**
		 * 返回在某个区域内是不是含有动画元素
		 */
		public function hasAnimationInArea(area : DMapArea):Boolean {
			return layers.hasAnimationInArea(area);
		}

		/**
		 * 返回在某个区域内是不是含有角色
		 */
		public function hasCharacterInArea(area : DMapArea):Boolean {
			return characters.hasCharacterInArea(area);
		}
	}
}
