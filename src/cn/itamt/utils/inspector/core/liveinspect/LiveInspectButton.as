package cn.itamt.utils.inspector.core.liveinspect {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.ui.InspectorViewFullButton;

	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;

	/**
	 * 鼠标查看
	 * @author itamt@qq.com
	 */
	public class LiveInspectButton extends InspectorViewFullButton {
		public function LiveInspectButton() {
			super();
		}


		override protected function buildOverState() : DisplayObject {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;

			// 背景
			g.beginFill(0, 1);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();

			// Lines:
			g.lineStyle(3.000000, 0x99cc00);
			g.moveTo(17.150000, 17.150000);
			g.lineTo(5.450000, 5.450000);
			g.curveTo(4.950000, 5.950000, 4.950000, 6.950000);
			g.lineTo(6.350000, 13.150000);
			g.moveTo(4.950000, 4.950000);
			g.lineTo(5.450000, 5.450000);
			g.curveTo(5.950000, 4.950000, 6.950000, 4.950000);
			g.lineTo(13.050000, 6.600000);


			return sp;
		}

		override protected function buildDownState() : DisplayObject {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;

			// 背景
			g.beginFill(0, 1);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();

			// Lines:
			g.lineStyle(3.000000, 0xffffff);
			g.moveTo(17.150000, 17.150000);
			g.lineTo(5.450000, 5.450000);
			g.curveTo(4.950000, 5.950000, 4.950000, 6.950000);
			g.lineTo(6.350000, 13.150000);
			g.moveTo(4.950000, 4.950000);
			g.lineTo(5.450000, 5.450000);
			g.curveTo(5.950000, 4.950000, 6.950000, 4.950000);
			g.lineTo(13.050000, 6.600000);


			return sp;
		}

		override protected function buildUpState() : DisplayObject {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;

			// 背景
			g.beginFill(0, 0);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();

			// Lines:
			g.lineStyle(3.000000, 0xffffff);
			g.moveTo(17.150000, 17.150000);
			g.lineTo(5.450000, 5.450000);
			g.curveTo(4.950000, 5.950000, 4.950000, 6.950000);
			g.lineTo(6.350000, 13.150000);
			g.moveTo(4.950000, 4.950000);
			g.lineTo(5.450000, 5.450000);
			g.curveTo(5.950000, 4.950000, 6.950000, 4.950000);
			g.lineTo(13.050000, 6.600000);

			return sp;
		}


		// ---------------------------
		// ---------------------------
		// ---------------------------

		override protected function buildOverState2() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;

			// 背景
			g.beginFill(0, 1);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();

			// Lines:
			g.lineStyle(3.000000, 0x99cc00);
			g.moveTo(17.150000, 17.150000);
			g.lineTo(5.450000, 5.450000);
			g.curveTo(4.950000, 5.950000, 4.950000, 6.950000);
			g.lineTo(6.350000, 13.150000);
			g.moveTo(4.950000, 4.950000);
			g.lineTo(5.450000, 5.450000);
			g.curveTo(5.950000, 4.950000, 6.950000, 4.950000);
			g.lineTo(13.050000, 6.600000);


			return sp;
		}

		override protected function buildDownState2() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;

			// 背景
			g.beginFill(0, 1);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();

			// Lines:
			g.lineStyle(3.000000, 0xffffff);
			g.moveTo(17.150000, 17.150000);
			g.lineTo(5.450000, 5.450000);
			g.curveTo(4.950000, 5.950000, 4.950000, 6.950000);
			g.lineTo(6.350000, 13.150000);
			g.moveTo(4.950000, 4.950000);
			g.lineTo(5.450000, 5.450000);
			g.curveTo(5.950000, 4.950000, 6.950000, 4.950000);
			g.lineTo(13.050000, 6.600000);

			return sp;
		}

		override protected function buildUpState2() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;

			// 背景
			g.beginFill(0, 0);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();

			// Lines:
			g.lineStyle(3.000000, 0xffffff);
			g.moveTo(17.150000, 17.150000);
			g.lineTo(5.450000, 5.450000);
			g.curveTo(4.950000, 5.950000, 4.950000, 6.950000);
			g.lineTo(6.350000, 13.150000);
			g.moveTo(4.950000, 4.950000);
			g.lineTo(5.450000, 5.450000);
			g.curveTo(5.950000, 4.950000, 6.950000, 4.950000);
			g.lineTo(13.050000, 6.600000);

			return sp;
		}

		// -----------------------------------
		// -----------------------------------
		// -----------------------------------
		// -----------------------------------

		override protected function updateStates() : void {
			super.updateStates();

			if(_normalMode) {
				_tip = InspectorLanguageManager.getStr('StartMouseInspect');
			} else {
				_tip = InspectorLanguageManager.getStr('StopMouseInspect');
			}
		}
	}
}
