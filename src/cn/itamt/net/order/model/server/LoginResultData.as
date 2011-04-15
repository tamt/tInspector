package cn.itamt.net.order.model.server 
{
	import cn.itamt.net.order.Order;
	/**
	 * ...
	 * @author tamt
	 */
	public class LoginResultData implements IServerOrderData
	{
		private var _code:uint;
		private var _msg:String;
		
		public function LoginResultData() 
		{
			
		}
		
		public function decode(order:Order):void {
			order.body.position = 0;
			_code = order.body.readByte();
			_msg = order.body.readUTFBytes(order.body.bytesAvailable);
		}
		
		public function get code():uint 
		{
			return _code;
		}
		
		public function get msg():String 
		{
			return _msg;
		}
		
	}

}