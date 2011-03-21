package cn.itamt.zhenku 
{
	import cn.itamt.display.tSprite;
	import cn.itamt.zhenku.event.ZhenkuErrorEvent;
	import cn.itamt.zhenku.event.ZhenkuVideoEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.SoundTransform;
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
		private var _connClient:ConnectionClient;
		private var _stream:NetStream;
		private var _streamClient:StreamClient;
		private var _video:Video;
		private var _url:String = "";
		
		private var _previewImg:BitmapData;
		
		private var _width:Number;
		private var _height:Number;
		
		//视频持续的时间(毫秒)
		private var _duration:uint = 0;
		//视频当前的播放位置(毫秒)
		private var _time:uint = 0;
		//视频的大小
		private var _bytesLoaded:uint;
		private var _bytesTotal:uint;
		//视频当前的音量
		private var _volume:Number = 1;
		
		//第一次可播放
		private var _firstPlayable:Boolean;
		
		public function ZhenkuVideo(w:Number = 320, h:Number = 240) 
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
			//_connection.connect(null);
			//rtmp:/vod/mp4:sample2_1000kbps.f4v
			_connection.connect("rtmp://localhost/vod/");
			
			_connClient = new ConnectionClient();
			_connClient.onBWDone = this.onBWDone;
		}
		
		override protected function onRemoved():void {
			_connection.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_connection.close();
			_connection = null;
			
			removeEventListener(Event.ENTER_FRAME, onPlaying);
			removeEventListener(Event.ENTER_FRAME, onLoading);
			
            _stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
            _stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			_stream.close();
			_stream = null;
			
			_video = null;
		}
		
		private function onNetStatus(e:NetStatusEvent):void 
		{
			//trace(e.info.code);
			switch(e.info.code) {
				case "NetConnection.Connect.Success":
			trace("play stream");
					connectStream();
					break;
				case "NetStream.Buffer.Full":
					if (!_firstPlayable) {
						_stream.pause();
						_firstPlayable = true;
					}
					break;
				case "NetStream.Seek.Notify":
					if (_gotoTime) {
						_time = _gotoTime;
					}
					dispatchEvent(new ZhenkuVideoEvent(ZhenkuVideoEvent.SEEK, false, true));
					break;
				case "NetStream.Play.StreamNotFound":
					break;
				case "NetStream.Play.Start":
					_time = _stream.time;
					//dispatchEvent(new ZhenkuVideoEvent(ZhenkuVideoEvent.START, false, true));
					break;
				case "NetStream.Play.Stop":
					this.stop();
					//dispatchEvent(new ZhenkuVideoEvent(ZhenkuVideoEvent.STOP, false, true));
					//removeEventListener(Event.ENTER_FRAME, onPlaying);
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
			//
			_stream.play("rtmp://localhost/vod/mp4:sample2_1000kbps.f4v");
			//_stream
			_video.attachNetStream(_stream);
			
			//
			this.addEventListener(Event.ENTER_FRAME, onLoading);
		}
		
		private function onPlaying(e:Event):void 
		{
			_time = _stream.time * 1000;
			dispatchEvent(new ZhenkuVideoEvent(ZhenkuVideoEvent.PLAYING, false, true));
		}
		
		private function onLoading(e:Event):void 
		{
			_bytesLoaded = _stream.bytesLoaded;
			_bytesTotal = _stream.bytesTotal;
			if (_bytesLoaded >= _bytesTotal) {
				this.removeEventListener(Event.ENTER_FRAME, onLoading);
			}
			dispatchEvent(new ZhenkuVideoEvent(ZhenkuVideoEvent.LOADING, false, true));
		}
		
		private function onXMPData(obj:Object):void 
		{
			
		}
		
		private function onTextData(obj:Object):void 
		{
			
		}
		
		private function onSeekPoint(obj:Object):void 
		{
			trace("/////////////////////////////onseekpoint/////////////////");
			traceObj(obj);
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
			//traceObj(obj);
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
			//缩放到合适的尺寸(保持原始宽高比例)
			var scale:Number = Math.max(obj.height / _height, obj.width / _width);
			_video.height = obj.height/scale;
			_video.width = obj.width/scale;
			//居中
			_video.y = (_height - _video.height) / 2;
			_video.x = (_width - _video.width) / 2;
			
			_duration = obj.duration * 1000;
			dispatchEvent(new ZhenkuVideoEvent(ZhenkuVideoEvent.META_DATA, false, true));
		}
		
		private function onBWDone(obj:Object):void 
		{
			//
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
				//_video
			}
		}
		
		public function load(uri:String):void {
			_uri = uri;
			if (!_firstPlayable) {
				_stream.play(uri);
			}else {
				_firstPlayable = false;
				_stream.play(uri);
			}
		}
		
		/**
		 * 播放
		 */
		public function play():void {
			_stream.resume();
			dispatchEvent(new ZhenkuVideoEvent(ZhenkuVideoEvent.PLAY, false, true));
			addEventListener(Event.ENTER_FRAME, onPlaying);
		}
		
		/**
		 * 停止播放视频
		 */
		public function stop():void 
		{
			//_stream.close();
			dispatchEvent(new ZhenkuVideoEvent(ZhenkuVideoEvent.STOP, false, true));
			removeEventListener(Event.ENTER_FRAME, onPlaying);
			_firstPlayable = false;
			load(_uri);
		}
		
		/**
		 * 暂停播放
		 */
		public function pause():void 
		{
			_stream.pause();
			removeEventListener(Event.ENTER_FRAME, onPlaying);
			dispatchEvent(new ZhenkuVideoEvent(ZhenkuVideoEvent.PAUSE, false, true));
		}
		
		private var _gotoTime:uint;
		private var _uri:String;
		/**
		 * 跳到某一时间
		 * @param	pos
		 */
		public function goto(pos:uint):void 
		{
			_gotoTime = pos;
			_stream.seek(pos/1000);
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
		
		public function get bytesLoaded():uint 
		{
			return _bytesLoaded;
		}
		
		public function get bytesTotal():uint 
		{
			return _bytesTotal;
		}
		
		/**
		 * 视频的音量
		 */
		public function get volume():Number 
		{
			return _volume;
		}
		
		/**
		 * 设置视频的音量
		 */
		public function set volume(value:Number):void 
		{
			_volume = value;
			if (_stream) {
				var sndTfm:SoundTransform = new SoundTransform();
				sndTfm.volume = _volume;
				_stream.soundTransform = sndTfm;
			}
			dispatchEvent(new ZhenkuVideoEvent(ZhenkuVideoEvent.VOLUME, false, true));
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

internal class ConnectionClient {
	
	//public function 
	public var onBWDone:Function;
	
}