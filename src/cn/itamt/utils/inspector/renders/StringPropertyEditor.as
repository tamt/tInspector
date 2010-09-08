package cn.itamt.utils.inspector.renders {
	import cn.itamt.utils.inspector.events.PropertyEvent;

	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextFieldType;

	/**
	 * 字符串类型属性编辑器.
	 * @author itamt@qq.com
	 */
	public class StringPropertyEditor extends PropertyEditor {
		public function StringPropertyEditor() {
			super();
		}

		override protected function onFocusIn(evt : FocusEvent) : void {
			super.onFocusIn(evt);
			
			this.addEventListener(KeyboardEvent.KEY_UP, onPressEnter);
		}

		override protected function onFocusOut(evt : FocusEvent) : void {
			super.onFocusOut(evt);
			
			this.removeEventListener(KeyboardEvent.KEY_UP, onPressEnter);
		}

		protected function onPressEnter(evt : KeyboardEvent) : void {
			//ENTER键
			if(evt.keyCode == 13) {
				dispatchEvent(new PropertyEvent(PropertyEvent.UPDATE, true, true));
			}
		}

		override protected function onReadWrite() : void {
			super.onReadWrite();
			value_tf.type = TextFieldType.INPUT;
		}

		override public function setValue(value : *) : void {
			super.setValue(value);
			
			if(value == null) {
				value_tf.textColor = 0xff0000;
				value_tf.text = 'null';	
			} else {
				value_tf.text = value;
			}
		}
	}
}
