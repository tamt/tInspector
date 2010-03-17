package cn.itamt.utils.inspector.renders {
	import cn.itamt.utils.inspector.events.PropertyEvent;	
	import cn.itamt.utils.inspector.renders.BasePropertyEditor;

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

		override public function setXML(target : *, xml : XML) : void {
			_xml = xml;
			
			if(_xml.@access == 'writeonly') {
				value_tf.textColor = 0xff0000;
				value_tf.text = 'write only';
				value_tf.mouseEnabled = false;
				return;
			}else if(_xml.@access == 'readonly') {
				value_tf.textColor = 0x999999;
				value_tf.mouseEnabled = false;
			}else if(_xml.@access == 'readwrite') {
				value_tf.type = TextFieldType.INPUT;
			}
			
			var value : *;
			value = target[_xml.@name];
			if(value == null) {
				value_tf.textColor = 0xff0000;
				value_tf.text = 'null';	
			} else {
				value_tf.text = value;
			}
		}

		override public function getValue() : * {
			return value_tf.text;
		}
	}
}
