package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.inspector.events.TipEvent;

	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author itamt@qq.com
	 */
	public class InspectorButton extends SimpleButton {
		protected var _active : Boolean = false;

		private var _timer : Timer;
		protected var _tip : String = 'tip';

		public function get tip() : String {
			return _tip;
		}

		public function set tip(value : String) : void {
			_tip = value;
		}

		public function InspectorButton() : void {
			this.downState = buildDownState();
			this.upState = buildUpState();
			this.overState = buildOverState();
			this.hitTestState = buildHitState();

			_timer = new Timer(1000);
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.MOUSE_DOWN, removeTip);
			addEventListener(MouseEvent.CLICK, removeTip);

			this.tabEnabled = false;
		}

		public function set active(value : Boolean) : void {
			_active = value;
			if(!active) {
				this.downState = buildDownState();
				this.upState = buildUpState();
				this.overState = buildOverState();
				this.hitTestState = buildHitState();
			} else {
				this.downState = buildUpState();
				this.upState = buildOverState();
				this.overState = buildDownState();
				this.hitTestState = buildHitState();
			}
		}

		public function get active() : Boolean {
			return _active;
		}

		private function onRollOver(evt : MouseEvent) : void {
			// _timer.start();
			_timer.addEventListener(TimerEvent.TIMER, onTimerShowTip);

			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			dispatchEvent(new TipEvent(TipEvent.EVT_SHOW_TIP, this.tip));
		}

		private function onTimerShowTip(evt : TimerEvent) : void {
			_timer.removeEventListener(TimerEvent.TIMER, onTimerShowTip);
			_timer.addEventListener(TimerEvent.TIMER, onTimerRemoveTip);

			// 显示tip
			dispatchEvent(new TipEvent(TipEvent.EVT_SHOW_TIP, this.tip));
		}

		private function onTimerRemoveTip(evt : TimerEvent = null) : void {
			_timer.removeEventListener(TimerEvent.TIMER, onTimerRemoveTip);
			_timer.removeEventListener(TimerEvent.TIMER, onTimerShowTip);
			_timer.reset();
			_timer.stop();

			// 删除tip
			dispatchEvent(new TipEvent(TipEvent.EVT_REMOVE_TIP, this.tip));
		}

		private function onRollOut(evt : MouseEvent) : void {
			removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
			onTimerRemoveTip();
		}

		private function removeTip(evt : MouseEvent) : void {
			onTimerRemoveTip();
		}

		override public function set enabled(val : Boolean) : void {
			if(!val) {
				this.downState = this.upState = this.overState = this.hitTestState = buildUnenabledState();
			} else {
				this.downState = buildDownState();
				this.upState = buildUpState();
				this.overState = buildOverState();
				this.hitTestState = buildHitState();
			}

			super.enabled = val;
		}

		protected function buildDownState() : DisplayObject {
			var sp : Shape = new Shape();
			with(sp) {
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
			}
			return sp;
		}

		protected function buildUpState() : DisplayObject {
			var sp : Shape = new Shape();
			with(sp) {
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
			}
			return sp;
		}

		protected function buildOverState() : DisplayObject {
			var sp : Shape = new Shape();
			with(sp) {
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
			}
			return sp;
		}

		protected function buildHitState() : DisplayObject {
			var sp : Shape = new Shape();
			with(sp) {
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
			}
			return sp;
		}

		protected function buildUnenabledState() : DisplayObject {
			var sp : Shape = new Shape();
			with(sp) {
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
			}
			return sp;
		}
	}
}
