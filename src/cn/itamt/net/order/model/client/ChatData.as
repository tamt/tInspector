package cn.itamt.net.order.model.client 
{
	import cn.itamt.net.order.OrderByteArray;
	import cn.itamt.utils.Debug;
	import cn.itamt.utils.GUID;

	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author tamt
	 */
	public class ChatData implements IClientOrderData 
	{
		private var _name:String;
		private var _msg:String;
		private var _time:uint;
		
		public function ChatData(name:String, msg:String) 
		{
			_name = name;
			_msg = msg;
		}
		
		public function encode():ByteArray {
			var ba:OrderByteArray = new OrderByteArray;
			var nameL:uint = OrderByteArray.getStringLength(_name);
			ba.writeByte(nameL);
			ba.writeString(_name, nameL);
			var msgId:int = GUID.create();
			ba.write32uint(msgId);
			//var time:String = "yyyyMMddHHmmss";
			var date:Date = new Date();
			var time:String = date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds();
			
			ba.writeString(time, 14);
			var msgL:int = OrderByteArray.getStringLength(_msg);
			ba.write16int(msgL);
			ba.writeString(_msg);
			Debug.trace("==========chat data==========");
			Debug.trace("nameL: " + nameL + "\nname: " + _name + "\nmsgId: " + msgId + "\ntime: " + time + "\nmsgL: " + msgL + "\nmsg: " + _msg);
			Debug.trace("Order length: " + ba.length);
			Debug.trace("==========[  end  ]==========");
			return ba;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get msg():String 
		{
			return _msg;
		}
		
		public function get time():uint 
		{
			return _time;
		}
		
	}

}