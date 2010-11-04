package msc.net {
	import flash.net.Socket;
	import flash.utils.ByteArray;

	/**
	 * as3中Socket有一个问题，就是数据在写进后就被发送了，即Socket.flush()其实是多余的。mSocket主要是通过额外的ByteArray解决这个问题的。
	 * 关于这个问题可在Google上搜索了解：<b>Flash Socket Class Does Not Wait For Flush</b>
	 * @author itamt@qq.com
	 */
	public class mSocket extends Socket {
		private var _ba : ByteArray;

		public function mSocket(host : String = null, port : int = 0) {
			_ba = new ByteArray();
			
			super(host, port);
		}

		override public function connect(host : String, port : int) : void {
			_ba.clear();
			
			super.connect(host, port);
		}

		override public function close() : void {
			_ba.clear();
			
			super.close();
		}

		override public function flush() : void {
			super.writeBytes(_ba);
			super.flush();
			
			_ba.clear();
		}

		override public function writeBoolean(value : Boolean) : void {
			_ba.writeBoolean(value);
		}

		override public function writeByte(value : int) : void {
			_ba.writeByte(value);
		}

		override public function writeBytes(bytes : ByteArray, offset : uint = 0, length : uint = 0) : void {
			_ba.writeBytes(bytes, offset, length);
		}

		override public function writeDouble(value : Number) : void {
			_ba.writeDouble(value);
		}

		override public function writeFloat(value : Number) : void {
			_ba.writeFloat(value);
		}

		override public function writeInt(value : int) : void {
			_ba.writeInt(value);
		}

		override public function writeMultiByte(value : String, charSet : String) : void {
			_ba.writeMultiByte(value, charSet);
		}

		override public function writeObject(object : *) : void {
			_ba.writeObject(object);
		}

		override public function writeShort(value : int) : void {
			_ba.writeShort(value);
		}

		override public function writeUnsignedInt(value : uint) : void {
			_ba.writeUnsignedInt(value);
		}

		override public function writeUTF(value : String) : void {
			_ba.writeUTF(value);
		}

		override public function writeUTFBytes(value : String) : void {
			_ba.writeUTFBytes(value);
		}
	}
}
