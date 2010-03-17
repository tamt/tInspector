package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.Inspector;	
	import cn.itamt.utils.inspector.ui.InspectorViewPanel;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.StyleSheet;
	import flash.text.TextField;	

	/**
	 * @author itamt@qq.com
	 */
	public class BugReportPanel extends InspectorViewPanel {

		//		private var eff : WobbleEffect;

		public function BugReportPanel(w : Number = 315, h : Number = 150) {
			super('tInspector ' + Inspector.VERSION, w, h);
			
			bg.filters = null;			filters = [new GlowFilter(0x0, 1, 16, 16, 1)];
			
			var tf : TextField = InspectorTextField.create('', 0xffffff, 12);
			var css : StyleSheet = new StyleSheet();
			css.setStyle("a:hover", {color:"#ff0000", textDecoration:"underline"});			css.setStyle("a", {color:"#99cc00"});
			tf.styleSheet = css;
			tf.width = _width - _padding.left - _padding.right;
			tf.wordWrap = tf.multiline = true;
			tf.htmlText = /*'<br>作者: tamt, pethan<br>*/ '<br>authors: <font color="#99cc00">itamt@qq.com  pethan@qq.vip.com</font><br><br>project: <a href="http://code.google.com/p/tcodes/wiki/tInspector">tInspector on Google Code</a>';
			tf.height = tf.textHeight + 6;
			this.setContent(tf);
			
			this._title.mouseEnabled = this._title.mouseWheelEnabled = false;
		}

		//			this.mouseEnabled = false;

		//			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		//		}
		//
		//		private function onAdded(evt : Event) : void {
		//			eff = new WobbleEffect(evt.target as DisplayObject);
		//			eff.apply();
		//			eff.visible = false;
		//			eff.addEventListener(Event.COMPLETE, onEffComplete);
		//		}
		//
		//		
		override protected function onClickClose(evt : Event) : void {
			if(this.stage) {
				this.parent.removeChild(this);
//				eff.visible = false;
//				eff.removeEventListener(Event.COMPLETE, onEffComplete);
//				eff.dispose();
			}
		}
//
//		
//		override protected function onMouseup(evt : MouseEvent) : void {
//			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseup);		
//			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMoveResizer);
//			this.stopDrag();
//			this.cacheAsBitmap = true;
//			this._virtualResizer.stopDrag();
//			
//			eff.onUp(evt);
//		}
//
//		override protected function onMouseDown(evt : MouseEvent) : void {
//			this.cacheAsBitmap = false;
//			this.startDrag(false);
//			DisplayObjectTool.swapToTop(this);
//			this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseup);
//			
//			this.visible = false;
//			eff.visible = true;
//			
//			eff.onDown(evt);
//		}
//
//		private function onEffComplete(evt : Event) : void {
//			this.visible = true;
//			eff.visible = false;
//		}
	}
}
