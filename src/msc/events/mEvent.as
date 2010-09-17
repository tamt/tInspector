package msc.events {
	import flash.events.Event;

	/**
	 * @author itamt[at]qq.com
	 */
	public class mEvent extends Event {
		public function mEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
