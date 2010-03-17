package cn.itamt.utils.inspector.events {
	import flash.events.Event;						

	/**
	 * @author itamt@qq.com
	 */
	public class InspectorFilterEvent extends Event {
		public static const CHANGE : String = "inspector_change_filter";

		public var filter : Class;

		public function InspectorFilterEvent(type : String, filter : Class, bubbles : Boolean = false, cancelable : Boolean = false) {
			this.filter = filter;
			super(type, bubbles, cancelable);
		}
	}
}
