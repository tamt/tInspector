package {
	import flash.system.Security;
	import cn.itamt.utils.Inspector;
<<<<<<< HEAD
	import cn.itamt.utils.inspector.core.liveinspect.LiveInspectView;
	import cn.itamt.utils.inspector.plugins.controlbar.ControlBar;
=======
	import cn.itamt.utils.inspector.plugins.controlbar.ControlBar;
	import cn.itamt.utils.inspector.ui.list.InspectorListView;
>>>>>>> 52abfbf7a878a8ed94d0f4b0f826805080a8404b

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
<<<<<<< HEAD
	import flash.net.URLRequest;
	// import cn.itamt.utils.inspector.firefox.firebug.FlashFirebug;
=======
	
>>>>>>> 52abfbf7a878a8ed94d0f4b0f826805080a8404b

	/**
	 * @author itamt@qq.com
	 */
	public class tInspectorDemo extends Sprite {
<<<<<<< HEAD
		
=======
		var list : InspectorListView;

>>>>>>> 52abfbf7a878a8ed94d0f4b0f826805080a8404b
		public function tInspectorDemo() {
			Security.allowDomain("*");
			
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
<<<<<<< HEAD
			//this.stage.align = StageAlign.RIGHT;
			
			var loader:Loader = new Loader();
			loader.load(new URLRequest("http://www.1g1g.com/player/sendTwit.swf"));
			addChild(loader);
//			
			var sp:Sprite = new Sprite();
			sp.graphics.lineStyle(1, 0x00);
			sp.graphics.beginFill(0x770033);
			sp.graphics.drawRect(100, 100, 200, 200);
			sp.graphics.endFill();
			//addChild(sp);
			
			var bar:ControlBar = new ControlBar();
			addChild(bar);
			
			Inspector.getInstance().init(this);
			var liveInspect:LiveInspectView = new LiveInspectView();
//			var property:PropertiesView = new PropertiesView();
//			var struct:StructureView = new StructureView();
			
//			Inspector.getInstance().pluginManager.registerPlugin(bar);
			Inspector.getInstance().pluginManager.registerPlugin(liveInspect);
//			Inspector.getInstance().pluginManager.registerPlugin(property);
//			Inspector.getInstance().pluginManager.registerPlugin(struct);
			
			Inspector.getInstance().turnOn(liveInspect.getPluginId());
=======
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
>>>>>>> 52abfbf7a878a8ed94d0f4b0f826805080a8404b
		}
	}
}
