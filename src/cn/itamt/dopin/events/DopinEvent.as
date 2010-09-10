package cn.itamt.dopin.events {
	import cn.itamt.dopin.BaseDopin;

	import flash.events.Event;		

	/**
	 * @author tamt
	 */
	public class DopinEvent extends Event {

		private var _dopin : BaseDopin;

		public function get dopin() : BaseDopin {
			return _dopin;
		}

		public function DopinEvent(dopin : BaseDopin, type : String, bubbles : Boolean = false,cancelable : Boolean = false) {
			this._dopin = dopin;
			
			super(type, bubbles, cancelable);
		}
	}
}
