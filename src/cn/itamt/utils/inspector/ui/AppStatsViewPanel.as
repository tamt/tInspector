package cn.itamt.utils.inspector.ui {

	/**
	 * @author itamt[at]qq.com
	 */
	public class AppStatsViewPanel extends InspectorViewPanel {

		private var stats : Stats;

		public function AppStatsViewPanel(title : String = null) : void {
			stats = new Stats();
			stats.mouseChildren = stats.mouseEnabled = false;
			
			super(title, stats.width/* + this._padding.left + this._padding.right*/, stats.height/* + this._padding.top + this._padding.bottom*/);
			
			_padding = new Padding(30, 5, 5, 5);
			
			_resizer.visible = false;
			
			//最小尺寸
			_minW = 70;
			_minH = 100;
			
			this.setContent(stats);
			this.resize(70 + _padding.left + _padding.right, 100 + _padding.top + _padding.bottom);
		}
	}
}
