package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;	

	import flash.display.Graphics;	

	import cn.itamt.utils.inspector.ui.InspectorViewOperationButton;

	import flash.display.Shape;	

	/**
	 * @author itamt@qq.com
	 */
	public class InspectorViewRefreshButton extends InspectorViewOperationButton {
		public function InspectorViewRefreshButton() {
			super();
			
			_tip = InspectorLanguageManager.getStr('Refresh');
		}

		override protected function buildDownState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.beginFill(0, 1);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();
			
			g.lineStyle(3, 0xffffff);
			g.moveTo(4.5, 10);
			g.curveTo(4.5, 4.5, 10, 4.5);
			g.curveTo(15.5, 4.5, 15.5, 10);
			g.curveTo(15.5, 15.5, 10, 15.5);
			return sp;
		}

		override protected function buildUpState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.beginFill(0, 0);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();
			
			g.lineStyle(3, 0xffffff);
			g.moveTo(4.5, 10);
			g.curveTo(4.5, 4.5, 10, 4.5);			g.curveTo(15.5, 4.5, 15.5, 10);			g.curveTo(15.5, 15.5, 10, 15.5);
			return sp;
		}

		override protected function buildOverState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.beginFill(0, 1);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();
			
			g.lineStyle(3, 0x99cc00);
			g.moveTo(4.5, 10);
			g.curveTo(4.5, 4.5, 10, 4.5);
			g.curveTo(15.5, 4.5, 15.5, 10);
			g.curveTo(15.5, 15.5, 10, 15.5);
			return sp;
		}

		override protected function buildHitState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.beginFill(0, 1);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();
			return sp;
		}

		override protected function buildUnenabledState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.beginFill(0, 0);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();
			
			g.lineStyle(3, 0);
			g.moveTo(4.5, 10);
			g.curveTo(4.5, 4.5, 10, 4.5);
			g.curveTo(15.5, 4.5, 15.5, 10);
			g.curveTo(15.5, 15.5, 10, 15.5);
			return sp;
		}
	}
}
