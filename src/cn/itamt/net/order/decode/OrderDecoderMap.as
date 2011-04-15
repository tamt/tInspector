package cn.itamt.net.order.decode 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author tamt
	 */
	public class OrderDecoderMap 
	{
		private static var _map:Dictionary;
		
		public static function register(orderId:uint, decoder:IOrderDecoder):void {
			if (_map == null)_map = new Dictionary();
			_map[orderId] = decoder;
		}
		
		public static function unregister(orderId:uint):void {
			_map[orderId] = null;
			delete _map[orderId];
		}
		
		public static function getDecoder(orderId:uint):IOrderDecoder{
			return _map[orderId];
		}
		
	}

}