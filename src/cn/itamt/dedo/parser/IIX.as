package cn.itamt.dedo.parser {
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * @author itamt[at]qq.com
	 */
	public class IIX {
		private var _ba : ByteArray;

		public function get bytesAvialiable() : uint {
			return _ba.bytesAvailable;
		}

		public function set position(value : uint) :void {
			_ba.position = value;
		}

		public function get position():uint {
			return _ba.position;
		}

		public function IIX(ba : ByteArray):void {
			this._ba = ba;
			this._ba.endian = Endian.LITTLE_ENDIAN;
		}

		public function readString(length : uint):String {
			var str : String;
			var pos : uint = _ba.position;
			if(length > _ba.bytesAvailable)
				length = _ba.bytesAvailable;
			var end : uint = _ba.position + length;
			var i : uint;
			while(i++ < length) {
				if(_ba.readByte() == 0 && i > 1) {
					end = _ba.position;
					break;
				}
			}
			_ba.position = pos;
			str = _ba.readUTFBytes(end - pos);
			return str;
		}

		public function readUint8() : uint {
			return _ba.readByte();
		}

		public function readUint16() : uint {
			return _ba.readUnsignedShort();
		}

		public function readUint32() : uint {
			var t : uint = _ba.readUnsignedInt();
			return t;
		}

		public function readBuffer(byteArray : ByteArray, bufferLen : uint) : void {
			_ba.readBytes(byteArray, 0, bufferLen);
		}
	}
}
