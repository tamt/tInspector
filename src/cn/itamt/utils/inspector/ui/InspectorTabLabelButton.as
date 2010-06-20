package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.inspector.ui.InspectorLabelButton;	

	/**
	 * @author itamt@qq.com
	 */
	public class InspectorTabLabelButton extends InspectorLabelButton {
		public function InspectorTabLabelButton(label : String = '按钮', active : Boolean = false) {
			super(label, active);
		}

		override public function set active(value : Boolean) : void {
			if(value) {
				this.enabled = false;
				this.mouseEnabled = false;
			} else {
				this.enabled = true;
				this.mouseEnabled = true;
			}
			
			super.active = value;
		}
	}
}
