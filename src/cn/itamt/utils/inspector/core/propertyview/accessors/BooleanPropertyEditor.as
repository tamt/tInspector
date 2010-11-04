package cn.itamt.utils.inspector.core.propertyview.accessors {
	import cn.itamt.utils.Debug;
	import cn.itamt.utils.inspector.events.PropertyEvent;
	import cn.itamt.utils.inspector.ui.ToggleBooleanButton;

	import flash.events.Event;

	/**
	 * @author itamt@qq.com
	 */
	public class BooleanPropertyEditor extends PropertyEditor {
		private var valueBtn : ToggleBooleanButton;

		public function BooleanPropertyEditor() {
			super();
			
			this.valueBtn = new ToggleBooleanButton();
			this.valueBtn.addEventListener(Event.CHANGE, onValueBtnChange);
			addChild(this.valueBtn);
		}

		override public function relayOut() : void {
			super.relayOut();
			this.valueBtn.x = value_tf.x + value_tf.textWidth + 10;			this.valueBtn.y = 3;
			
			if(this.valueBtn.x > this._width - this.valueBtn.width) {
				this.valueBtn.x = this._width - this.valueBtn.width;
			}
		}

		private function onValueBtnChange(evt : Event) : void {
			this._value = this.valueBtn.value;
			this.value_tf.text = String(this.valueBtn.value);
			dispatchEvent(new PropertyEvent(PropertyEvent.UPDATE, true, true));
		}

		override protected function onWriteOnly() : void {
			super.onWriteOnly();
			
			value_tf.textColor = 0xff0000;
			value_tf.text = 'write only';
			value_tf.mouseEnabled = false;
		}

		override protected function onReadOnly() : void {
			super.onReadOnly();
			
			value_tf.textColor = 0x999999;
			value_tf.mouseEnabled = false;
			this.valueBtn.mouseEnabled = false;
			this.valueBtn.removeEventListener(Event.CHANGE, onValueBtnChange);
		}

		override public function setValue(value : *) : void {
			super.setValue(value);
			
			if(value == null) {
				value_tf.textColor = 0xff0000;
				value_tf.text = 'null';	
			} else {
				value_tf.text = value;
				this.valueBtn.value = value;
			}
		}
	}
}
