package cn.itamt.utils.inspector.filter {
	import flash.display.DisplayObject;

	import cn.itamt.utils.inspector.events.InspectorFilterEvent;
	import cn.itamt.utils.ClassTool;
	import cn.itamt.utils.inspector.ui.InspectorTextField;
	import cn.itamt.utils.inspector.ui.ToggleBooleanButton;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * @author itamt@qq.com
	 */
	public class InspectorFilterItemRenderer extends Sprite {
		private var valueBtn : ToggleBooleanButton;
		protected var name_tf : TextField;

		protected var _width : Number;
		protected var _height : Number;

		protected var _filter : Class;

		public function InspectorFilterItemRenderer(w : Number = 200, h : Number = 20) : void {
			this._width = w;
			this._height = h;
			
			//			this.mouseEnabled = false;

			name_tf = InspectorTextField.create('property name', 0xcccccc, 12, 0, 0, 'left', 'left');
			name_tf.height = _height - 2;
			name_tf.selectable = name_tf.mouseEnabled = name_tf.mouseWheelEnabled = false;
			addChild(name_tf);
			
			valueBtn = new ToggleBooleanButton();
			valueBtn.addEventListener(Event.CHANGE, onChange);
			addChild(valueBtn);
			
			this.relayout();
		}

		protected function drawBg() : void {			
			this.graphics.clear();
			this.graphics.beginFill(_filter == DisplayObject ? 0x006666 : 0x282828);
			//			this.graphics.drawRoundRect(0, 0, Math.max(name_tf.x + name_tf.textWidth + 16, _width), _height, 5, 5);			this.graphics.drawRoundRect(0, 0, name_tf.x + name_tf.textWidth + 16, _height, 5, 5);
			this.graphics.endFill();
		}

		protected function relayout() : void {
			valueBtn.x = 5;			valueBtn.y = 3;
			name_tf.x = valueBtn.x + valueBtn.width + 5;
			
			drawBg();
		}

		public function set data(value : Object) : void {
			_filter = value as Class;
			
			this.label = ClassTool.getClassName(value).replace("::", ".");
		}

		public function set label(val : String) : void {
			name_tf.text = (val == null ? '' : val);
			
			this.relayout();
		}

		public function get label() : String {
			return name_tf.text;
		}

		public function get data() : * {
			return _filter;
		}

		public function set enable(value : Boolean) : void {
			valueBtn.value = value;
		}

		public function get enable() : Boolean {
			return valueBtn.value;
		}

		private function onChange(evt : Event) : void {
			this.dispatchEvent(new InspectorFilterEvent(valueBtn.value ? InspectorFilterEvent.APPLY : InspectorFilterEvent.KILL, this._filter, true, true));
		}
	}
}
