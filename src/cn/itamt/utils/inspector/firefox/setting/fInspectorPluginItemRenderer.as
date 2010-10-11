package cn.itamt.utils.inspector.firefox.setting {
	import cn.itamt.utils.inspector.ui.InspectorIconButton;
	import cn.itamt.utils.inspector.ui.InspectorSymbolIcon;
	import cn.itamt.utils.inspector.ui.InspectorTextField;
	import cn.itamt.utils.inspector.ui.ToggleBooleanButton;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author itamt@qq.com
	 */
	public class fInspectorPluginItemRenderer extends Sprite {
		private var valueBtn : ToggleBooleanButton;
		protected var name_tf : TextField;
		protected var _width : Number;
		protected var _height : Number;
		protected var _plugin : String;
		protected var helpBtn : InspectorIconButton;

		public function fInspectorPluginItemRenderer(w : Number = 200, h : Number = 20) : void {
			this._width = w;
			this._height = h;

			// this.mouseChildren = false;
			this.mouseEnabled = false;

			name_tf = InspectorTextField.create('property name', 0xcccccc, 12, 0, 0, 'left', 'left');
			name_tf.height = _height - 2;
			addChild(name_tf);

			valueBtn = new ToggleBooleanButton();
			valueBtn.mouseEnabled = false;
			addChild(valueBtn);

			helpBtn = new InspectorIconButton(InspectorSymbolIcon.HELP);
			helpBtn.addEventListener(MouseEvent.CLICK, onClickHelp);
			addChild(helpBtn);


			this.name_tf.addEventListener(MouseEvent.ROLL_OVER, onMouseAct);
			this.name_tf.addEventListener(MouseEvent.ROLL_OUT, onMouseAct);
			this.name_tf.addEventListener(MouseEvent.CLICK, onMouseAct);

			this.relayout();
		}

		private function onClickHelp(event : MouseEvent) : void {
			event.stopImmediatePropagation();

			dispatchEvent(new Event("pluginHelp", true));
		}

		protected function drawBg(bgColor : uint = 0x282828) : void {
			this.graphics.clear();
			this.graphics.beginFill(bgColor);
			// this.graphics.drawRoundRect(0, 0, Math.max(name_tf.x + name_tf.textWidth + 16, _width), _height, 5, 5);
			this.graphics.drawRoundRect(0, 0, name_tf.x + name_tf.textWidth + 30, _height, 5, 5);
			this.graphics.endFill();
		}

		protected function onMouseAct(evt : MouseEvent) : void {
			if(evt.type == MouseEvent.ROLL_OUT) {
				this.drawBg(0x282828);
			} else if(evt.type == MouseEvent.ROLL_OVER) {
				this.drawBg(0x444444);
			} else if(evt.type == MouseEvent.CLICK) {
				valueBtn.value = !valueBtn.value;
				this.dispatchEvent(new Event(Event.SELECT, true));
			}
		}

		protected function relayout() : void {
			valueBtn.x = 5;
			valueBtn.y = 3;

			name_tf.x = valueBtn.x + valueBtn.width + 3;
			// name_tf.textColor = (_filter == DisplayObject ? 0xff6666 : 0xcccccc);
			helpBtn.x = name_tf.x + name_tf.width + 5;
			helpBtn.y = 1;

			drawBg();
		}

		public function set data(value : Object) : void {
			_plugin = value as String;

			this.label = _plugin;
		}

		public function set label(val : String) : void {
			name_tf.htmlText = "<a href='event:myEvent'><font color='#ffffff'>" + (val == null ? '' : val) + "</a></font>";

			this.relayout();
		}

		public function get label() : String {
			return name_tf.text;
		}

		public function get data() : * {
			return _plugin;
		}

		public function set enable(value : Boolean) : void {
			valueBtn.value = value;
		}

		public function get enable() : Boolean {
			return valueBtn.value;
		}

		public function set color(value : uint) : void {
			name_tf.textColor = value;
		}

		public function get color() : uint {
			return name_tf.textColor;
		}
	}
}
