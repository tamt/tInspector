package cn.itamt.zhenku.event 
{
	import flash.events.ErrorEvent;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class ZhenkuErrorEvent extends ErrorEvent 
	{
		
		public function ZhenkuErrorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, text:String = "") 
		{
			super(type, bubbles, cancelable, text);
			
		}
		
	}

}