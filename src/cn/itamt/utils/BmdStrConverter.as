package cn.itamt.utils {
	import flash.display.BitmapData;
	import flash.utils.ByteArray;	

	/**
	 * 用于：位图数据与Base64字符串转换
	 * @author itamt@qq.com
	 */
	public class BmdStrConverter {
		
		/**
		 * 位图数据转换成string
		 */
		public static function bmd2str(bmd:BitmapData):String{
			var str:String;
			
			var ba:ByteArray = new ByteArray();
			//存储位图的长、宽、透明模式
			ba.writeUnsignedInt(bmd.width);
			ba.writeUnsignedInt(bmd.height);
			ba.writeBoolean(bmd.transparent);
			//存储位图数据
			ba.writeBytes(bmd.getPixels(bmd.rect));
			
			//编码成Base64字符串
			str = Base64.encodeByteArray(ba);
			
			return str;
		}
		
		/**
		 * 解码使用bmd2str()编码的位图数据字符串
		 */
		public static function str2bmd(base64Str:String):BitmapData{
			var bmd:BitmapData;
			
			var ba:ByteArray = Base64.decodeToByteArray(base64Str);
			bmd = new BitmapData(ba.readUnsignedInt(), ba.readUnsignedInt(), ba.readBoolean(), 0x00000000);
			bmd.setPixels(bmd.rect, ba);
			
			return bmd;
		}
	}
}
