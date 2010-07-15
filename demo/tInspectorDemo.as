package {
	import cn.itamt.utils.inspector.consts.InspectorViewID;
	import cn.itamt.utils.Inspector;

	import flash.display.Sprite;
	import flash.display.StageScaleMode;

	/**
	 * @author itamt@qq.com
	 */
	public class tInspectorDemo extends Sprite {
		public function tInspectorDemo() {
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//使用tInspector只需初始化即可
			Inspector.getInstance().init(this);
			
			//开启“鼠标查看”，“设置查看类型”面板
			Inspector.getInstance().turnOn(InspectorViewID.LIVE_VIEW);
		}
	}
}
