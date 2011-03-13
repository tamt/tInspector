package {
	import cn.itamt.utils.Inspector;
	import cn.itamt.utils.inspector.plugins.controlbar.ControlBar;
	import cn.itamt.utils.inspector.ui.list.InspectorListView;

	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	

	/**
	 * @author itamt@qq.com
	 */
	public class tInspectorDemo extends Sprite {
		var list : InspectorListView;

		public function tInspectorDemo() {
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			// this.stage.align = StageAlign.RIGHT;

			var inspector : Inspector = Inspector.getInstance();
			inspector.init(this.stage);

			var toolbar : ControlBar = new ControlBar();
			inspector.pluginManager.registerPlugin(toolbar);
			addChild(toolbar);

			/*
			// var panel:InspectorViewPanel = new InspectorViewPanel();
			// addChild(panel);
			StructureElementView.outputerManager = new InspectorOutPuterManager();
			
			var list:InspectorListView = new InspectorListView(StructureElementView);
			var arr:Array = [];
			for (var i:int = 0; i < 20; i++) {
			arr.push(new DisplayItemData(new Sprite()));
			}
			list.data = arr;
			addChild(list);
			
			// panel.setContent(list);
			 * 
			 */
		}
	}
}
