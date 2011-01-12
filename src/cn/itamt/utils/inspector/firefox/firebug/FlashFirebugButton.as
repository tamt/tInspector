package cn.itamt.utils.inspector.firefox.firebug 
{
	import cn.itamt.utils.inspector.ui.InspectorIconButton;
	import cn.itamt.utils.inspector.ui.InspectorSymbolIcon;
	
	/**
	 * FlashFirebug的图标按钮
	 * @author tamt
	 */
	public class FlashFirebugButton extends InspectorIconButton 
	{
		
		public function FlashFirebugButton() 
		{
			super(InspectorSymbolIcon.FIREBUG);
			
			this.setSize(23, 23);
		}

		override public function set active(value : Boolean) : void {
			_active = value;
			if(active) {
				this.downState = buildDownState();
				this.upState = buildUpState();
				this.overState = buildOverState();
				this.hitTestState = buildHitState();
			} else {
				this.downState = buildUpState();
				this.upState = buildOverState();
				this.overState = buildDownState();
				this.hitTestState = buildHitState();
			}
		}
		
		override public function setSize(w:Number, h:Number):void {
			_w = w;
			_h = h;

			if(active) {
				this.downState = buildDownState();
				this.upState = buildUpState();
				this.overState = buildOverState();
				this.hitTestState = buildHitState();
			} else {
				this.downState = buildUpState();
				this.upState = buildOverState();
				this.overState = buildDownState();
				this.hitTestState = buildHitState();
			}
		}
		
	}

}