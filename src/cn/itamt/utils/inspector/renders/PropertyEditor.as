package cn.itamt.utils.inspector.renders {
	import cn.itamt.utils.inspector.ui.InspectorTextField;

	import flash.events.FocusEvent;
	import flash.text.TextField;

	/**
	 * @author itamt@qq.com
	 */
	public class PropertyEditor extends BasePropertyEditor {

		protected var value_tf : TextField;

		public function PropertyEditor() {
			super();
			
			value_tf = InspectorTextField.create('', 0xffffff, 12);
			value_tf.multiline = false;
			value_tf.mouseWheelEnabled = false;
			value_tf.height = _height - 2;
			addChild(value_tf);
				
			value_tf.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			value_tf.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		}

		protected function onFocusIn(evt : FocusEvent) : void {
			this.value_tf.textColor = 0xffffff;
			this.graphics.clear();
			this.graphics.lineStyle(4, 0x222222);
			this.graphics.beginFill(0x667E01);
			this.graphics.drawRoundRect(0, 0, _width, _height, 5, 5);
			this.graphics.endFill();
		}

		protected function onFocusOut(evt : FocusEvent) : void {
			this.value_tf.textColor = 0xffffff;
			this.graphics.clear();
			this.graphics.lineStyle(2, 0x333333);
			this.graphics.drawRoundRect(0, 0, _width, _height, 5, 5);
		}

		override public function relayOut() : void {
			super.relayOut();
			value_tf.x = 2;
			value_tf.width = _width - 4;
			value_tf.height = _height - 2;
			
			if(autoSize) {
				if(value_tf.textWidth + 4 > value_tf.width) {
					//					value_tf.width = value_tf.textWidth;
					_width = value_tf.textWidth + 10;
					relayOut();
				}
			}
		}

		override protected function onWriteOnly() : void {
			super.onWriteOnly();
			
			value_tf.textColor = 0xff0000;
			value_tf.text = 'write only';
			//			value_tf.mouseEnabled = false;
		}

		override protected function onReadOnly() : void {
			super.onReadOnly();
			
			value_tf.textColor = 0x999999;
			//			value_tf.mouseEnabled = false;

			value_tf.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			value_tf.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		}

		override public function setValue(value : *) : void {
			super.setValue(value);
			//Boolean、int、Null、Number、String、uint 和 void
			if(value == null || value == undefined) {
				value_tf.textColor = 0xff0000;
				value_tf.text = String(value);
				return;
			}
			value_tf.text = value.toString();
		}
	}
}
