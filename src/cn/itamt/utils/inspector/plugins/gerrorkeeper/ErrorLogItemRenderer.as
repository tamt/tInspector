package cn.itamt.utils.inspector.plugins.gerrorkeeper {
	import cn.itamt.utils.TimeFormat;
	import cn.itamt.utils.inspector.ui.InspectorTextField;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author itamt@qq.com
	 */
	public class ErrorLogItemRenderer extends Sprite {
		protected var name_tf : TextField;

		protected var _width : Number;
		protected var _height : Number;

		protected var _errorLog : ErrorLog;

		public function ErrorLogItemRenderer(w : Number = 200, h : Number = 20) : void {
			this._width = w;
			this._height = h;
			
			this.mouseChildren = false;
			this.buttonMode = true;

			name_tf = InspectorTextField.create('property name', 0xcccccc, 12, 0, 0, 'left', 'left');
			name_tf.height = _height - 2;
			addChild(name_tf);
			
			this.addEventListener(MouseEvent.ROLL_OVER, onMouseAct);
			this.addEventListener(MouseEvent.ROLL_OUT, onMouseAct);
			this.addEventListener(MouseEvent.CLICK, onMouseAct);
			
			this.relayout();
		}

		protected function drawBg(bgColor : uint = 0x282828) : void {			
			this.graphics.clear();
			this.graphics.beginFill(bgColor);
			//			this.graphics.drawRoundRect(0, 0, Math.max(name_tf.x + name_tf.textWidth + 16, _width), _height, 5, 5);
			this.graphics.drawRoundRect(0, 0, name_tf.x + name_tf.textWidth + 16, _height, 5, 5);
			this.graphics.endFill();
		}

		protected function onMouseAct(evt : MouseEvent) : void {
			if(evt.type == MouseEvent.ROLL_OUT) {
				this.drawBg(0x282828);
			}else if(evt.type == MouseEvent.ROLL_OVER) {
				this.drawBg(0x444444);
			}else if(evt.type == MouseEvent.CLICK) {
			}
		}

		protected function relayout() : void {
			drawBg();
		}

		public function set data(value : Object) : void {
			_errorLog = value as ErrorLog;
			
			this.label = "[" + TimeFormat.toTimeFormat(_errorLog.date.getHours(), _errorLog.date.getMinutes(), _errorLog.date.getSeconds()) + "]" + _errorLog.message;
		}

		public function set label(val : String) : void {
			name_tf.text = (val == null ? '' : val);
			
			this.relayout();
		}

		public function get label() : String {
			return name_tf.text;
		}

		public function get data() : * {
			return _errorLog;
		}

		public function set color(value : uint) : void {
			name_tf.textColor = value;
		}

		public function get color() : uint {
			return name_tf.textColor;
		}
	}
}
