package cn.itamt.utils.inspector.plugins.swfinfo {
	import cn.itamt.utils.Inspector;
	import cn.itamt.utils.inspector.core.propertyview.PropertyPanel;
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.ui.InspectorLabelButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;

	/**
	 * @author itamt[at]qq.com
	 */
	public class SwfInfoViewPanel extends PropertyPanel {

		private var showMouseBtn:InspectorLabelButton;
		
		public function SwfInfoViewPanel(title : String = '���') {
			super(240, 170, null, false);
			this.title = title;
			
			this.removeChild(this.viewMethodBtn);
			this.removeChild(this.viewPropBtn);
			this.removeChild(this.singletonBtn);
			this.removeChild(this.refreshBtn);
			
			this.showMouseBtn = new InspectorLabelButton(InspectorLanguageManager.getStr("ShowMouse"));
			this.showMouseBtn.tip = InspectorLanguageManager.getStr("ShowMouse");
			this.showMouseBtn.addEventListener(MouseEvent.CLICK, onClickShowMouse);
			addChild(this.showMouseBtn);
		}
		
		/**
		 * 显示鼠标
		 * @param	e
		 */
		private function onClickShowMouse(e:MouseEvent):void 
		{
			dispatchEvent(new Event("ClickShowMouse", false, false));
		}
		
		override public function relayout() : void {
			super.relayout();
			this.showMouseBtn.x = _width - this._padding.right - this.showMouseBtn.width;
			this.showMouseBtn.y = this._height - this.showMouseBtn.height - (_padding.bottom - this.showMouseBtn.height) / 2;
		}
	}
}
