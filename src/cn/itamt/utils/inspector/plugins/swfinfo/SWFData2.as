package cn.itamt.utils.inspector.plugins.swfinfo 
{
	import com.codeazur.utils.BitArray;
	import flash.geom.Rectangle;
	import flash.utils.Endian;
	
	/**
	 * 
	 * @author tamt
	 */
	public class SWFData2 extends BitArray 
	{
		public static const FLOAT16_EXPONENT_BASE:Number = 15;
		
		public function SWFData2() 
		{
			endian = Endian.LITTLE_ENDIAN;
		}
		
		/////////////////////////////////////////////////////////
		// Integers
		/////////////////////////////////////////////////////////
		
		public function readSI8():int {
			resetBitsPending();
			return readByte();
		}

		public function readSI16():int {
			resetBitsPending();
			return readShort();
		}
		
		public function readSI32():int {
			resetBitsPending();
			return readInt();
		}
		
		public function readUI8():uint {
			resetBitsPending();
			return readUnsignedByte();
		}
		
		public function readUI16():uint {
			resetBitsPending();
			return readUnsignedShort();
		}
		
		public function readUI24():uint {
			resetBitsPending();
			var loWord:uint = readUnsignedShort();
			var hiByte:uint = readUnsignedByte();
			return (hiByte << 16) | loWord;
		}
		
		public function readUI32():uint {
			resetBitsPending();
			return readUnsignedInt();
		}
		
		/////////////////////////////////////////////////////////
		// Fixed-point numbers
		/////////////////////////////////////////////////////////
		
		public function readFIXED():Number {
			resetBitsPending();
			return readInt() / 65536;
		}
		
		public function readFIXED8():Number {
			resetBitsPending();
			return readShort() / 256;
		}

		/////////////////////////////////////////////////////////
		// Floating-point numbers
		/////////////////////////////////////////////////////////
		
		public function readFLOAT():Number {
			resetBitsPending();
			return readFloat();
		}

		public function readDOUBLE():Number {
			resetBitsPending();
			return readDouble();
		}

		public function readFLOAT16():Number {
			resetBitsPending();
			var word:uint = readUnsignedShort();
			var sign:int = ((word & 0x8000) != 0) ? -1 : 1;
			var exponent:uint = (word >> 10) & 0x1f;
			var significand:uint = word & 0x3ff;
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
		
		public function readEncodedU32():uint {
			resetBitsPending();
			var result:uint = readUnsignedByte();
			if (result & 0x80) {
				result = (result & 0x7f) | (readUnsignedByte() << 7);
				if (result & 0x4000) {
					result = (result & 0x3fff) | (readUnsignedByte() << 14);
					if (result & 0x200000) {
						result = (result & 0x1fffff) | (readUnsignedByte() << 21);
						if (result & 0x10000000) {
							result = (result & 0xfffffff) | (readUnsignedByte() << 28);
						}
					}
				}
			}
			return result;
		}

		/////////////////////////////////////////////////////////
		// Bit values
		/////////////////////////////////////////////////////////
		
		public function readUB(bits:uint):uint {
			return readBits(bits);
		}

		public function readSB(bits:uint):int {
			var shift:uint = 32 - bits;
			return int(readBits(bits) << shift) >> shift;
		}
		
		public function readFB(bits:uint):Number {
			return Number(readSB(bits)) / 65536;
		}
		
		/////////////////////////////////////////////////////////
		// String
		/////////////////////////////////////////////////////////
		
		public function readString():String {
			var index:uint = position;
			while (this[index++]) {}
			resetBitsPending();
			return readUTFBytes(index - position);
		}
		
		/////////////////////////////////////////////////////////
		// Labguage code
		/////////////////////////////////////////////////////////
		
		public function readLANGCODE():uint {
			resetBitsPending();
			return readUnsignedByte();
		}
		
		/////////////////////////////////////////////////////////
		// Color records
		/////////////////////////////////////////////////////////
		
		public function readRGB():uint {
			resetBitsPending();
			var r:uint = readUnsignedByte();
			var g:uint = readUnsignedByte();
			var b:uint = readUnsignedByte();
			return 0xff000000 | (r << 16) | (g << 8) | b;
		}

		public function readRGBA():uint {
			resetBitsPending();
			var rgb:uint = readRGB() & 0x00ffffff;
			var a:uint = readUnsignedByte();
			return a << 24 | rgb;
		}

		public function readARGB():uint {
			resetBitsPending();
			var a:uint = readUnsignedByte();
			var rgb:uint = readRGB() & 0x00ffffff;
			return (a << 24) | rgb;
		}
		
		/////////////////////////////////////////////////////////
		// Rectangle record
		/////////////////////////////////////////////////////////
		
		public function readRECT():Rectangle {
			resetBitsPending();
			var bits:uint = readUB(5);
			var xmin:int = readSB(bits);
			var xmax:int = readSB(bits);
			var ymin:int = readSB(bits);
			var ymax:int = readSB(bits);
						
			var rect:Rectangle = new Rectangle();
			rect.x = xmin;
			rect.y = ymin;
			rect.width = xmax - xmin;
			rect.height = ymax - ymin;
			
			return rect;
		}
	}

}