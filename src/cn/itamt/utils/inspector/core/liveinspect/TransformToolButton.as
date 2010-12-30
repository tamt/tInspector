package cn.itamt.utils.inspector.core.liveinspect 
{
	import cn.itamt.utils.inspector.ui.InspectorTextField;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import transform3d.toolbar.ToolButton;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class TransformToolButton extends ToolButton
	{
		private var _label:String = "label";
		
		public function TransformToolButton(label:String, active:Boolean) 
		{
			_label = label;
			
			this.downState = this._originDownState = buildState(0xffffff, 0x232323);
			this.overState = this._originOverState = buildState(0, 0x9cc00);
			this.upState = this._originUpState = buildState(0xffffff, 0x666666);
			this.hitTestState = buildState();
			
			super();
		}
		
		protected function buildState(textColor:uint = 0xffffff, bgColor:uint = 0x000000) :DisplayObject {
			var state : Sprite = new Sprite();

			var tf :TextField = InspectorTextField.create(_label, textColor, 12);
			tf.autoSize = 'left';

			state.graphics.beginFill(bgColor);
			state.graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
			state.graphics.endFill();

			tf.x = state.width / 2 - tf.width / 2;
			tf.y = state.height / 2 - tf.height / 2;
			state.addChild(tf);

			return state;
		}
		
	}

}