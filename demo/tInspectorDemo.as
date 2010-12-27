package {
	import cn.itamt.utils.Inspector;
	import cn.itamt.utils.inspector.plugins.controlbar.ControlBar;
	import flash.geom.Point;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	/**
	 * @author itamt@qq.com
	 */
	public class tInspectorDemo extends Sprite {
		public function tInspectorDemo() {
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.RIGHT;
			
			var bar:ControlBar = new ControlBar();
			this.addChild(bar);
			
			//使用tInspector只需初始化即可
			Inspector.getInstance().init(this);
			//Inspector.getInstance().structureView.size = new Point(400, 400);
			//Inspector.getInstance().propertiesView.size = new Point(400, 400);
			Inspector.getInstance().pluginManager.registerPlugin(bar);
		}
	}
}
