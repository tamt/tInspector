package cn.itamt.zhenku 
{
	import cn.itamt.display.tSprite;
	import cn.itamt.zhenku.event.ZhenkuVideoEvent;
	import cn.itamt.zhenku.util.Util;
	import flash.display.SimpleButton;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.Video;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class ZhenkuPlayer extends tSprite 
	{
		
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


		public function ZhenkuPlayer() 
		{
			
		}
		
		override protected function onAdded():void {
			play_btn.addEventListener(MouseEvent.CLICK, onClickPlay);
			pause_btn.addEventListener(MouseEvent.CLICK, onClickPause);
			tmp_btn.addEventListener(MouseEvent.CLICK, onClickPlay);
			
			//音量控制
			volume_controller.thumb_btn.addEventListener(MouseEvent.MOUSE_DOWN, onStartDragVolume);
			volume_controller.drag_range.addEventListener(MouseEvent.CLICK, onClickVolumeRange);
			
			//进度条
			progress_bar.addEventListener(MouseEvent.ROLL_OVER, onOverProgressBar);
			progress_thumb.addEventListener(MouseEvent.MOUSE_DOWN, onStartDragProgress);
			progress_thumb.addEventListener(MouseEvent.ROLL_OVER, onOverProgressThumb);
			progress_thumb.addEventListener(MouseEvent.ROLL_OUT, onOutProgressThumb);
			progress_bar.addEventListener(MouseEvent.CLICK, onClickProgressBar);
			
			//
			_video = new ZhenkuVideo();
			addChild(_video);
			_video.addEventListener(ZhenkuVideoEvent.START, onVideoEvent);
			_video.addEventListener(ZhenkuVideoEvent.META_DATA, onVideoEvent);
			_video.addEventListener(ZhenkuVideoEvent.PLAYING, onVideoEvent);
			_video.x = video_bg.x;
			_video.y = video_bg.y; 
		}
		
		override protected function onRemoved():void {
			play_btn.removeEventListener(MouseEvent.CLICK, onClickPlay);
			tmp_btn.removeEventListener(MouseEvent.CLICK, onClickPlay);
			pause_btn.removeEventListener(MouseEvent.CLICK, onClickPause);
			
			volume_controller.thumb_btn.removeEventListener(MouseEvent.MOUSE_DOWN, onStartDragVolume);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onStopDragVolume);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDragingVolumeThumb);
			volume_controller.drag_range.removeEventListener(MouseEvent.CLICK, onClickVolumeRange);
			
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
			_video.removeEventListener(ZhenkuVideoEvent.META_DATA, onVideoEvent);
			_video.removeEventListener(ZhenkuVideoEvent.PLAYING, onVideoEvent);
		}
		
		private function onOverProgressThumb(e:MouseEvent):void 
		{
			time_tip.visible = true;
			updateTimeTip(progress_thumb.x);
		}
		
		private function onOutProgressThumb(e:MouseEvent):void 
		{
			if(!_draingProgress)time_tip.visible = false;
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
		
		private function updateTimeTip(xPos:Number):void {
			var posPercent:Number = posPercent = (time_tip.x - progress_bar.x) / progress_bar.width; 
			time_tip.x = xPos;
			time_tip.time_tf.text = Util.time2Str(int(_video.duration * posPercent));
		}
		
		/**
		 * 点击播放进度条
		 * @param	e
		 */
		private function onClickProgressBar(e:MouseEvent):void 
		{
			
		}
		
		private function onClickPlay(e:MouseEvent):void 
		{
			play_btn.visible = false;
			pause_btn.visible = true;
			tmp_btn.visible = false;
		}
		
		private function onClickPause(e:MouseEvent):void 
		{
			play_btn.visible = true;
			pause_btn.visible = false;
			tmp_btn.visible = true;
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
			var posPercent:Number;
			if(volume_controller.mouseX - volume_controller.dragOffset.x < volume_controller.drag_range.x){
				volume_controller.thumb_btn.x = volume_controller.drag_range.x;
				posPercent = 0;
			}else if (volume_controller.mouseX - volume_controller.dragOffset.x > volume_controller.drag_range.x + volume_controller.drag_range.width) {
				volume_controller.thumb_btn.x = volume_controller.drag_range.x + volume_controller.drag_range.width;
				posPercent = 1;
			}else {
				volume_controller.thumb_btn.x = volume_controller.mouseX;
				posPercent = (volume_controller.thumb_btn.x - volume_controller.drag_range.x) / volume_controller.drag_range.width;
			}
			
			volume_controller.volume_status.gotoAndStop(int(posPercent*4) + 1);
		}
		
		private function onClickVolumeRange(e:MouseEvent):void 
		{
			volume_controller.thumb_btn.x = volume_controller.mouseX;
			var posPercent:Number;
			posPercent = (volume_controller.thumb_btn.x - volume_controller.drag_range.x) / volume_controller.drag_range.width;
			volume_controller.volume_status.gotoAndStop(int(posPercent * 4) + 1);
		}
	
		private function onVideoEvent(evt:ZhenkuVideoEvent):void {
			switch(evt.type) {
				case ZhenkuVideoEvent.META_DATA:
					play_status.time_tf.text = Util.time2Str(_video.time) + "/" + Util.time2Str(_video.duration);
					break;
				case ZhenkuVideoEvent.START:
					break;
				case ZhenkuVideoEvent.PLAYING:
					play_status.time_tf.text = Util.time2Str(_video.time) + "/" + Util.time2Str(_video.duration);
					break;
			}
		}
		
		/////////////////////////////////////////////////
		/////////////////////////////////////////////////
		/////////////////////////////////////////////////
		
		/**
		 * 加载视频
		 * @param	video
		 */
		public function load(video:String):void {
			
		}
		
		/**
		 * 播放视频
		 */
		public function play():void {
			
		}
		
	}

}