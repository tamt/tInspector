package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;	
	import cn.itamt.utils.inspector.ui.LiveTransformPointBtn;

	import flash.display.Graphics;
	import flash.display.Shape;	

	/**
	 * 拖动旋转变形的按钮
	 * @author itamt@qq.com
	 */
	public class LiveRotatePointBtn extends LiveTransformPointBtn {
		public function LiveRotatePointBtn(onMouseDown : Function = null, onMouseUp : Function = null, onDrag : Function = null) {
			super(onMouseDown, onMouseUp, onDrag);
			
			_tip = InspectorLanguageManager.getStr('LiveRotate');
		}

		override protected function buildDownState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.lineStyle(1, 0xffffff);
			g.beginFill(0xff0000, 1);
			g.drawCircle(0, 0, 5);
			g.endFill();
			return sp;
		}

		override protected function buildUpState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.lineStyle(1, 0xffffff);
			g.beginFill(0, 1);
			g.drawCircle(0, 0, 5);
			g.endFill();
			return sp;
		}

		override protected function buildOverState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.lineStyle(1, 0);
			g.beginFill(0x99cc00, 1);
			g.drawCircle(0, 0, 5);
			g.endFill();
			return sp;
		}

		override protected function buildHitState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.lineStyle(1, 0xffffff);
			g.beginFill(0, 1);
			g.drawCircle(0, 0, 5);
			g.endFill();
			return sp;
		}

		override protected function buildUnenabledState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.lineStyle(1, 0xffffff);
			g.beginFill(0, 1);
			g.drawCircle(0, 0, 5);
			g.endFill();
			return sp;
		}
	}
}
