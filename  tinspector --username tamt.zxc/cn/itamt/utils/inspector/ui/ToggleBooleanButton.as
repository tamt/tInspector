package cn.itamt.utils.inspector.ui {
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;	

	/**
	 * @author itamt@qq.com
	 */
	public class ToggleBooleanButton extends SimpleButton {
		private var _value : Boolean;

		public function set value(v : Boolean) : void {
			_value = v;
			this.updateMode();
		}

		public function get value() : Boolean {
			return _value;
		}

		public function ToggleBooleanButton(value : Boolean = true) {
			this.tabEnabled = false;
			
			this._value = value;
			this.updateMode();
			
			addEventListener(MouseEvent.CLICK, onClick);
		}

		private function updateMode() : void {
			var sp : Shape = new Shape();
			if(this._value) {
				sp.graphics.lineStyle(3, 0x282828);
				sp.graphics.beginFill(0x667E01);
				//				sp.graphics.drawRoundRect(0, 0, 15, 15, 6, 6);
				sp.graphics.drawCircle(7, 7, 7);
				sp.graphics.endFill();
			} else {
				sp.graphics.lineStyle(3, 0x282828);
				sp.graphics.beginFill(0x666666);
				//				sp.graphics.drawRoundRect(0, 0, 15, 15, 6, 6);
				sp.graphics.drawCircle(7, 7, 7);
				sp.graphics.endFill();
			}
			
			this.downState = this.overState = this.upState = this.hitTestState = sp;
		}

		private function onClick(evt : MouseEvent) : void {
			this._value = !this._value;
			this.updateMode();
			
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}
