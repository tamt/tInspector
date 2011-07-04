package
{
	import cn.itamt.utils.Inspector;
	import cn.itamt.utils.inspector.core.liveinspect.LiveInspectView;
	import cn.itamt.utils.inspector.core.propertyview.PropertiesView;
	import cn.itamt.utils.inspector.core.structureview.StructureView;
	import cn.itamt.utils.inspector.plugins.controlbar.ControlBar;

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.net.URLRequest;
	import flash.system.Security;

	// import cn.itamt.utils.inspector.firefox.firebug.FlashFirebug;
	/**
	 * @author itamt@qq.com
	 */
	public class tInspectorDemo extends Sprite
	{
		public function tInspectorDemo()
		{
			Security.allowDomain("*");

			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.RIGHT;

			var loader : Loader = new Loader();
			loader.load(new URLRequest("http://www.1g1g.com/player/sendTwit.swf"));
			addChild(loader);
			//
			var sp : Sprite = new Sprite();
			sp.graphics.lineStyle(1, 0x00);
			sp.graphics.beginFill(0x770033);
			sp.graphics.drawRect(100, 100, 200, 200);
			sp.graphics.endFill();
			addChild(sp);

			var bar : ControlBar = new ControlBar();
			addChild(bar);

			Inspector.getInstance().init(this);
			var liveInspect : LiveInspectView = new LiveInspectView();
			var property : PropertiesView = new PropertiesView();
			var struct : StructureView = new StructureView();
			// var deval:DEval = new DEval();

			Inspector.getInstance().pluginManager.registerPlugin(struct);
			Inspector.getInstance().pluginManager.registerPlugin(liveInspect);
			Inspector.getInstance().pluginManager.registerPlugin(property);
			Inspector.getInstance().pluginManager.registerPlugin(bar);
			// Inspector.getInstance().pluginManager.registerPlugin(deval);

			Inspector.getInstance().turnOn();

			Inspector.getInstance().pluginManager.registerPlugin(liveInspect);
			Inspector.getInstance().pluginManager.registerPlugin(property);

			Inspector.getInstance().turnOn(liveInspect.getPluginId());
			// this.stage.align = StageAlign.RIGHT;

			Inspector.getInstance().pluginManager.activePlugin(struct.getPluginId());
			// Inspector.getInstance().pluginManager.activePlugin(deval.getPluginId());
			
			// deval.setOutputReceiver(this.onDevalOutput);
		}

		private function onDevalOutput(...params) : void
		{
		}
	}
}
