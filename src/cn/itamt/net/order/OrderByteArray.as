package cn.itamt.net.order 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class OrderByteArray extends ByteArray 
	{
		
		public function OrderByteArray() 
		{
			this.endian = Endian.LITTLE_ENDIAN;
		}
		
		public function writeOrderId(orderId:uint):void {
			this.writeByte(orderId);
		}
		
		public function writeOrderFullLength(length:uint):void {
			this.writeShort(length);
		}
		
		public function writeOrderBody(bytes:ByteArray):void {
			this.writeBytes(bytes);
		}
		
		public function writeString(str:String, length:uint = 0):void 
		{
			if(length == 0){
				this.writeUTFBytes(str);
			}else {
				var ba:ByteArray = new ByteArray();
				ba.writeUTFBytes(str);
				ba.length = length;
				this.writeBytes(ba);
			}
		}
		
		public function readString(nameL:uint = 0):String
		{
			if (nameL == 0) {
				return readUTFBytes(bytesAvailable);
			}else {
				return readUTFBytes(nameL);
			}
		}
		
		public function write32uint(value:uint):void {
			this.writeUnsignedInt(value);
		}
		
		public function read32uint():uint
		{
			return this.readUnsignedInt();
		}
		
		public function write16int(value:uint):void 
		{
			this.writeShort(value);
		}
		
		public function read16int():int {
			return this.readShort();
		}
		
		/**
		 * 清除. ByteArray本身的clear方法, 有错误, 故重写之.
		 */
		override public function clear():void {
			this.position = 0;
			this.length = 0;
		}
		
		override public function toString():String {
			return bytes2Str(this);
		}
		
		
		/**
		 * 得到字符串的长度(byte)
		 * @param	str
		 * @return
		 */
		public static function getStringLength(str:String):uint {
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes(str);
			return ba.length;
		}
		
		/**
		 * 得到一个对象的长度(byte)
		 * @param	str
		 * @return
		 */
		public static function getObjectLength(obj:*):uint {
			var ba:ByteArray = new ByteArray();
			ba.writeObject(obj);
			return ba.length;
		}
		
		private static function byte2Str(ba:ByteArray) : String
        {
            var str:String = "";
            var pos:int = 8;
            while (pos-- > 0)
            {
                ba.position = 0;
                str = str + ((ba.readByte() & 1 << pos) != 0 ? ("1") : ("0"));
            }
            return str;
        }
		
		/**
		 * 字节数组输出二进制字符串, 例如: 010101010
		 * @param	ba
		 * @param	hex		是否以16进制输出
		 * @return
		 */
        public static function bytes2Str(ba:ByteArray, hex:Boolean = false) : String
        {
			var str:String = "";
            var tmp:ByteArray;
            ba.position = 0;
            while (ba.bytesAvailable)
            {
                tmp = new ByteArray();
                ba.readBytes(tmp, 0, 1);
				if(!hex){
					str += (byte2Str(tmp) + ",");
				}else {
					str += "0x" + tmp.readByte().toString(16) + ",";
				}
            }
            ba.position = 0;
			
            return str;
        }
		
		
	}

}