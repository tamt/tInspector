package cn.itamt.net.order.model.server 
{
	import cn.itamt.net.order.Order;
	/**
	 * ...
	 * @author tamt
	 */
	public class ServerTransferResultData implements IServerOrderData 
	{
		//发送者的用户名
		private var _name:String;
		private var _dataId:uint;
		
		public function ServerTransferResultData() 
		{
			
		}
		
		public function decode(order:Order):void 
		{
			var nameL:uint = order.body.readByte();
			_name = order.body.readString(nameL);
			_dataId = order.body.read32uint();
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get dataId():uint 
		{
			return _dataId;
		}
		
	}

}