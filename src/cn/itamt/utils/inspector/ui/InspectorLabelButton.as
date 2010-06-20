package cn.itamt.utils.inspector.ui {
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;	

	/**
	 * @author itamt@qq.com
	 */
	public class InspectorLabelButton extends InspectorViewOperationButton {
		protected var _label : String = '按钮';
		protected var _active : Boolean;

		protected var state : Sprite;

		protected var _minW : Number = 52;
		protected var _minH : Number = 21;

		public function InspectorLabelButton(label : String = '按钮', active : Boolean = false) : void {
			_label = label;
			state = new Sprite();
			_active = active;
			
			update();
		}

		public function set active(value : Boolean) : void {
			_active = value;
			
			update();
		}

		public function get active() : Boolean {
			return _active;
		}

		private function update() : void {
			state.graphics.clear();
			while(state.numChildren) {
				state.removeChildAt(0);
			}
			
			
			var tf : TextField = InspectorTextField.create(_label, _active ? 0x232323 : 0x666666);
			//			tf.textColor = _active ? 0x232323 : 0x666666;
			tf.autoSize = 'left';
			//			tf.text = _label;

			var w : Number = tf.width < _minW ? _minW : tf.width;			var h : Number = tf.height < _minH ? _minH : tf.height;
			
			state.graphics.beginFill(_active ? 0xcccccc : 0x282828);
			state.graphics.drawRoundRect(0, 0, w, h, 4, 4);
			state.graphics.endFill();
			
			tf.x = state.width / 2 - tf.width / 2;			tf.y = state.height / 2 - tf.height / 2;
			state.addChild(tf);
			
			this.upState = this.downState = this.overState = this.hitTestState = this.state;
		}
	}
}
