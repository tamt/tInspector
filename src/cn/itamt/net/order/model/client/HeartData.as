package cn.itamt.net.order.model.client 
{
	import flash.utils.ByteArray;
	/**
	 * 客户端发送的心跳包
	 * @author tamt
	 */
	public class HeartData implements IClientOrderData
	{
		
		public function HeartData() 
		{
			
		}
		
		public function encode():ByteArray 
		{
			return new ByteArray();
		}
		
	}

}