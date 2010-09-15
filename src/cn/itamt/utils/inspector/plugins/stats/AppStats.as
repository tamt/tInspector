package cn.itamt.utils.inspector.plugins.stats {
	import cn.itamt.utils.inspector.plugins.InspectorPluginId;
	import cn.itamt.utils.inspector.core.IInspector;
	import cn.itamt.utils.inspector.core.BaseInspectorPlugin;
	import cn.itamt.utils.inspector.ui.InspectorStageReference;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @author itamt[at]qq.com
	 */
	public class AppStats extends BaseInspectorPlugin {
		private var panel : AppStatsViewPanel;

		public function AppStats() {
			super();
		}

		override public function getPluginId() : String {
			return InspectorPluginId.APPSTATS_VIEW;
		}

		override public function contains(child : DisplayObject) : Boolean {
			if(panel) {
				return panel == child || panel.contains(child);
			} else {
				return false;
			}
		}

		override public function onRegister(inspector : IInspector) : void {
			super.onRegister(inspector);
			
			_icon = new AppStatsButton();
		}

		override public function onActive() : void {
			super.onActive();
			
			this.panel = new AppStatsViewPanel(""/*InspectorLanguageManager.getStr(InspectorViewID.APPSTATS_VIEW)*/);
			this.panel.addEventListener(Event.CLOSE, onClickClose, false, 0, true);
			this._inspector.stage.addChild(this.panel);
			
			var rect : Rectangle = InspectorStageReference.getStageBounds();
			this.panel.x = rect.right - this.panel.width - 10;
			this.panel.y = rect.top + 10;
		}

		override public function onUnActive() : void {
			super.onUnActive();
			
			//			this.panel.removeEventListener(Event.CLOSE, onClickClose);
			if(this.panel.stage)this.panel.parent.removeChild(this.panel);
			this.panel = null;
		}

		/**
		 * 玩家单击关闭按钮时
		 */
		private function onClickClose(evt : Event) : void {
			this._inspector.unactivePlugin(InspectorPluginId.APPSTATS_VIEW);
		}
	}
}
