package cn.itamt.zhenku 
{
	import cn.itamt.display.tSprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class ZhenkuVideo extends tSprite
	{
		private var _connection:NetConnection;
		private var _stream:NetStream;
		private var _video:Video;
		
		private var _width:int;
		private var _height:int;
		
		public function ZhenkuVideo(w:int = 320, h:int = 240) 
		{
			_width = w;
			_height = h;
		}
		
		override protected function onAdded():void {
			_connection = new NetConnection();
			_connection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_connection.connect("rtmp://localhost/vod");
			
			_stream = new NetStream(_connection);
            _stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
            _stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			
			_video = new Video();
			addChild(_video);
		}
		
		override protected function onRemoved():void {
			_connection.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_connection.close();
			_connection = null;
			
            _stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
            _stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			_stream.close();
			_stream = null;
			
			_video = null;
		}
		
		private function onNetStatus(e:NetStatusEvent):void 
		{
			trace(e.info.code);
			switch(e.info.code) {
				case "NetConnection.Connect.Success":
					//_stream
					_video.attachNetStream(_stream);
					_stream.play("rtmp://localhost/vod/mp4:sample1_1500kbps.f4v");
					break;
				case "NetStream.Play.StreamNotFound":
					break;
			}
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void 
		{
			trace("onSecurityError: " + e.toString());
		}
		
		private function onAsyncError(e:AsyncErrorEvent):void 
		{
			trace("onAsyncError: " + e.toString());
		}
		
		/**
		 * 播放
		 */
		public function play(url:String):void {
			//_stream.play(url, 0, 100, true);
			//_video.attachNetStream(_stream);
		}
	}

}