package {
	import flash.text.StyleSheet;
	import flash.display.StageScaleMode;
	import com.bit101.components.TextArea;
	import cn.itamt.utils.Inspector;
	import com.bit101.components.Calendar;
	import flash.display.Sprite;

	/**
	 * @author itamt@qq.com
	 */
	public class tInspectorDemo extends Sprite {
		public function tInspectorDemo() {
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var cal:Calendar = new Calendar();
			addChild(cal);
			
			cal.x = stage.stageWidth/2;
			cal.y = stage.stageHeight/2;
			
			var tf:TextArea = new TextArea();
			tf.html = true;
			var css:StyleSheet = new StyleSheet();
			css.setStyle(".code", {color:"#0000ff"});
			tf.textField.styleSheet = css;
			tf.text = 'Use <font color="#ff0000">tInspector</font> to inspect the minimal comps.<br>How to use tInspector:<br><p class="code">Inspector.getInstance().init(this);</p>and that\'s all.<br><h2>Keyboard Shortcut:</h2><ul><li>ctrl + P: for the Property Panel</li><li>ctrl + S: for the Structure Panel</li><li>ctrl + I: turn on/off tInspector</li><li>ctrl + T: stop/start live inspect</li></ul>you can change these config through Inspector.keysManager';
			tf.x = cal.x;
			tf.y = cal.y - tf.height- 10;
			addChild(tf);
			
			Inspector.getInstance().init(this, true, true, false, true);
			Inspector.getInstance().turnOn();
			Inspector.getInstance().liveInspect(cal);
			
			//http://tinspector.googlecode.com/svn/trunk/demo/tInspectorDemo.swf
			
			//http://zhongxiaochuan.121.idcice.net/blog/wp-content/uploads/2010/03/tInspectorDemo.swf
		}
	}
}
