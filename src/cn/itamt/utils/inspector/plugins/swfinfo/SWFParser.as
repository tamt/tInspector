package cn.itamt.utils.inspector.plugins.swfinfo {
	import flash.utils.ByteArray;

	/**
	 * @author itamt@qq.com
	 */
	public class SWFParser {

		/**
		 * 解析头部
		 */
		public function parseHeader(swf : ByteArray) : void {
		}

		/**
		 * 解析文件属性
		 */
		public function parseFileAttributes(swf : ByteArray) : void {
		}

		/////////////////////////////////////////////////////////
		// Integers
		/////////////////////////////////////////////////////////
		/**
		 * 读取一个Signed 8-bit integer value
		 */
		private function readSI8(ba : ByteArray) : int {
			var value : int;
			value = ba.readByte();
			return value;
		}

		/**
		 * 读取一个Signed 16-bit integer value
		 */
		private function readSI16(ba : ByteArray) : int {
			var value : int;
			value = ba.readShort();
			return value;
		}

		/**
		 * 读取一个Signed 32-bit integer value
		 */
		private function readSI32(ba : ByteArray) : int {
			var value : int;
			value = ba.readInt();
			return value;
		}

		/**
		 * 读取一个SI8数组，num指个数
		 */
		private function readSI8Arr(ba : ByteArray, num : uint) : Array {
			var arr : Array = [];
			for(var i : int = 0;i < num;i++) {
				arr[i] = readSI8(ba);
			}
			return arr;
		}

		/**
		 * 读取一个SI16数组，num指个数
		 */
		private function readSI16Arr(ba : ByteArray, num : uint) : Array {
			var arr : Array;
			for(var i : int = 0;i < num;i++) {
				arr[i] = readSI16(ba);
			}
			return arr;
		}

		/**
		 * 读取一个Unsigned 8-bit integer value
		 */
		private function readUI8(ba : ByteArray) : uint {
			var value : uint;
			value = ba.readUnsignedByte();
			return value;
		}

		/**
		 * 读取一个Unsigned 16-bit integer value
		 */
		private function readUI16(ba : ByteArray) : uint {
			var value : uint;
			value = ba.readUnsignedShort();
			return value;
		}

		
		private function readUI24(ba : ByteArray) : uint {
			var loWord : uint = readUI16(ba);
			var hiByte : uint = readUI8(ba);
			return (hiByte << 16) | loWord;
		}

		/**
		 * 读取一个Unsigned 32-bit integer value
		 */
		private function readUI32(ba : ByteArray) : uint {
			var value : uint;
			value = ba.readUnsignedInt();
			return value;
		}

		private function readUI64(ba : ByteArray) : uint {
			var loWord : uint = readUI32(ba);
			var hiWord : uint = readUI32(ba);
			return (hiWord << 32) | loWord;			
		}

		/**
		 * 读取一个UI8数组，num指个数
		 */
		private function readUI8Arr(ba : ByteArray, num : uint) : Array {
			var arr : Array = [];
			for(var i : int = 0;i < num;i++) {
				arr[i] = readUI8(ba);
			}
			return arr;
		}

		
		/**
		 * 读取一个UI16数组，num指个数
		 */
		private function readUI16Arr(ba : ByteArray, num : uint) : Array {
			var arr : Array = [];
			for(var i : int = 0;i < num;i++) {
				arr[i] = readUI16(ba);
			}
			return arr;
		}

		/**
		 * 读取一个UI24数组，num指个数
		 */
		private function readUI24Arr(ba : ByteArray, num : uint) : Array {
			var arr : Array = [];
			for(var i : int = 0;i < num;i++) {
				arr[i] = readUI24(ba);
			}
			return arr;
		}

		
		/**
		 * 读取一个UI32数组，num指个数
		 */
		private function readUI32Arr(ba : ByteArray, num : uint) : Array {
			var arr : Array = [];
			for(var i : int = 0;i < num;i++) {
				arr[i] = readUI32(ba);
			}
			return arr;
		}

		/**
		 * 读取一个UI64数组，num指个数
		 */
		private function readUI64Arr(ba : ByteArray, num : uint) : Array {
			var arr : Array;
			for(var i : int = 0;i < num;i++) {
				arr[i] = readUI64(ba);
			}
			return arr;
		}

		
		/////////////////////////////////////////////////////////
		// Fixed-point numbers
		/////////////////////////////////////////////////////////

		private function readFIXED(ba : ByteArray) : Number {
			var num : Number;
			num = ba.readInt() / 65536;
			return num;
		}

		private function readFIXED8(ba : ByteArray) : Number {
			var num : Number;
			num = ba.readShort() / 256;
			return num;
		}

		/////////////////////////////////////////////////////////
		// Floating-point numbers
		/////////////////////////////////////////////////////////

		public function readFLOAT(ba : ByteArray) : Number {
			return ba.readFloat();
		}

		public function readDOUBLE(ba : ByteArray) : Number {
			return ba.readDouble();
		}

		public function readFLOAT16(ba : ByteArray) : Number {
			var FLOAT16_EXPONENT_BASE : Number = 16;
			
			var word : uint = ba.readUnsignedShort();
			var sign : int = ((word & 0x8000) != 0) ? -1 : 1;
			var exponent : uint = (word >> 10) & 0x1f;
			var significand : uint = word & 0x3ff;
			if (exponent == 0) {
				if (significand == 0) {
					return 0;
				} else {
					// subnormal number
					return sign * Math.pow(2, 1 - FLOAT16_EXPONENT_BASE) * (significand / 1024);
				}
			}
			if (exponent == 31) { 
				if (significand == 0) {
					return (sign < 0) ? Number.NEGATIVE_INFINITY : Number.POSITIVE_INFINITY;
				} else {
					return Number.NaN;
				}
			}
			// normal number
			return sign * Math.pow(2, exponent - FLOAT16_EXPONENT_BASE) * (1 + significand / 1024);
		}

		/////////////////////////////////////////////////////////
		// Encoded integer
		/////////////////////////////////////////////////////////

		public function readEncodedU32(ba : ByteArray) : uint {
			var result : uint = ba.readUnsignedByte();
			if (result & 0x80) {
				result = (result & 0x7f) | (ba.readUnsignedByte() << 7);
				if (result & 0x4000) {
					result = (result & 0x3fff) | (ba.readUnsignedByte() << 14);
					if (result & 0x200000) {
						result = (result & 0x1fffff) | (ba.readUnsignedByte() << 21);
						if (result & 0x10000000) {
							result = (result & 0xfffffff) | (ba.readUnsignedByte() << 28);
						}
					}
				}
			}
			return result;
		}
	}
}
