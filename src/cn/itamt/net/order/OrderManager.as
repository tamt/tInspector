package cn.itamt.net.order 
{
	import cn.itamt.utils.Debug;
	import cn.itamt.net.tSocket;
	import cn.itamt.net.order.Order;
	import cn.itamt.net.order.OrderEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.ByteArray;
	
	/**
	 * 指令管理
	 * @author tamt
	 */
	public class OrderManager extends EventDispatcher 
	{
		//粘包
		private var _fragmentOrderIdData:ByteArray;
		private var _fragmentOrderLenData:ByteArray;
		private var _fragmentOrderBody:ByteArray;
		
		private var _instance:OrderManager;
		public static function getInstance():OrderManager{
			if (_instance == null)_instance = new OrderManager(new Singleton);
			return _instance;
		}
		
		private var _socket:tSocket;
		
		public function OrderManager(se:Singleton) 
		{
		}
		
		private function onSocketStatus(e:Event):void 
		{
			Debug.trace("Socket status: " + e.type);
			switch(e.type) {
				case Event.CLOSE:
					_socket.removeEventListener(Event.CONNECT, onSocketStatus);
					_socket.removeEventListener(Event.CLOSE, onSocketStatus);
					_socket.removeEventListener(IOErrorEvent.IO_ERROR, onSocketStatus);
					_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketStatus);
					_socket.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
					_socket = null;
					break;
			}
		}
		
		/**
		 * 连接Socket服务器
		 * @param	host
		 * @param	port
		 */
		public function connect(host:String, port:String):void {
			if(_socket == null){
				_socket = new DevilSocket();
				_socket.addEventListener(Event.CONNECT, onSocketStatus);
				_socket.addEventListener(Event.CLOSE, onSocketStatus);
				_socket.addEventListener(IOErrorEvent.IO_ERROR, onSocketStatus);
				_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketStatus);
				_socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
				
				_fragmentOrderIdData = new ByteArray();
				_fragmentOrderLenData = new ByteArray();
				_fragmentOrderBody = new ByteArray();
			}

			if (!_socket.connected) {
				_socket.connect(host, port);
			}
		}
		
		/**
		 * 关闭Socket
		 */
		public function close():void {
			if (_socket.connect)_socket.close();
		}
		
		/**
		 * 收到Socket数据, 包括了对粘包的处理
		 * @param	e
		 */
		private function onSocketData(e:ProgressEvent = null):void 
		{
			while (_socket.bytesAvailable) {
				//读取Order id
				if (_fragmentOrderIdData.length < 1) {
					_socket.readBytes(_fragmentOrderIdData, 0, 1);
				}
				
				if (!_socket.bytesAvailable) break;
				
				//读取Order长度
				if (_fragmentOrderLenData.length < 2) {
					_socket.readBytes(_fragmentOrderLenData, 0, Math.min(_socket.bytesAvailable, 2 - _fragmentOrderLenData.length));
				}
				
				if (!_socket.bytesAvailable) break;
				
				//读取Order内容
				this._fragmentOrderLenData.position = 0;
				var length:uint = this._fragmentOrderLenData.readUnsignedShort() - _fragmentOrderIdData.length - _fragmentOrderLenData.length;
				if (_fragmentOrderBody.length < length) {
					_socket.readBytes(_fragmentOrderBody, 0, Math.min(_socket.bytesAvailable, length - _fragmentOrderBody.length));
				}
				
				//包信息是否已经完整读取
				if (_fragmentOrderBody.length == length) {
					_fragmentOrderIdData.position = 0;
					_fragmentOrderLenData.position = 0;
					_fragmentOrderBody.position = 0;
					
					var body:ByteArray = new ByteArray();
					_fragmentOrderBody.readBytes(body, 0, _fragmentOrderBody.bytesAvailable);
					var order:Order = new Order(_fragmentOrderIdData.readByte().toString(), length, body);
					
					_fragmentOrderBody.clear();
					_fragmentOrderIdData.clear();
					_fragmentOrderLenData.clear();
					
					//指发指令事件
					dispatchEvent(new OrderEvent(order.id, order));
				}
			}
		}
		
		/**
		 * 添加一个指令侦听
		 * @param	orderId
		 * @param	fun
		 */
		public function addOrderListener(orderId:String, fun:Function):void {
			super.addEventListener(orderId, fun);
		}
		
		/**
		 * 删除一个指令侦听
		 * @param	orderId
		 * @param	fun
		 */
		public function removeOrderListener(orderId:String, fun:Function):void {
			super.removeEventListener(orderId, fun);
		}
	}

}

class Singleton {
	public function Singleton() {}
}