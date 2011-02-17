package {
	import cn.itamt.utils.Inspector;
	import cn.itamt.utils.inspector.core.propertyview.DisplayObjectPropertyPanel;
	import cn.itamt.utils.inspector.core.structureview.BaseDisplayItemView;
	import cn.itamt.utils.inspector.core.structureview.DisplayItemData;
	import cn.itamt.utils.inspector.core.structureview.StructureElementView;
	import cn.itamt.utils.inspector.output.InspectorOutPuterManager;
	import cn.itamt.utils.inspector.ui.InspectorViewPanel;
	import cn.itamt.utils.inspector.ui.list.InspectorListView;
	//import cn.itamt.utils.inspector.firefox.firebug.FlashFirebug;
	import cn.itamt.utils.inspector.plugins.InspectorPluginId;
	import cn.itamt.utils.inspector.plugins.tfm3d.Transform3DController;
	import cn.itamt.utils.inspector.plugins.controlbar.ControlBar;
	import cn.itamt.utils.inspector.plugins.swfinfo.SWFData2;
	import cn.itamt.utils.inspector.plugins.swfinfo.SWFHeader;
	import cn.itamt.utils.inspector.plugins.swfinfo.SwfInfoView;
	import cn.itamt.utils.inspector.plugins.swfinfo.SWFParser;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.ByteArray;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	/**
	 * @author itamt@qq.com
	 */
	public class tInspectorDemo extends Sprite {
		
		var list:InspectorListView;
		
		public function tInspectorDemo() {
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			//this.stage.align = StageAlign.RIGHT;
			
			//Inspector.getInstance().init(this.stage);
			
			//var panel:InspectorViewPanel = new InspectorViewPanel();
			//addChild(panel);
			StructureElementView.outputerManager = new InspectorOutPuterManager();
			
			var list:InspectorListView = new InspectorListView(StructureElementView);
			var arr:Array = [];
			for (var i:int = 0; i < 20; i++) {
				arr.push(new DisplayItemData(new Sprite()));
			}
			list.data = arr;
			addChild(list);
			
			//panel.setContent(list);
		}
	}
}
