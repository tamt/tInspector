package cn.itamt.utils.inspector.ui {
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;	

	/**
	 * @author itamt@qq.com
	 */
	public class InspectorViewOperationButton extends SimpleButton {
		public static const EVT_SHOW_TIP : String = 'show_tip';
		public static const EVT_REMOVE_TIP : String = 'remove_tip';

		private var _timer : Timer;
		protected var _tip : String = '提示';

		public function get tip() : String {
			return _tip;
		}

		public function set tip(value : String) : void {
			_tip = value;
		}

		public function InspectorViewOperationButton() : void {
			this.downState = buildDownState();
			this.upState = buildUpState();
			this.overState = buildOverState();
			this.hitTestState = buildHitState();
			
			_timer = new Timer(1000);
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			
			this.tabEnabled = false;
		}

		private function onRollOver(evt : MouseEvent) : void {
			//			_timer.start();
			_timer.addEventListener(TimerEvent.TIMER, onTimerShowTip);
			
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			dispatchEvent(new Event(EVT_SHOW_TIP, true));
		}

		private function onTimerShowTip(evt : TimerEvent) : void {
			_timer.removeEventListener(TimerEvent.TIMER, onTimerShowTip);			_timer.addEventListener(TimerEvent.TIMER, onTimerRemoveTip);
			
			//显示tip
			dispatchEvent(new Event(EVT_SHOW_TIP, true));
		}

		private function onTimerRemoveTip(evt : TimerEvent = null) : void {
			_timer.removeEventListener(TimerEvent.TIMER, onTimerRemoveTip);
			_timer.removeEventListener(TimerEvent.TIMER, onTimerShowTip);
			_timer.reset();
			_timer.stop();
			
			//删除tip
			dispatchEvent(new Event(EVT_REMOVE_TIP, true));
		}

		private function onRollOut(evt : MouseEvent) : void {
			removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
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

		protected function buildDownState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
			}
			return sp;
		}

		protected function buildUpState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
			}
			return sp;
		}

		protected function buildOverState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
			}
			return sp;
		}

		protected function buildHitState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
			}
			return sp;
		}

		protected function buildUnenabledState() : Shape {
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
