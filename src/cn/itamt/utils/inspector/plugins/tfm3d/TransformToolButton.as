package cn.itamt.utils.inspector.plugins.tfm3d 
{
	import cn.itamt.utils.inspector.ui.InspectorButton;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import transform3d.toolbar.IToolButton;
	
	/**
	 * tool3d的选择按钮
	 * @author tamt
	 */
	public class TransformToolButton extends InspectorButton implements IToolButton
	{
		private var _icon:BitmapData;
		
		protected var _originUpState:DisplayObject;
		protected var _originDownState:DisplayObject;
		protected var _originOverState:DisplayObject;
		
		public function TransformToolButton(icon:BitmapData, active:Boolean) 
		{
			_icon = icon;
			
			this._originDownState = buildState(0xffffff, 0x232323);
			this._originOverState = buildState(0, 0x9cc00);
			this._originUpState = buildState(0xffffff, 0x666666);
			this.hitTestState = buildState();
			
			super();
		}
		
		override public function set active(val:Boolean):void {
			if (_originDownState == null)_originDownState = this.downState;
			if (_originUpState == null)_originUpState = this.upState;
			if (_originOverState == null)_originOverState = this.overState;
			
			//if (_active == val) return;
			_active = val;
			
			if (_active) {
				this.upState = this._originDownState;
				this.overState = this._originOverState;
				this.downState = this._originUpState;
			}else {
				this.upState = this._originUpState;
				this.overState = this._originOverState;
				this.downState = this._originDownState;
			}
		}
		
		protected function buildState(textColor:uint = 0xffffff, bgColor:uint = 0x000000) :DisplayObject {
			var state : Sprite = new Sprite();

			var tf :Bitmap = new Bitmap(_icon);

			state.graphics.beginFill(bgColor);
			state.graphics.drawRect(0, 0, 20, 20);
			state.graphics.endFill();

			tf.x = state.width / 2 - tf.width / 2;
			tf.y = state.height / 2 - tf.height / 2;
			state.addChild(tf);

			return state;
		}

		override protected function buildOverState() : DisplayObject {
			return this._originOverState;
		}

		override protected function buildDownState() : DisplayObject {
			return this._originDownState;
		}

		override protected function buildUpState() : DisplayObject {
			return this._originUpState;
		}
		
	}

}