package cn.itamt.net.order 
{
	/**
	 * 指令
	 * @author tamt
	 */
	public class Order 
	{
		private var _id:uint;
		//body的length
		private var _length:uint;
		private var _body:OrderByteArray;
		
		public function Order(id:uint, length:uint, body:OrderByteArray) 
		{
			_id = id;
			_length = length;
			_body = body;
			_body.position = 0;
		}
		
		public function get length():uint 
		{
			return _length;
		}
		
		public function get id():uint
		{
			return _id;
		}
		
		public function get body():OrderByteArray
		{
			return _body;
		}
		
		public function toString():String {
			return "[" + id +"]" + "[" + _length + "]";
		}
		
	}

}