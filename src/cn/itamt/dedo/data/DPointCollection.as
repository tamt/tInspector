package cn.itamt.dedo.data {

	/**
	 * @author itamt[at]qq.com
	 */
	public class DPointCollection extends DCollection {

		public var xs : Vector.<uint>;
		public var ys : Vector.<uint>;

		
		public function DPointCollection(length : uint = 0) {
			super();
			
			xs = new Vector.<uint>(length);
			ys = new Vector.<uint>(length);
		}
	}
}
