package cn.itamt.utils.inspector.plugins.swfinfo {
	import flash.utils.ByteArray;

	/**
	 * @author itamt@qq.com
	 */
	public class SWFParser {
		
		/**
		 * 解析头部
		 */
		public function parseHeader(swf : SWFData2) : SWFHeader {
			var header:SWFHeader = new SWFHeader();
			header.sign1 = swf.readUI8();
			header.sign2 = swf.readUI8();
			header.sign3 = swf.readUI8();
			header.version = swf.readUI8();
			header.fileLength = swf.readUI32();
			header.frameSize = swf.readRECT();
			header.frameRate = swf.readFIXED8();
			header.frameCount = swf.readUI16();

			return header;
		}
		
		public function parseSetBackgroundColor(swf:SWFData2):uint{
			while (true) {
				var tagTypeAndLength:uint = swf.readUI16();
				var tagLength:uint = tagTypeAndLength & 0x003f;
				var tagType:uint = tagTypeAndLength >> 6;
				if (tagLength == 0x3f) {
					// The SWF10 spec sez that this is a signed int.
					// Shouldn't it be an unsigned int?
					tagLength = swf.readSI32();
				}
				
				var pos:uint = swf.position;
				if (tagType == 0) {
					break;
				}else if (tagType == 9) {
					var rgb:uint = swf.readRGB();
					trace("bgcolor: " + rgb.toString(16));
					return rgb;
				}
				swf.position += tagLength;
			}
			
			return 0xffffff;
		}
	}
}
