package cn.itamt.utils.inspector.events {
	import flash.events.Event;		

	/**
	 * @author itamt@qq.com
	 */
	public class InspectorViewEvent extends Event {
		public static const OPEN : String = 'open inspector view';		public static const CLOSE : String = 'close inspector view';

		public var id : String;

		/**
		 * @param type		
		 * @param id		InspectorView的ID
		 * @param bubbles
		 */
		public function InspectorViewEvent(type : String, id : String, bubbles : Boolean = true) {
			this.id = id;
			super(type, bubbles, true);
		}
	}
}
