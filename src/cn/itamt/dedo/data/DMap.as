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

		public function DMap() : void {
		}
	}
}
