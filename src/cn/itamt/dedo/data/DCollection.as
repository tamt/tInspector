package cn.itamt.dedo.data {

	/**
	 * 使用DCollection来尽量减少自定义的数据类型.因为自定义数据类型会比较占内存.
	 * <example>
	 * 例如, 要存储5个点, 一般的存储方式可能是:
	 * [Point, Point, Point, Point, Point];
	 * 而使用DCollection的方式, 会分为两个数组, 分别存储x, y值. 如下:
	 * [x0, x1, x2, x3, x4];
	 * [y0, y1, y2, y3, y4];
	 * </example>
	 * @author itamt[at]qq.com
	 */
	public class DCollection {

		public function DCollection() : void {
		}
	}
}
