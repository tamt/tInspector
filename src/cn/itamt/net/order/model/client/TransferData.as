package cn.itamt.net.order.model.client 
{
	import cn.itamt.net.order.OrderByteArray;
	import cn.itamt.utils.GUID;

	import flash.utils.ByteArray;
	/**
	 * 客户端转发游戏数据.
	 * @author tamt
	 */
	public class TransferData implements IClientOrderData 
	{
		private var _name:String;
		private var _dataId:uint;
		private var _data:*;
		
		public function TransferData(name:String, data:*) 
		{
			_name = name;
			_data = data;
		}
		
		public function encode():ByteArray {
			var ba:OrderByteArray = new OrderByteArray();
			ba.writeByte(OrderByteArray.getStringLength(_name));
			ba.writeString(_name);
			_dataId = GUID.create();
			ba.write32uint(_dataId);
			var objBa:OrderByteArray = new OrderByteArray();
			objBa.writeObject(_data);
			objBa.compress();
			//Debug.trace("编码数据: " + objBa.toString());
			ba.write16int(objBa.length);
			ba.writeBytes(objBa);
			return ba;
		}
	}

}