package cn.itamt.zhenku.event 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class ZhenkuVideoEvent extends Event 
	{
		
		public static const META_DATA:String = "zk_video_meta_data";
		public static const START:String = "zk_video_start";
		public static const STOP:String = "zk_video_stop";
		public static const PAUSE:String = "zk_video_pause";
		public static const PLAYING:String = "zk_video_playing";
		
		public function ZhenkuVideoEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
		}
		
	}

}