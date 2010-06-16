package cn.itamt.utils.inspector.filter {
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
			addChild(valueBtn);
			valueBtn.addEventListener(Event.CHANGE, onChange);
			
			this.relayout();
		}

		protected function drawBg() : void {			
			this.graphics.clear();
			this.graphics.beginFill(0x282828);
			this.graphics.drawRoundRect(0, 0, Math.max(name_tf.x + name_tf.textWidth + 16, _width), _height, 5, 5);
			this.graphics.endFill();
		}

		protected function relayout() : void {
			valueBtn.x = 5;			valueBtn.y = 3;
			name_tf.x = valueBtn.x + valueBtn.width + 5;
			
			drawBg();
		}

		public function set data(value : Object) : void {
			_filter = value as Class;
			
			name_tf.text = ClassTool.getClassName(value);
			
			this.relayout();
		}

		public function get data() : * {
			return _filter;
		}

		private function onChange(evt : Event) : void {
			this.dispatchEvent(new InspectorFilterEvent(InspectorFilterEvent.CHANGE, this._filter));
		}
	}
}
