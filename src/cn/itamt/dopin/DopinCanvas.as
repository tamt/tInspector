package cn.itamt.dopin {
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;	

	/**
	 * 显示Dopin的Canvas.
	 * @author tamt
	 */
	public class DopinCanvas extends Sprite {
		internal var curMouseOn : BaseDopin;
		private var _dopin : BaseDopin;

		public function get dopin() : BaseDopin {
			return _dopin;
		}

		private var _bmp : Bitmap;

		public function DopinCanvas(dopin : BaseDopin, pixelSnapping : String = "auto", smoothing : Boolean = false) {
			_dopin = dopin;
			_bmp = new Bitmap(dopin.data.bmd, pixelSnapping, smoothing);
			addChild(_bmp);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			//设置渲染模式
			this.setRenderMode(this._renderMode);
		}

		private function onAdded(evt : Event) : void {
			if(evt.target == this) {
				this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
				this.addEventListener(MouseEvent.ROLL_OVER, onRollOver, false, 0, true);				this.addEventListener(MouseEvent.ROLL_OUT, onRollOut, false, 0, true);				this.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
				if(this._listening)this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				
				_dopin.checkAddedStage(evt);
			}
		}

		private function onRemoved(evt : Event) : void {
			if(evt.target == this) {
				this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				this.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				this.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);				this.removeEventListener(MouseEvent.CLICK, onClick);
				if(this._listening)this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				
				_dopin.checkRemovedStage(evt);
			}
		}

		private var _renderMode : int = 1;

		public function setRenderMode(value : int) : void {
			this.removeEventListener(Event.RENDER, onStageSmartRender);
			this.removeEventListener(Event.RENDER, onStageTotalRender);
			
			switch(value) {
				case DopinRenderMode.SMART:
					_renderMode = DopinRenderMode.SMART;
					this.addEventListener(Event.RENDER, onStageSmartRender);
					break;
				default:
					_renderMode = DopinRenderMode.TOTAL;
					this.addEventListener(Event.RENDER, onStageTotalRender);
					break;
			}
		}

		private var _invalidated : Boolean;

		internal function invalidate() : void {
			if(_invalidated)return;
			_invalidated = true;
			this.stage.invalidate();
		}

		private function onStageRender(evt : Event) : void {
			if(_invalidated) {
				_invalidated = false;
				if(_renderMode == DopinRenderMode.SMART) {
					this._dopin.smartRender();
				}else if(_renderMode == DopinRenderMode.TOTAL) {
					this._dopin.totalRender();
				} else {
					this._dopin.totalRender();
				}
			}
		}

		private function onStageSmartRender(evt : Event) : void {
			if(_invalidated) {
				_invalidated = false;
				this._dopin.smartRender();
			}
		}

		private function onStageTotalRender(evt : Event) : void {
			if(_invalidated) {
				_invalidated = false;
				this._dopin.totalRender();
			}
		}

		private function onMouseMove(evt : MouseEvent) : void {
			_dopin.checkMouseMove(evt);
		}

		private function onRollOver(evt : MouseEvent) : void {
			_dopin.checkRollOver(evt);
		}

		private function onRollOut(evt : MouseEvent) : void {
			_dopin.checkRollOut(evt);
		}

		private function onClick(evt : MouseEvent) : void {
			_dopin.checkClick(evt);
		}

		private var _listeners : Vector.<BaseDopin>;
		private var _listening : Boolean;

		internal function registerTickEventListener(dopin : BaseDopin) : void {
			if(_listeners == null)_listeners = new Vector.<BaseDopin>;
			if(_listeners.indexOf(dopin) < 0) {
				_listeners.push(dopin);
				if(!_listening) {
					_listening = true;
					if(this.stage)this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
			}
		}

		internal function removeTickEventListener(dopin : BaseDopin) : void {
			if(_listeners == null)return;
			var i : int = _listeners.indexOf(dopin);
			if(i > -1)_listeners.splice(i, 1);
			if(_listeners.length == 0) {
				_listening = false;
				this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}

		private function onEnterFrame(evt : Event) : void {
			for each(var dopin:BaseDopin in _listeners) {
				dopin.onTick(evt);
			}
		}

		/**
		 * 销毁.
		 */
		public function dispose() : void {
			//TODO:销毁
		}
	}
}
