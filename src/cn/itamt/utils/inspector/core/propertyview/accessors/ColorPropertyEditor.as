package cn.itamt.utils.inspector.core.propertyview.accessors {
	import flash.events.FocusEvent;

	/**
	 * @author itamt@qq.com
	 */
	public class ColorPropertyEditor extends NumberPropertyEditor {

		public function ColorPropertyEditor() {
			super();
			
			this.value_tf.restrict = "A-Fa-f0-9#";
		}

		override public function relayOut() : void {
			this.graphics.clear();
			this.graphics.lineStyle(2, 0x333333);
			this.graphics.drawRoundRect(0, 0, _width, _height, 5, 5);
			
			value_tf.x = 22;
			value_tf.width = _width - 30;
			value_tf.height = _height - 2;
			
			if(autoSize) {
				if(value_tf.textWidth + 30 > value_tf.width) {
					//					value_tf.width = value_tf.textWidth;
					_width = value_tf.textWidth + 30;
				}
			}
			
			this.graphics.beginFill(this.getValue());
			this.graphics.drawRoundRect(2, 2, 18, 18, 5, 5);
			this.graphics.endFill();
		}

		override protected function onFocusIn(evt : FocusEvent) : void {
			super.onFocusIn(evt);
			
			this.graphics.beginFill(this.getValue());
			this.graphics.drawRoundRect(2, 2, 18, 18, 5, 5);
			this.graphics.endFill();			
		}

		override protected function onFocusOut(evt : FocusEvent) : void {
			super.onFocusOut(evt);
			
			this.graphics.beginFill(this.getValue());
			this.graphics.drawRoundRect(2, 2, 18, 18, 5, 5);
			this.graphics.endFill();
		}

		override public function getValue() : * {
			var color : String = value_tf.text;
			// Works with or without the #
			if (color.indexOf("#") > -1) {
				color = color.replace(/^\s+|\s+$/g, "");
				color = color.replace(/#/g, "");
			} 
				
			// Convert to a color.
			return parseInt(color, 16);
		}

		override public function setValue(value : *) : void {
			super.setValue(value);
			
			value_tf.text = '#' + colorToString(value);
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
