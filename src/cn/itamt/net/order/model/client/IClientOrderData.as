package cn.itamt.net.order.model.client 
{
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author tamt
	 */
	
	public interface IClientOrderData
	{
		function encode():ByteArray;
		//function get orderId():uint;
	}
	
}