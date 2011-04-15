package cn.itamt.net.order.model.server 
{
	import cn.itamt.net.order.Order;
	import cn.itamt.net.order.OrderByteArray;
	/**
	 * ...
	 * @author tamt
	 */
	public class ServerPlayerLeaveData implements IServerOrderData 
	{
		private var _playerName:String;
		
		public function ServerPlayerLeaveData() 
		{
			
		}
		
		public function decode(order:Order):void 
		{
			var body:OrderByteArray = order.body;
			body.position = 0;
			var nameL:uint = body.readByte();
			_playerName = body.readString(nameL);
		}
		
		public function get playerName():String 
		{
			return _playerName;
		}
		
	}

}