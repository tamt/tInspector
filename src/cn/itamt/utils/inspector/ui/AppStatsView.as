package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.inspector.consts.InspectorViewID;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @author itamt[at]qq.com
	 */
	public class AppStatsView extends BaseInspectorView {
		private var panel : AppStatsViewPanel;

		public function AppStatsView() {
			super();
		}

		override public function contains(child : DisplayObject) : Boolean {
			if(panel) {
				return panel == child || panel.contains(child);
			} else {
				return false;
			}
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
			this._inspector.unactiveView(InspectorViewID.APPSTATS_VIEW);
		}
	}
}
