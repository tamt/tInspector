package cn.itamt.net.order.model.server 
{
	import cn.itamt.net.order.Order;
	import cn.itamt.net.order.OrderByteArray;
	/**
	 * 客户接收到服务端转发过来游戏数据.
	 * @author tamt
	 */
	public class ServerTransferData implements IServerOrderData 
	{
		private var _data:*;
		private var _dataId:uint;
		private var _name:String;
		
		public function ServerTransferData() 
		{
			
		}
		
		public function decode(order:Order):void {
			order.body.position = 0;
			var nameL:uint = order.body.readByte();
			_name = order.body.readString(nameL);
			_dataId = order.body.read32uint();
			var dataL:uint = order.body.read16int();
			var objBa:OrderByteArray = new OrderByteArray();
			order.body.readBytes(objBa, 0, order.body.bytesAvailable);
			//Debug.trace("解码数据: " + objBa.toString());
			objBa.uncompress();
			_data = objBa.readObject();
		}
		
		public function toString():String {
			var str:String;
			str = "name: " + _name + ", dataId: " + _dataId + ", data: " + _data;
			return str;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get data():*
		{
			return _data;
		}
		
	}

}