package cn.itamt.utils.inspector.events {
	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * @author itamt[at]qq.com
	 */
	public class PopupEvent extends Event {

		public static const ADD : String = 'add_popup';
		public static const REMOVE : String = 'remove_popup';
		
		//要弹出的对象
		public var popup : DisplayObject;

		public function PopupEvent(type : String, popup : DisplayObject, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
			
			this.popup = popup;
		}
	}
}
