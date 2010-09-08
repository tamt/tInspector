package cn.itamt.utils.inspector.mxp {
	import cn.itamt.utils.Inspector;
	import cn.itamt.utils.firefox.addon.tInspectorControlBar;
	import cn.itamt.utils.inspector.events.InspectEvent;
	import cn.itamt.utils.inspector.ui.AppStatsView;
	import cn.itamt.utils.inspector.ui.SwfInfoView;

	import flash.display.Sprite;

	/**
	 * @author itamt[at]qq.com
	 */
	public class tInspectorMXP extends Sprite {

		private var controlBar : tInspectorControlBar;
		private var tInspector : Inspector;
		private var statsView : AppStatsView;
		private var swfInfoView : SwfInfoView;

		public function tInspectorMXP() {
			controlBar = new tInspectorControlBar();
			controlBar.addEventListener(InspectEvent.RELOAD, onClickReload);
			addChild(controlBar);
			
			statsView = new AppStatsView();
			swfInfoView = new SwfInfoView();
		}
	}
}
