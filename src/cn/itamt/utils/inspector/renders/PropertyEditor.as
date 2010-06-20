package cn.itamt.utils.inspector.renders {
	import cn.itamt.utils.inspector.renders.BasePropertyEditor;
	import cn.itamt.utils.inspector.ui.InspectorTextField;
	
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;	

	/**
	 * @author itamt@qq.com
	 */
	public class PropertyEditor extends BasePropertyEditor {

		protected var value_tf : TextField;

		public function PropertyEditor() {
			super();
			
			value_tf = InspectorTextField.create('', 0x0, 12);
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
			this.value_tf.textColor = 0;
			this.graphics.clear();
			this.graphics.lineStyle(2, 0x333333);
			this.graphics.drawRoundRect(0, 0, _width, _height, 5, 5);
		}

		override public function relayOut() : void {
			super.relayOut();
			value_tf.x = 2;
			value_tf.width = _width - 4;
			value_tf.height = _height - 2;
		}

		override public function setXML(target : *, xml : XML) : void {
			_xml = xml;
			
			var type : String = _xml.@type;
			
			if(_xml.@access == 'writeonly') {
				value_tf.textColor = 0xff0000;
				value_tf.text = 'write only';
				value_tf.mouseEnabled = false;
				return;
			}else if(_xml.@access == 'readonly') {
				value_tf.textColor = 0x999999;
				value_tf.mouseEnabled = false;
			}else if(_xml.@access == 'readwrite') {
				//				value_tf.type = TextFieldType.INPUT;
			}
			
			var value : *;
			value = target[_xml.@name];
			//Boolean、int、Null、Number、String、uint 和 void
			if(value == null || value == undefined) {
				value_tf.textColor = 0xff0000;
				value_tf.text = String(value);
				
				return;
			}
			
			if(type == 'Boolean' || type == 'Number' || type == 'String' || type == 'int' || type == 'uint' || type == 'void') {
				value_tf.text = value;
			} else {
				value_tf.text = value.toString();
			}
		}

		override public function getValue() : * {
			var classRef : Class = getDefinitionByName(this._xml.@type) as Class;
			return classRef(value_tf.text);
		}
	}
}
