package cn.itamt.utils.inspector.renders {
	import cn.itamt.utils.inspector.events.PropertyEvent;
	import cn.itamt.utils.inspector.renders.NumberPropertyEditor;

	import flash.events.KeyboardEvent;	

	/**
	 * @author itamt@qq.com
	 */
	public class UnitPropertyEditor extends NumberPropertyEditor {
		private var value : uint;

		public function UnitPropertyEditor() {
			super();
			
			this.value_tf.restrict = "A-Fa-f0-9#";
		}

		override protected function onPressEnter(evt : KeyboardEvent) : void {
			//ENTER键
			if(evt.keyCode == 13) {
				var color : String = value_tf.text;
				// Works with or without the #
				if (color.indexOf("#") > -1) {
					color = color.replace(/^\s+|\s+$/g, "");
					color = color.replace(/#/g, "");
				} 
				
				// Convert to a color.
				value = parseInt(color, 16);
				
				dispatchEvent(new PropertyEvent(PropertyEvent.UPDATE, true, true));
			}
		}

		override public function setXML(target : *, xml : XML) : void {
			super.setXML(target, xml);
			
			if(_xml.@name == 'backgroundColor' || _xml.@name == 'borderColor') {
				value = uint(value_tf.text);
				value_tf.text = '#' + colorToString(value);
			}
		}

		override public function getValue() : * {
			return value;
		}

		protected function colorToString(color : uint) : String {
			var colorText : String = color.toString(16);
			while (colorText.length < 6) {
				colorText = "0" + colorText;
			}
			return colorText;
		}
	}
}
