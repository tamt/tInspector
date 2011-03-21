package cn.itamt.zhenku.event 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class ZhenkuVideoEvent extends Event 
	{
		static public const SEEK:String = "zk_video_seek";
		static public const PLAY:String = "zk_video_play";
		static public const VOLUME:String = "zk_video_volume";
		static public const LOADING:String = "zk_video_loading";		
		public static const META_DATA:String = "zk_video_meta_data";
		public static const START:String = "zk_video_start";
		public static const STOP:String = "zk_video_stop";
		public static const PAUSE:String = "zk_video_pause";
		public static const PLAYING:String = "zk_video_playing";
		public static const BUFFER_ING:String = "zk_video_bufferring";
		public static const BUFFER_ED:String = "zk_video_bufferred";
		
		public function ZhenkuVideoEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
		}
		
	}

}