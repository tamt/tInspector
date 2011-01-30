package cn.itamt.utils.inspector.firefox.evil 
{
	import cn.itamt.utils.ClassTool;
	import cn.itamt.utils.Debug;
	import cn.itamt.utils.inspector.events.InspectorFilterEvent;
	import cn.itamt.utils.inspector.ui.InspectorTextField;
	import cn.itamt.utils.inspector.ui.ToggleBooleanButton;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author itamt@qq.com
	 */
	public class DanDanTengPlayerItemRenderer extends Sprite {
		private var valueBtn : ToggleBooleanButton;
		protected var name_tf : TextField;
		protected var _width : Number;
		protected var _height : Number;
		protected var _player : *;

		public function DanDanTengPlayerItemRenderer(w : Number = 200, h : Number = 20) : void {
			this._width = w;
			this._height = h;

			this.mouseChildren = false;
			this.buttonMode = true;

			name_tf = InspectorTextField.create('玩家名称', 0xcccccc, 12, 0, 0, 'left', 'left');
			name_tf.height = _height - 2;
			addChild(name_tf);

			valueBtn = new ToggleBooleanButton(false);
			addChild(valueBtn);

			this.addEventListener(MouseEvent.ROLL_OVER, onMouseAct);
			this.addEventListener(MouseEvent.ROLL_OUT, onMouseAct);
			this.addEventListener(MouseEvent.CLICK, onMouseAct);

			this.relayout();
		}

		protected function drawBg(bgColor : uint = 0x282828) : void {
			this.graphics.clear();
			this.graphics.beginFill(bgColor);
			// this.graphics.drawRoundRect(0, 0, Math.max(name_tf.x + name_tf.textWidth + 16, _width), _height, 5, 5);
			this.graphics.drawRoundRect(0, 0, name_tf.x + name_tf.textWidth + 16, _height, 5, 5);
			this.graphics.endFill();
		}

		protected function onMouseAct(evt : MouseEvent) : void {
			if(evt.type == MouseEvent.ROLL_OUT) {
				this.drawBg(0x282828);
			} else if(evt.type == MouseEvent.ROLL_OVER) {
				this.drawBg(0x444444);
			} else if(evt.type == MouseEvent.CLICK) {
				valueBtn.value = !valueBtn.value;
				//this.dispatchEvent(new InspectorFilterEvent(valueBtn.value ? InspectorFilterEvent.APPLY : InspectorFilterEvent.KILL, this._player, true, true));
				this.dispatchEvent(new Event(Event.SELECT, true, true));
			}
		}

		protected function relayout() : void {
			valueBtn.x = 5;
			valueBtn.y = 3;

			name_tf.x = valueBtn.x + valueBtn.width + 3;
			// name_tf.textColor = (_filter == DisplayObject ? 0xff6666 : 0xcccccc);

			drawBg();
		}

		public function set data(value : *) : void {
			_player = value;
			
			for (var i:int = 0; i < (_player as DisplayObjectContainer).numChildren; i++) {
				var child:DisplayObject = (_player as DisplayObjectContainer).getChildAt(i);
				if (child is TextField) {
					this.label = (child as TextField).text;
					Debug.trace("玩家的名称是: " + this.label);
				}
			}
		}

		public function set label(val : String) : void {
			name_tf.text = (val == null ? '' : val);

			this.relayout();
		}

		public function get label() : String {
			return name_tf.text;
		}

		public function get data() : * {
			return _player;
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