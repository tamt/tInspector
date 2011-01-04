package cn.itamt.utils.inspector.plugins.swfinfo 
{
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author tamt
	 */
	public class SWFHeader 
	{
		public var sign1:uint;
		public var sign2:uint;
		public var sign3:uint;
		
		public var version:uint;
		public var fileLength:uint;
		public var frameSize:Rectangle;
		public var frameRate:uint;
		public var frameCount:uint;
		
		public function SWFHeader()
		{
			
		}
		
		public function toString():String {
			return "sign: " + sign1.toString(16) + sign2.toString(16) + sign3.toString(16) + ", version: " + version + ", fileLength: " + fileLength + ", frameSize: " + frameSize.toString() + ", frameRate: " + frameRate + ", frameCount: " + frameCount;
		}
		
	}

}