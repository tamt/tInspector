package cn.itamt.utils 
{
	/**
	 * ...
	 * @author tamt
	 */
	public class GUID 
	{
		
		public function GUID() 
		{
			
		}
		
		/**
		 * [注意]这只是简单获取当前系统时间. 不是真正的GUID算法.
		 */
		public static function create():uint {
			return (new Date()).getMilliseconds();
			//return uint(Math.random() * uint.MAX_VALUE);
		}
		
	}

}