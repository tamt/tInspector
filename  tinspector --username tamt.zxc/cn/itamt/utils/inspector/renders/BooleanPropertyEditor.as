package cn.itamt.utils.inspector.renders {
	import cn.itamt.utils.inspector.events.PropertyEvent;
	import cn.itamt.utils.inspector.renders.PropertyEditor;
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
			this.value_tf.text = String(this.valueBtn.value);
			dispatchEvent(new PropertyEvent(PropertyEvent.UPDATE, true, true));
		}

		override public function setXML(target : *, xml : XML) : void {
			_xml = xml;
			
			value_tf.mouseEnabled = this.valueBtn.enabled = false;
			if(_xml.@access == 'writeonly') {
				value_tf.textColor = 0xff0000;
				value_tf.text = 'write only';
				return;
			}else if(_xml.@access == 'readonly') {
				value_tf.textColor = 0x999999;
				this.valueBtn.mouseEnabled = false;
			}else if(_xml.@access == 'readwrite') {
				this.valueBtn.enabled = true;
			}
			
			var value : *;
			value = target[_xml.@name];
			if(value == null) {
				value_tf.textColor = 0xff0000;
				value_tf.text = 'null';	
			} else {
				value_tf.text = value;
				this.valueBtn.value = value;
			}
		}

		override public function getValue() : * {
			return this.valueBtn.value;
		}
	}
}
