package cn.itamt.dopin {
	import cn.itamt.dopin.utils.SnapData;

	import ui.dragdrop.SnapShoter;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;	

	/**
	 * 影片剪辑Dopin类.
	 * @author tamt
	 */
	public class MovieClipDopin extends BaseDopin {
		private var curSnapData : SnapData;
		private var snapDatas : Array;
		private var srcMc : MovieClip;
		private var tframes : int;

		public function MovieClipDopin(mc : MovieClip) {
			srcMc = mc;
			srcMc.stop();
			tframes = srcMc.totalFrames;
			snapDatas = [];
			
			snapDatas[0] = SnapShoter.snap2(srcMc);
			curSnapData = snapDatas[0];
			
			super(new DopinData(curSnapData.bmd));
//			this._regX = -curSnapData.offsetX;
//			this._regY = -curSnapData.offsetY;
		}

		override internal function onAddedStage(evt : Event = null) : void {
			super.onAddedStage(evt);
			if(tframes > 1)play();
		}

		override internal function onRemove(evt : Event = null) : void {
			super.onRemove(evt);
			stop();
		}

		private var _playing : Boolean = false;

		public function play() : void {
			if(this.root) {
				if(!_playing) {
					_playing = true;
					this.root.registerTickEventListener(this);
				}
			}
		}

		public function stop() : void {
			_playing = false;
			this.root.removeTickEventListener(this);
		}

		public function gotoAndPlay(frame : int) : void {
			if(frame > tframes)frame = tframes;
			curFrame = frame;
			this.showCurFrame();
		}

		private var curFrame : int = 0;

		override internal function onTick(evt : Event) : void {
			curFrame %= tframes;
			curFrame++;
			this.showCurFrame();
		}

		private function showCurFrame() : void {
			var snapdata : SnapData = snapDatas[curFrame - 1];
			if(!snapdata) {
				srcMc.gotoAndStop(curFrame);
				snapDatas[curFrame - 1] = SnapShoter.snap2(srcMc);
			}
			curSnapData = snapDatas[curFrame - 1];
			this.data.setOriginalBmd(curSnapData.bmd);
			this.data.setBmd(curSnapData.bmd.clone());
			
			if(this._filters)this.filters = this._filters;
			
			//			this._regX = -curSnapData.offsetX;
			//			this._regY = -curSnapData.offsetY;
			this.invalidate(false);
		}

		override public function dispose() : void {
			super.dispose();
		}
	}	
}
