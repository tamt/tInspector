package cn.itamt.dopin {
	import flash.geom.Rectangle;	

	/**
	 * Dopin的状态. 目前只存储Dopin的注册点坐标, 以及它的bounds.
	 * @author tamt
	 */
	public class DopinState {

		internal var regX : int;		internal var regY : int;
		internal var bounds : Rectangle;

		public function DopinState() : void {
			bounds = new Rectangle();
		}

		public function copyFrom(dopin : BaseDopin) : void {
			this.regX = dopin.regX;
			this.regY = dopin.regY;
			
			var rect : Rectangle = dopin.getBounds();
			bounds.x = rect.x;
			bounds.y = rect.y;
			bounds.width = rect.width;
			bounds.height = rect.height;
		}

		public function dispose() : void {
			//this.bounds = null;
		}
	}
}
