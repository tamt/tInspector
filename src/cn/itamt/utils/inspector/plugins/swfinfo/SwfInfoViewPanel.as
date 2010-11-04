package cn.itamt.utils.inspector.plugins.swfinfo {
	import cn.itamt.utils.inspector.core.propertyview.PropertyPanel;

	/**
	 * @author itamt[at]qq.com
	 */
	public class SwfInfoViewPanel extends PropertyPanel {

		public function SwfInfoViewPanel(title : String = '���') {
			super(240, 170, null, false);
			this.title = title;
			
			this.removeChild(this.viewMethodBtn);
			this.removeChild(this.viewPropBtn);
			this.removeChild(this.singletonBtn);			this.removeChild(this.refreshBtn);
		}
	}
}
