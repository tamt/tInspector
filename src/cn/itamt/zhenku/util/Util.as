package cn.itamt.zhenku.util 
{
	/**
	 * ...
	 * @author tamt
	 */
	public class Util 
	{
		
		public function Util() 
		{
			
		}
		
		/**
		 * 把时间(毫秒)转化成00:00的格式
		 * @param	time
		 * @return
		 */
		public static function time2Str(time:uint):String {
			var s:int = time / 1000;
			var m:int = s / 60;
			s %= 60;
			
			return "" + int(m / 10) + int(m % 10) + ":" + int(s / 10) + int(s % 10);
		}
		
	}

}