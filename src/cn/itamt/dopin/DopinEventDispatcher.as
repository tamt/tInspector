package cn.itamt.dopin {
	import flash.events.Event;
	import flash.events.EventDispatcher;	

	/**
	 * @author itamt@qq.com
	 */
	public class DopinEventDispatcher extends EventDispatcher {
		public function DopinEventDispatcher() {
			super();
		}
			
		override public function dispatchEvent(evt : Event) : Boolean {
			if(hasEventListener(evt.type) || evt.bubbles) {
				return super.dispatchEvent(evt);
			}
			return false;
		}
	}
}
