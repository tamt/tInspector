package cn.itamt.net.order 
{
	import flash.utils.ByteArray;
	/**
	 * 指令
	 * @author tamt
	 */
	public class Order 
	{
		private var _id:String;
		//body的length
		private var _length:uint;
		private var _body:ByteArray;
		
		public function Order(id:String, length:uint, body:ByteArray) 
		{
			_id = id;
			_length = length;
			_body = body;
		}
		
		public function get length():uint 
		{
			return _length;
		}
		
		public function get id():String 
		{
			return _id;
		}
		
		public function get body():ByteArray 
		{
			return _body;
		}
		
	}

}