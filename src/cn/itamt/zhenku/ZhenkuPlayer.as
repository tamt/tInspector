package cn.itamt.zhenku 
{
	import cn.itamt.display.tSprite;
	import cn.itamt.zhenku.event.ZhenkuVideoEvent;
	import cn.itamt.zhenku.util.Util;
	import flash.display.SimpleButton;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.SoundTransform;
	import flash.media.Video;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class ZhenkuPlayer extends tSprite 
	{
		public static const STATE_PLAYING:String = "playing";
		public static const STATE_STOPPED:String = "stopped";
		public static const STATE_PAUSED:String = "paused";
		
		public var progress_thumb:SimpleButton;
		public var progress_bar:MovieClip;
		public var prev_btn:SimpleButton;
		public var next_btn:SimpleButton;
		public var volume_controller:MovieClip;
		public var backward_btn:SimpleButton;
		public var play_status:MovieClip;
		public var time_tip:MovieClip;
		public var tmp_btn:SimpleButton;
		public var forward_btn:SimpleButton;
		public var play_btn:SimpleButton;
		public var zoom_btn:SimpleButton;
		public var pause_btn:SimpleButton;
		public var video_bg:MovieClip;
		public var player_bg:MovieClip;
		
		private var _draingProgress:Boolean;
		private var _video:ZhenkuVideo;
		//private var _soundTfm:SoundTransform;

		private var _status:String;
		
		public function ZhenkuPlayer() 
		{
			//界面初始设置
			time_tip.visible = false;
			progress_bar.loading_bar.width = 0;
			progress_thumb.x = progress_bar.x;
			pause_btn.visible = false;
		}
		
		override protected function onAdded():void {
			play_btn.addEventListener(MouseEvent.CLICK, onClickPlay);
			pause_btn.addEventListener(MouseEvent.CLICK, onClickPause);
			tmp_btn.addEventListener(MouseEvent.CLICK, onClickPlay);
			
			//音量控制
			volume_controller.thumb_btn.addEventListener(MouseEvent.MOUSE_DOWN, onStartDragVolume);
			volume_controller.drag_range.addEventListener(MouseEvent.CLICK, onClickVolumeRange);
			volume_controller.volume_status.addEventListener(MouseEvent.CLICK, onClickVolumeStatus);
			
			//进度条
			progress_bar.addEventListener(MouseEvent.ROLL_OVER, onOverProgressBar);
			progress_thumb.addEventListener(MouseEvent.MOUSE_DOWN, onStartDragProgress);
			progress_thumb.addEventListener(MouseEvent.ROLL_OVER, onOverProgressThumb);
			progress_thumb.addEventListener(MouseEvent.ROLL_OUT, onOutProgressThumb);
			progress_bar.addEventListener(MouseEvent.CLICK, onClickProgressBar);
			
			//视频
			_video = new ZhenkuVideo(video_bg.width, video_bg.height);
			addChildAt(_video, getChildIndex(video_bg) + 1);
			_video.addEventListener(ZhenkuVideoEvent.START, onVideoEvent);
			_video.addEventListener(ZhenkuVideoEvent.PLAY, onVideoEvent);
			_video.addEventListener(ZhenkuVideoEvent.PAUSE, onVideoEvent);
			_video.addEventListener(ZhenkuVideoEvent.PLAYING, onVideoEvent);
			_video.addEventListener(ZhenkuVideoEvent.META_DATA, onVideoEvent);
			_video.addEventListener(ZhenkuVideoEvent.PLAYING, onVideoEvent);
			_video.addEventListener(ZhenkuVideoEvent.LOADING, onVideoEvent);
			_video.addEventListener(ZhenkuVideoEvent.SEEK, onVideoEvent);
			_video.addEventListener(ZhenkuVideoEvent.VOLUME, onVideoEvent);
			_video.x = video_bg.x;
			_video.y = video_bg.y;
			
			//
			this.updateVolumeStatus();
		}
		
		override protected function onRemoved():void {
			play_btn.removeEventListener(MouseEvent.CLICK, onClickPlay);
			tmp_btn.removeEventListener(MouseEvent.CLICK, onClickPlay);
			pause_btn.removeEventListener(MouseEvent.CLICK, onClickPause);
			
			volume_controller.thumb_btn.removeEventListener(MouseEvent.MOUSE_DOWN, onStartDragVolume);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onStopDragVolume);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDragingVolumeThumb);
			volume_controller.drag_range.removeEventListener(MouseEvent.CLICK, onClickVolumeRange);
			volume_controller.volume_status.removeEventListener(MouseEvent.CLICK, onClickVolumeStatus);
			
			//进度条
			progress_bar.removeEventListener(MouseEvent.ROLL_OVER, onOverProgressBar);
			progress_bar.removeEventListener(MouseEvent.ROLL_OUT, onOutProgressBar);
			progress_bar.removeEventListener(MouseEvent.CLICK, onClickProgressBar);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMovingOnProgressBar);
			
			progress_thumb.removeEventListener(MouseEvent.MOUSE_DOWN, onStartDragProgress);
			progress_thumb.addEventListener(MouseEvent.ROLL_OVER, onOverProgressThumb);
			progress_thumb.addEventListener(MouseEvent.ROLL_OUT, onOutProgressThumb);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStopDragProgress);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDragingProgress);
		
			_video.removeEventListener(ZhenkuVideoEvent.START, onVideoEvent);
			_video.removeEventListener(ZhenkuVideoEvent.PLAY, onVideoEvent);
			_video.removeEventListener(ZhenkuVideoEvent.META_DATA, onVideoEvent);
			_video.removeEventListener(ZhenkuVideoEvent.PLAYING, onVideoEvent);
			_video.removeEventListener(ZhenkuVideoEvent.LOADING, onVideoEvent);
			_video.removeEventListener(ZhenkuVideoEvent.SEEK, onVideoEvent);
			_video.removeEventListener(ZhenkuVideoEvent.VOLUME, onVideoEvent);
			
			this.removeEventListener(Event.ENTER_FRAME, onOveringProgressThumb);
		}
		
		private function onOverProgressThumb(e:MouseEvent):void 
		{
			time_tip.visible = true;
			updateTimeTip(progress_thumb.x);
			this.addEventListener(Event.ENTER_FRAME, onOveringProgressThumb);
		}
		
		private function onOutProgressThumb(e:MouseEvent):void 
		{
			if(!_draingProgress)time_tip.visible = false;
			this.removeEventListener(Event.ENTER_FRAME, onOveringProgressThumb);
		}
		
		private function onOveringProgressThumb(e:Event):void 
		{
			updateTimeTip(progress_thumb.x);
		}
		
		private function onStartDragProgress(e:MouseEvent):void 
		{
			progress_bar.dragOffset = new Point(progress_thumb.mouseX, progress_thumb.mouseY);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStopDragProgress);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onDragingProgress);
		}
		
		/**
		 * 鼠标拖动播放进度条上的按钮时
		 * @param	e
		 */
		private function onDragingProgress(e:MouseEvent):void 
		{
			if (!_draingProgress)_draingProgress = true;
			
			var posPercent:Number;
			if (this.mouseX - progress_bar.dragOffset.x < progress_bar.x) {
				posPercent = 0;
				progress_thumb.x = progress_bar.x;
			}else if (this.mouseX - progress_bar.dragOffset.x > progress_bar.x + progress_bar.width) {
				posPercent = 1;
				progress_thumb.x = progress_bar.x + progress_bar.width;
			}else {
				progress_thumb.x = this.mouseX - progress_bar.dragOffset.x;
				posPercent = (progress_thumb.x - progress_bar.x) / progress_bar.width;
			}
			
			updateTimeTip(progress_thumb.x);
		}
		
		private function onStopDragProgress(e:MouseEvent):void 
		{
			if (_draingProgress) time_tip.visible = false;
			_draingProgress = false;
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStopDragProgress);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDragingProgress);
		}
		
		private function onOverProgressBar(e:MouseEvent):void 
		{
			time_tip.visible = true;
			updateTimeTip(this.mouseX);
			progress_bar.addEventListener(MouseEvent.ROLL_OUT, onOutProgressBar);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMovingOnProgressBar);
		}
		
		private function onOutProgressBar(e:MouseEvent):void 
		{
			time_tip.visible = false;
			progress_bar.removeEventListener(MouseEvent.ROLL_OUT, onOutProgressBar);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMovingOnProgressBar);
		}
		
		/**
		 * 当鼠标在进度条上移动时
		 * @param	e
		 */
		private function onMovingOnProgressBar(e:MouseEvent):void 
		{
			updateTimeTip(this.mouseX);
		}
		
		/**
		 * 点击播放进度条
		 * @param	e
		 */
		private function onClickProgressBar(e:MouseEvent):void 
		{
			var posPercent:Number = progress_bar.mouseX / progress_bar.width;
			_video.goto(int(posPercent * _video.duration));
		}
		
		private function onClickPlay(e:MouseEvent):void 
		{
			play();
		}
		
		private function onClickPause(e:MouseEvent):void 
		{
			pause();
		}
		
		private function onStartDragVolume(e:MouseEvent):void 
		{
			this.volume_controller.dragOffset = new Point(this.volume_controller.thumb_btn.mouseX, this.volume_controller.thumb_btn.mouseY);
			
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onStopDragVolume);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onDragingVolumeThumb);
		}
		
		private function onStopDragVolume(e:MouseEvent):void 
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onStopDragVolume);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDragingVolumeThumb);
		}
		
		private function onDragingVolumeThumb(e:MouseEvent):void 
		{
			if(volume_controller.mouseX - volume_controller.dragOffset.x < volume_controller.drag_range.x){
				this._video.volume = 0;
			}else if (volume_controller.mouseX - volume_controller.dragOffset.x > volume_controller.drag_range.x + volume_controller.drag_range.width) {
				this._video.volume = 1;
			}else {
				this._video.volume = (volume_controller.mouseX - volume_controller.dragOffset.x - volume_controller.drag_range.x) / volume_controller.drag_range.width;
			}
		}
		
		private function onClickVolumeRange(e:MouseEvent):void 
		{
			this._video.volume = (volume_controller.mouseX - volume_controller.drag_range.x) / volume_controller.drag_range.width;
		}
		
		private function onClickVolumeStatus(e:MouseEvent):void 
		{
			if (_video.volume == 0) {
				_video.volume = 1;
			}else {
				_video.volume = 0;
			}
		}
	
		private function onVideoEvent(evt:ZhenkuVideoEvent):void {
			switch(evt.type) {
				case ZhenkuVideoEvent.META_DATA:
					play_status.time_tf.text = Util.time2Str(_video.time) + "/" + Util.time2Str(_video.duration);
					break;
				case ZhenkuVideoEvent.START:
				case ZhenkuVideoEvent.PLAY:
					_status = STATE_PLAYING;
					this.updatePlayStatus();
					break;
				case ZhenkuVideoEvent.STOP:
					_status = STATE_STOPPED;
					this.updatePlayStatus();
					break;
				case ZhenkuVideoEvent.PAUSE:
					_status = STATE_PAUSED;
					this.updatePlayStatus();
					break;
				case ZhenkuVideoEvent.PLAYING:
					_status = STATE_PLAYING;
					this.updatePlayProgress();
					break;
				case ZhenkuVideoEvent.SEEK:
					this.updatePlayProgress();
					break;
				case ZhenkuVideoEvent.LOADING:
					this.updateLoadStatus();
					break;
				case ZhenkuVideoEvent.VOLUME:
					this.updateVolumeStatus();
					break;
			}
		}
		
		private function updateTimeTip(progressThumbX:Number):void {
			var posPercent:Number = posPercent = (time_tip.x - progress_bar.x) / progress_bar.width; 
			time_tip.x = progressThumbX;
			time_tip.time_tf.text = Util.time2Str(int(_video.duration * posPercent));
		}
		
		private function updatePlayProgress():void {
			play_status.time_tf.text = Util.time2Str(_video.time) + "/" + Util.time2Str(_video.duration);
			progress_thumb.x = progress_bar.x + progress_bar.width * (_video.time / _video.duration);
		}
		
		private function updateLoadStatus():void {
			progress_bar.loading_bar.width = (progress_bar.width - 2) * _video.bytesLoaded / _video.bytesTotal;
		}
		
		private function updatePlayStatus():void 
		{
			if (_status == STATE_PLAYING) {
				this.play_btn.visible = false;
				this.tmp_btn.visible = false;
				this.pause_btn.visible = true;
			}else if (_status == STATE_STOPPED || _status == STATE_PAUSED) {
				this.play_btn.visible = true;
				this.tmp_btn.visible = true;
				this.pause_btn.visible = false;
			}
		}
		
		private function updateVolumeStatus():void {
			var posPercent:Number = _video.volume;
			volume_controller.thumb_btn.x = volume_controller.drag_range.x + posPercent * volume_controller.drag_range.width;
			volume_controller.volume_status.gotoAndStop(int(posPercent * 4) + 1);
		}
		
		/////////////////////////////////////////////////
		/////////////////////////////////////////////////
		/////////////////////////////////////////////////
		
		/**
		 * 加载视频
		 * @param	video
		 */
		public function load(uri:String):void {
			_video.load(uri);
		}
		
		/**
		 * 播放视频
		 */
		public function play():void {
			_video.play();
		}
		
		/**i
		 * 暂停播放
		 */
		public function pause():void {
			_video.pause();
		}
		
		/**
		 * 跳到某一时间(毫秒)
		 */
		public function goto(pos:uint):void {
			_video.goto(pos);
		}
		
	}

}