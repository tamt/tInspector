package cn.itamt.net.order 
{
	import cn.itamt.net.order.model.OrderDataMap;
	import cn.itamt.net.order.model.server.IServerOrderData;

	import flash.events.Event;
	/**
	 * 服务端指令事件, 由OrderManager发出.
	 * @author tamt
	 */
	public class OrderEvent extends Event
	{
		public static const WAIT_RESPONSE:String = "order_waiting_response";
		public static const RECEIVE_RESPONSE:String = "order_receive_response";
		public static const NO_RESPONSE:String = "order_no_response";
		
		private var _order:Order;
		private var _data:IServerOrderData;
		
		public function OrderEvent(idStr:String, order:Order, bubbles:Boolean = false, cancleable:Boolean = false ) 
		{
			super(idStr, bubbles, cancelable);
			
			_order = order;
			if(_order)_data = OrderDataMap.getDecoderByOrderId(order.id);
			if(_data)_data.decode(order);
		}
		
		public function get order():Order 
		{
			return _order;
		}
		
		public function get data():IServerOrderData 
		{
			return _data;
		}
		
	}

}