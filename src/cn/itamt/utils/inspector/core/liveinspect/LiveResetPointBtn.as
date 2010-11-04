package cn.itamt.utils.inspector.core.liveinspect {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;

	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;

	/**
	 * 取消变形的按钮
	 * @author itamt@qq.com
	 */
	public class LiveResetPointBtn extends LiveTransformPointBtn {
		public function LiveResetPointBtn(onMouseDown : Function = null, onMouseUp : Function = null, onDrag : Function = null) {
			super(onMouseDown, onMouseUp, onDrag);

			_tip = InspectorLanguageManager.getStr('ResetTransform');
		}

		override protected function buildDownState() : DisplayObject {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.lineStyle(1, 0xffffff);
			g.beginFill(0xff0000, 1);
			g.moveTo(0, -5);
			g.lineTo(-5, 5);
			g.lineTo(5, 5);
			g.lineTo(0, -5);
			g.endFill();
			return sp;
		}

		override protected function buildUpState() : DisplayObject {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.lineStyle(1, 0xffffff);
			g.beginFill(0, 1);
			g.moveTo(0, -5);
			g.lineTo(-5, 5);
			g.lineTo(5, 5);
			g.lineTo(0, -5);
			g.endFill();
			return sp;
		}

		override protected function buildOverState() : DisplayObject {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.lineStyle(1, 0);
			g.beginFill(0x99cc00, 1);
			g.moveTo(0, -5);
			g.lineTo(-5, 5);
			g.lineTo(5, 5);
			g.lineTo(0, -5);
			g.endFill();
			return sp;
		}

		override protected function buildHitState() : DisplayObject {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.lineStyle(1, 0xffffff);
			g.beginFill(0, 1);
			g.moveTo(0, -5);
			g.lineTo(-5, 5);
			g.lineTo(5, 5);
			g.lineTo(0, -5);
			g.endFill();
			return sp;
		}

		override protected function buildUnenabledState() : DisplayObject {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.lineStyle(1, 0xffffff);
			g.beginFill(0, 1);
			g.moveTo(0, -5);
			g.lineTo(-5, 5);
			g.lineTo(5, 5);
			g.lineTo(0, -5);
			g.endFill();
			return sp;
		}
	}
}
