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
	}
}
