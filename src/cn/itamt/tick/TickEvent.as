package cn.itamt.tick 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class TickEvent extends Event
	{
		public static const TICK:String = "tick";
		
		public var interval:int;
		
		public function TickEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true) 
		{
			super(type, bubbles, cancelable);
		}
		
	}

}