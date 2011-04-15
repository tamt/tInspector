package cn.itamt.net.order.model 
{
	import cn.itamt.net.order.model.server.IServerOrderData;

	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author tamt
	 */
	public class OrderDataMap 
	{
		private static var _decoderDB:Dictionary;
		private static var _encoderDB:Dictionary;
		
		public static function mapDecoder(id:uint, serverDataType:Class):void {
			if (_decoderDB == null)_decoderDB = new Dictionary();
			_decoderDB[id] = serverDataType;
		}
		
		public static function unmapDecoder(id:uint):void {
			if (_decoderDB) {
				delete _decoderDB[id];
			}
		}
		
		public static function mapEncoder(id:uint, clientDataType:Class):void {
			if (_encoderDB == null)_encoderDB = new Dictionary();
			_encoderDB[clientDataType] = id;
		}
		
		public static function unmapEncoder(clinetDataType:Class):void {
			if (_encoderDB) {
				delete _encoderDB[clinetDataType];
			}
		}
		
		public static function getDecoderByOrderId(id:uint):IServerOrderData {
			var type:Class = _decoderDB[id];
			if (type) {
				return (new type()) as IServerOrderData;
			}
			return null;
		}
		
		public static function getOrderIdByEncoder(clinetDataType:Class):uint {
			if (_encoderDB) {
				if (_encoderDB[clinetDataType]) {
					return _encoderDB[clinetDataType]
				}else {
					throw new Error("找不到" + String(clinetDataType) + "的OrderId映射, 请先在OrderID.as中映射.");
				}
			}else {
				return 0;
			}
		}
		
	}

}