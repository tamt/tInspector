package {
	import cn.itamt.utils.Inspector;
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
		public function tInspectorDemo() {
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			//this.stage.align = StageAlign.RIGHT;
			
			var bar:ControlBar = new ControlBar();
			this.addChild(bar);
			
			//使用tInspector只需初始化即可
			Inspector.getInstance().init(this);
			//Inspector.getInstance().structureView.size = new Point(400, 400);
			//Inspector.getInstance().propertiesView.size = new Point(400, 400);
			Inspector.getInstance().pluginManager.registerPlugin(bar);
			Inspector.getInstance().pluginManager.registerPlugin(new SwfInfoView());
			Inspector.getInstance().liveInspectView.use3DTransformer(new Transform3DController());
			
			//this.loaderInfo.addEventListener(Event.COMPLETE, onComplete);
		}
		
		private function onComplete(e:Event):void 
		{
			var ba:ByteArray = this.loaderInfo.bytes;
			var sd:SWFData2 = new SWFData2();
			sd.writeBytes(ba);
			sd.position = 0;
			var parser:SWFParser = new SWFParser();
			var header:SWFHeader = parser.parseHeader(sd);
			trace(header.toString());
		}
	}
}
