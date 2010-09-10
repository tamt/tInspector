package cn.itamt.utils.inspector.ui {

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
