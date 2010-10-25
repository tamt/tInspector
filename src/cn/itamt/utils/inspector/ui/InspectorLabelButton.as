package cn.itamt.utils.inspector.ui {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * @author itamt@qq.com
	 */
	public class InspectorLabelButton extends InspectorButton {
		protected var _label : String = '按钮';

		protected var _minW : Number = 52;
		protected var _minH : Number = 21;

		public function InspectorLabelButton(label : String = '按钮', active : Boolean = false) : void {
			_label = label;
			_active = active;

			super();

			this.update();
		}

		override public function set active(value : Boolean) : void {
			_active = value;

			update();
		}

		override public function get active() : Boolean {
			return _active;
		}

		public function set label(val : String):void {
			_label = val;
			this.update();
		}

		public function get label():String {
			return _label;
		}

		private function update() : void {
			this.downState = buildDownState();
			this.upState = buildUpState();
			this.overState = buildOverState();
			this.hitTestState = buildDownState();
		}

		override protected function buildDownState() : DisplayObject {
			var state : Sprite = new Sprite();

			var tf : TextField = InspectorTextField.create(_label, _active ? 0x232323 : 0x666666);
			tf.autoSize = 'left';

			var w : Number = tf.width < _minW ? _minW : tf.width;
			var h : Number = tf.height < _minH ? _minH : tf.height;

			state.graphics.beginFill(_active ? 0xcccccc : 0x282828);
			state.graphics.drawRoundRect(0, 0, w, h, 4, 4);
			state.graphics.endFill();

			tf.x = state.width / 2 - tf.width / 2;
			tf.y = state.height / 2 - tf.height / 2;
			state.addChild(tf);

			return state;
		}

		override protected function buildUpState() : DisplayObject {
			var state : Sprite = new Sprite();

			var tf : TextField = InspectorTextField.create(_label, 0x666666);
			tf.autoSize = 'left';

			var w : Number = tf.width < _minW ? _minW : tf.width;
			var h : Number = tf.height < _minH ? _minH : tf.height;

			state.graphics.beginFill(_active ? 0x999999 : 0x282828);
			state.graphics.drawRoundRect(0, 0, w, h, 4, 4);
			state.graphics.endFill();

			tf.x = state.width / 2 - tf.width / 2;
			tf.y = state.height / 2 - tf.height / 2;
			state.addChild(tf);

			return state;
		}

		override protected function buildOverState() : DisplayObject {
			var state : Sprite = new Sprite();

			var tf : TextField = InspectorTextField.create(_label, 0x666666);
			tf.autoSize = 'left';

			var w : Number = tf.width < _minW ? _minW : tf.width;
			var h : Number = tf.height < _minH ? _minH : tf.height;

			state.graphics.beginFill(_active ? 0xcccccc : 0x000000);
			state.graphics.drawRoundRect(0, 0, w, h, 4, 4);
			state.graphics.endFill();

			tf.x = state.width / 2 - tf.width / 2;
			tf.y = state.height / 2 - tf.height / 2;
			state.addChild(tf);

			return state;
		}
	}
}
