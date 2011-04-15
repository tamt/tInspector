package cn.itamt.net.order.model.client 
{
	import cn.itamt.net.order.OrderByteArray;

	import flash.utils.ByteArray;
	/**
	 * Client登录数据包模型
	 * @author tamt
	 */
	public class LoginData implements IClientOrderData
	{
		public var userName:String;
		public var roomId:uint;
		
		public function LoginData(userName:String, roomId:uint) 
		{
			this.userName = userName;
			this.roomId = roomId;
		}
		
		public function encode():ByteArray{
			var order:OrderByteArray = new OrderByteArray;
			order.writeByte(OrderByteArray.getStringLength(userName));
			order.writeString(userName);
			order.writeUnsignedInt(roomId);
			return order;
		}
	}

}