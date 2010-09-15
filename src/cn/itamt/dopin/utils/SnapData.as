package cn.itamt.dopin.utils {
	import flash.display.BitmapData;	

	/**
	 * 拍照数据.
	 * @author tamt
	 */
	public class SnapData {
		public var offsetX : Number;
		public var offsetY : Number;
		public var bmd : BitmapData;

		/**
		 * 拍照后的位图
		 * @param offsetX	拍照后的位图与原本的坐标偏移X		 * @param offsetY	拍照后的位图与原本的坐标偏移Y
		 */
		public function SnapData(offsetX : Number, offsetY : Number, bmd : BitmapData) : void {
			this.offsetX = offsetX;
			this.offsetY = offsetY;
			this.bmd = bmd;
		}
	}
}
