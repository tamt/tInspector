package cn.itamt.net.order 
{
	import flash.events.Event;
	/**
	 * 指令事件, 由OrderManager发出.
	 * @author tamt
	 */
	public class OrderEvent extends Event
	{
		private var _order:Order;
		
		public function OrderEvent(id:String, order:Order, bubbles:Boolean = false, cancleable:Boolean = false ) 
		{
			super(id, bubbles, cancelable);
			
			_order = order;
		}
		
		public function get order():Order 
		{
			return _order;
		}
		
	}

}