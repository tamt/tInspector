package cn.itamt.dopin {
	import flash.display.BitmapData;	

	/**
	 * Dopin类
	 * @author tamt
	 */
	public class Dopin extends BaseDopin {
		public function Dopin(bmd : BitmapData) : void {
			super(new DopinData(bmd));
		}
	}
}
