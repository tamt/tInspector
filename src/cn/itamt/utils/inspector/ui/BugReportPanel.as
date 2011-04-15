package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.Inspector;

	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.StyleSheet;
	import flash.text.TextField;

	/**
	 * @author itamt@qq.com
	 */
	public class BugReportPanel extends InspectorViewPanel {

		public function BugReportPanel(w : Number = 315, h : Number = 150) {
			super('tInspector ' + Inspector.VERSION, w, h);
			bg.filters = null;
			filters = [new GlowFilter(0x0, 1, 16, 16, 1)];
			
			var tf : TextField = InspectorTextField.create('', 0xffffff, 12);
			var css : StyleSheet = new StyleSheet();
			css.setStyle("a:hover", {color:"#ff0000", textDecoration:"underline"});
			css.setStyle("a", {color:"#99cc00"});
			tf.styleSheet = css;
			tf.width = _width - _padding.left - _padding.right;
			tf.wordWrap = tf.multiline = true;
			tf.htmlText = '<br>authors: <font color="#99cc00">itamt@qq.com  pethan@qq.vip.com</font><br><br>project: <a href="https://github.com/tamt/tInspector">tInspector on github</a><br><br>more info: <a href="http://www.itamt.com">www.itamt.com</a>';
			tf.height = tf.textHeight + 6;
			this.setContent(tf);
			
			this._title.mouseEnabled = this._title.mouseWheelEnabled = false;
		}

		override protected function onClickClose(evt : Event) : void {
			if(this.stage) {
				this.parent.removeChild(this);
			}
		}
	}
}
