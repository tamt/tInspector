package cn.itamt.net 
{
	import cn.itamt.net.order.OrderByteArray;

	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * tSocket
	 * @author tamt
	 */
	public class tSocket extends Socket 
	{
		
		public function tSocket()
		{
			this.endian = Endian.LITTLE_ENDIAN;
		}
		
		public function readOrderId():uint {
			return this.readByte();
		}
		
		public function readOrderLength():uint {
			return this.readUnsignedShort();
		}
		
		/**
		 * 把数据读入一个字节数组中, 数据会接在bytes已有数据之后.
		 * @param	bytes
		 * @param	offset
		 * @param	length
		 */
		override public function readBytes (bytes:ByteArray, offset:uint = 0, length:uint = 0) : void {
			var ba:OrderByteArray = new OrderByteArray();
			super.readBytes(ba, offset, length);
			bytes.writeBytes(ba);
			//super.readBytes(bytes, offset, length);
		}
		
	}

}