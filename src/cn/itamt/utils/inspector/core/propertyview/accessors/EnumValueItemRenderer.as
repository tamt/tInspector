package cn.itamt.utils.inspector.core.propertyview.accessors {
	import cn.itamt.utils.inspector.ui.ToggleBooleanButton;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author itamt@qq.com
	 */
	public class EnumValueItemRenderer extends Sprite {
		private var valueBtn : ToggleBooleanButton;

		public var editor : BasePropertyEditor;

		protected var _width : Number;
		protected var _height : Number;

		public function EnumValueItemRenderer(editor : BasePropertyEditor) : void {
			this.editor = editor;
			this.addChild(editor);
			
			this.mouseChildren = false;
			this.buttonMode = true;

			valueBtn = new ToggleBooleanButton();
			valueBtn.mouseEnabled = false;
			addChild(valueBtn);
			
			this._width = this.editor.width + valueBtn.width + 5;
			this._height = Math.max(this.editor.height, valueBtn.height + 3);
			
			this.addEventListener(MouseEvent.ROLL_OVER, onMouseAct);
			this.addEventListener(MouseEvent.ROLL_OUT, onMouseAct);
			this.addEventListener(MouseEvent.CLICK, onMouseAct);
			
			this.relayout();
		}

		protected function drawBg(bgColor : uint = 0x282828) : void {
			this.graphics.clear();
			this.graphics.beginFill(bgColor);
			this.graphics.drawRoundRect(0, 0, _width, _height, 5, 5);
			this.graphics.endFill();
		}

		protected function onMouseAct(evt : MouseEvent) : void {
			if(evt.type == MouseEvent.ROLL_OUT) {
				this.drawBg(0x282828);
			}else if(evt.type == MouseEvent.ROLL_OVER) {
				this.drawBg(0x444444);
			}else if(evt.type == MouseEvent.CLICK) {
				valueBtn.value = !valueBtn.value;
				this.dispatchEvent(new Event(valueBtn.value ? Event.SELECT : Event.CANCEL));
			}
		}

		protected function relayout() : void {
			valueBtn.x = 5;
			valueBtn.y = 3;
			
			editor.x = valueBtn.x + valueBtn.width;

			drawBg();
		}

		public function set selected(value : Boolean) : void {
			valueBtn.value = value;
		}

		public function get selected() : Boolean {
			return valueBtn.value;
		}
	}
}
