package cn.itamt.utils {
	import flash.utils.ByteArray;

	/**
	 * @author itamt[at]qq.com
	 */
	public class IIX {
		private var _ba : ByteArray;

		public function set position(value : uint) :void {
			_ba.position = value;
		}

		public function get position():uint {
			return _ba.position;
		}

		public function IIX(ba : ByteArray):void {
			this._ba = ba;
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
					end = _ba.position - 1;
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
			// var t : uint = _ba.readUnsignedInt();
			// _ba.readByte();
			// return t;
			var t : ByteArray = new ByteArray();
			_ba.readBytes(t, 0, 4);
			var h1 : uint = t.readUnsignedShort();
			var h2 : uint = t.readUnsignedShort();
			Debug.trace('[IIX][readUint32]' + h1.toString(16) + ", " + h2.toString(16));
			var i : uint = h1 + h2;
			return i;
		}

		public function readBuffer(byteArray : ByteArray, bufferLen : uint) : void {
			_ba.readBytes(byteArray, 0, bufferLen);
			Debug.trace('[IIX][readBuffer]' + byteArray.readUTFBytes(4));
		}
	}
}
