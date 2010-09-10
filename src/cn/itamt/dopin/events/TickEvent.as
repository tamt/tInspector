package cn.itamt.dopin.events {
	import flash.events.Event;		

	/**
	 * @author tamt
	 */
	public class TickEvent extends Event {
		/**
		 * 实际上便是ENTER_FRAME
		 */		
		public static const TICK : String = "tick";

		/**
		 * 两次发布事件的毫秒间隔
		 */		
		public var interval : int;

		/**
		 * 用于Tick的发布事件
		 * 
		 * @param type	类型
		 * @param interval	两次事件的毫秒间隔
		 * 
		 */
		public function TickEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false, interval : uint = 0) {
			super(type, bubbles, cancelable);
		}
	}
}
