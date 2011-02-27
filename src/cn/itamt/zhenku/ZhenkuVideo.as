package cn.itamt.zhenku 
{
	import cn.itamt.display.tSprite;
	import cn.itamt.zhenku.event.ZhenkuVideoEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
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
		private var _streamClient:StreamClient;
		private var _video:Video;
		private var _url:String = "";
		
		private var _previewImg:BitmapData;
		
		private var _width:int;
		private var _height:int;
		
		//视频持续的时间(毫秒)
		private var _duration:uint = 0;
		//视频当前的播放位置(毫秒)
		private var _time:uint = 0;
		
		
		public function ZhenkuVideo(w:int = 320, h:int = 240) 
		{
			super();
			
			setSize(w, h);
		}
		
		override protected function onAdded():void {
			
			_video = new Video();
			addChild(_video);
			
			_streamClient = new StreamClient();
			_streamClient.onCuePoint = this.onCuePoint;
			_streamClient.onImageData = this.onImageData;
			_streamClient.onMetaData = this.onMetaData;
			_streamClient.onPlayStatus = this.onPlayStatus;
			_streamClient.onSeekPoint= this.onSeekPoint;
			_streamClient.onTextData= this.onTextData;
			_streamClient.onXMPData= this.onXMPData;
			
			_connection = new NetConnection();
			_connection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_connection.connect(null);
		}
		
		override protected function onRemoved():void {
			_connection.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_connection.close();
			_connection = null;
			
			removeEventListener(Event.ENTER_FRAME, onPlaying);
			
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
					connectStream();
					break;
				case "NetStream.Play.StreamNotFound":
					break;
				case "NetStream.Play.Start":
					_time = _stream.time;
					dispatchEvent(new ZhenkuVideoEvent(ZhenkuVideoEvent.START, false, true));
					addEventListener(Event.ENTER_FRAME, onPlaying);
					break;
				case "NetStream.Play.Stop":
					dispatchEvent(new ZhenkuVideoEvent(ZhenkuVideoEvent.STOP, false, true));
					removeEventListener(Event.ENTER_FRAME, onPlaying);
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
		
		private function connectStream():void {
			_stream = new NetStream(_connection);
            _stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
            _stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			_stream.client = _streamClient;
			
			//_stream
			_video.attachNetStream(_stream);
			
			//
			this.play("video/sample.f4v");
		}
		
		private function onPlaying(e:Event):void 
		{
			_time = _stream.time * 1000;
			dispatchEvent(new ZhenkuVideoEvent(ZhenkuVideoEvent.PLAYING, false, true));
		}
		
		private function onXMPData(obj:Object):void 
		{
			
		}
		
		private function onTextData(obj:Object):void 
		{
			
		}
		
		private function onSeekPoint(obj:Object):void 
		{
			
		}
		
		private function onPlayStatus(obj:Object):void 
		{
			
		}
		
		private function onImageData(obj:Object):void 
		{
			trace("[onImageData]has image data");
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(evt:Event) { 
				_previewImg = ((evt.target as LoaderInfo).content as Bitmap).bitmapData.clone(); 
			} );
			loader.loadBytes(obj.data);
		}
		
		private function onCuePoint(obj:Object):void 
		{
			
		}
		
		private function onMetaData(obj:Object):void 
		{
			traceObj(obj);
			//height: 352
			//avclevel: 30
			//audiocodecid: mp4a
			//aacaot: 2
			//videoframerate: 29.97002997002997
			//duration: 112.384
			//audiochannels: 2
			//audiosamplerate: 24000
			//moovposition: 28
			//trackinfo: [object Object],[object Object]
			//width: 640
			//seekpoints: [object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object],[object Object]
			//videocodecid: avc1
			//avcprofile: 100
			_duration = obj.duration * 1000;
			dispatchEvent(new ZhenkuVideoEvent(ZhenkuVideoEvent.META_DATA, false, true));
		}
		
		/**
		 * 设置尺寸
		 * @param	w
		 * @param	h
		 */
		public function setSize(w:Number, h:Number):void {
			_width = w;
			_height = h;
			
			this.graphics.clear();
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(0, 0, _width, _height);
			this.graphics.endFill();
			
			if (_inited) {
				//TODO:设置video的尺寸
			}
		}
		
		/**
		 * 播放
		 */
		public function play(url:String):void {
			_stream.play(url);
		}
		
		private function traceObj(obj:*):void {
			trace("=================================");
			trace(obj);
			for (var prop:String in obj) {
				trace(prop + ": " + obj[prop]);
			}
			trace("=================================");
		}
		
		/**
		 * 视频时长(毫秒)
		 */
		public function get duration():uint 
		{
			return _duration;
		}
		
		/**
		 * 视频当前播放的位置(时间)(毫秒)
		 */
		public function get time():uint 
		{
			return _time;
		}
		
	}

}

internal class StreamClient {
	public function StreamClient():void {
		
	}
	
	public var onCuePoint:Function;
	public var onImageData:Function;
	public var onMetaData:Function;
	public var onPlayStatus:Function;
	public var onSeekPoint:Function;
	public var onTextData:Function;
	public var onXMPData:Function;
	
}