package cn.itamt.utils.inspector.events {
	import flash.display.DisplayObject;
	import flash.events.Event;	

	/**
	 * @author tamt
	 */
	public class InspectEvent extends Event {
		public static const TURN_ON : String = 'turn on';
		public static const TURN_OFF : String = 'turn off';

		public static const LIVE_INSPECT : String = 'live_inspect';
		public static const INSPECT : String = 'inspect';		public static const REFRESH : String = 'refresh';

		private var _inspectTarget : DisplayObject;

		public function get inspectTarget() : DisplayObject {
			return _inspectTarget;
		}

		public function InspectEvent(type : String, inspectTarget : DisplayObject, bubbles : Boolean = false, cancelable : Boolean = false) : void {
			_inspectTarget = inspectTarget;
			super(type, bubbles, cancelable);
		}
	}
}
