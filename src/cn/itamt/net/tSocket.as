package cn.itamt.net 
{
	import flash.net.Socket;
	
	/**
	 * Devil的socket
	 * @author tamt
	 */
	public class tSocket extends Socket 
	{
		
		public function tSocket()
		{
			
		}
		
		public function readOrderId():uint {
			return this.readByte();
		}
		
		public function readOrderLength():uint {
			return this.readUnsignedShort();
		}
		
	}

}