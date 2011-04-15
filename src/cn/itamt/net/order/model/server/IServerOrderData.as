package cn.itamt.net.order.model.server 
{
	import cn.itamt.net.order.Order;
	
	/**
	 * ...
	 * @author tamt
	 */
	public interface IServerOrderData 
	{
		function decode(order:Order):void;
	}
	
}