package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.ui.InspectorViewOperationButton;

	import flash.display.Shape;	

	/**
	 * 查看對象顯示結構的按鈕.
	 * @author itamt@qq.com
	 */
	public class InspectorViewStructureButton extends InspectorViewOperationButton {
		public function InspectorViewStructureButton() {
			super();
			
			_tip = InspectorLanguageManager.getStr('ViewStructure');
		}

		override protected function buildOverState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				//背景
				graphics.lineStyle();
				graphics.beginFill(0, 1);
				graphics.moveTo(23.000000, 5.750000);
				graphics.lineTo(23.000000, 17.250000);
				graphics.curveTo(23.000000, 19.600000, 21.350000, 21.350000);
				graphics.curveTo(19.600000, 23.000000, 17.250000, 23.000000);
				graphics.lineTo(5.750000, 23.000000);
				graphics.curveTo(3.400000, 23.000000, 1.750000, 21.350000);
				graphics.curveTo(0.000000, 19.600000, 0.000000, 17.250000);
				graphics.lineTo(0.000000, 5.750000);
				graphics.curveTo(0.000000, 3.400000, 1.750000, 1.750000);
				graphics.curveTo(3.400000, 0.000000, 5.750000, 0.000000);
				graphics.lineTo(17.250000, 0.000000);
				graphics.curveTo(19.600000, 0.000000, 21.350000, 1.750000);
				graphics.curveTo(23.000000, 3.400000, 23.000000, 5.750000);
				graphics.endFill();
				// Lines:

				graphics.lineStyle(3.000000, 0x99cc00);
				graphics.moveTo(5.400000, 11.600000);
				graphics.lineTo(10.250000, 11.600000);
				graphics.lineTo(10.250000, 6.400000);
				graphics.lineTo(17.600000, 6.400000);
				graphics.moveTo(17.600000, 11.600000);
				graphics.lineTo(10.250000, 11.600000);
				graphics.lineTo(10.250000, 16.650000);
				graphics.lineTo(17.050000, 16.650000);
			}
			return sp;
		}

		override protected function buildDownState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				//背景
				graphics.lineStyle();
				graphics.beginFill(0, 1);
				graphics.moveTo(23.000000, 5.750000);
				graphics.lineTo(23.000000, 17.250000);
				graphics.curveTo(23.000000, 19.600000, 21.350000, 21.350000);
				graphics.curveTo(19.600000, 23.000000, 17.250000, 23.000000);
				graphics.lineTo(5.750000, 23.000000);
				graphics.curveTo(3.400000, 23.000000, 1.750000, 21.350000);
				graphics.curveTo(0.000000, 19.600000, 0.000000, 17.250000);
				graphics.lineTo(0.000000, 5.750000);
				graphics.curveTo(0.000000, 3.400000, 1.750000, 1.750000);
				graphics.curveTo(3.400000, 0.000000, 5.750000, 0.000000);
				graphics.lineTo(17.250000, 0.000000);
				graphics.curveTo(19.600000, 0.000000, 21.350000, 1.750000);
				graphics.curveTo(23.000000, 3.400000, 23.000000, 5.750000);
				graphics.endFill();
				// Lines:

				graphics.lineStyle(3.000000, 0xffffff);
				graphics.moveTo(5.400000, 11.600000);
				graphics.lineTo(10.250000, 11.600000);
				graphics.lineTo(10.250000, 6.400000);
				graphics.lineTo(17.600000, 6.400000);
				graphics.moveTo(17.600000, 11.600000);
				graphics.lineTo(10.250000, 11.600000);
				graphics.lineTo(10.250000, 16.650000);
				graphics.lineTo(17.050000, 16.650000);
			}
			return sp;
		}

		override protected function buildUpState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				//背景
				graphics.lineStyle();
				graphics.beginFill(0, 0);
				graphics.moveTo(23.000000, 5.750000);
				graphics.lineTo(23.000000, 17.250000);
				graphics.curveTo(23.000000, 19.600000, 21.350000, 21.350000);
				graphics.curveTo(19.600000, 23.000000, 17.250000, 23.000000);
				graphics.lineTo(5.750000, 23.000000);
				graphics.curveTo(3.400000, 23.000000, 1.750000, 21.350000);
				graphics.curveTo(0.000000, 19.600000, 0.000000, 17.250000);
				graphics.lineTo(0.000000, 5.750000);
				graphics.curveTo(0.000000, 3.400000, 1.750000, 1.750000);
				graphics.curveTo(3.400000, 0.000000, 5.750000, 0.000000);
				graphics.lineTo(17.250000, 0.000000);
				graphics.curveTo(19.600000, 0.000000, 21.350000, 1.750000);
				graphics.curveTo(23.000000, 3.400000, 23.000000, 5.750000);
				graphics.endFill();
				// Lines:

				graphics.lineStyle(3.000000, 0xffffff);
				graphics.moveTo(5.400000, 11.600000);
				graphics.lineTo(10.250000, 11.600000);
				graphics.lineTo(10.250000, 6.400000);
				graphics.lineTo(17.600000, 6.400000);
				graphics.moveTo(17.600000, 11.600000);
				graphics.lineTo(10.250000, 11.600000);
				graphics.lineTo(10.250000, 16.650000);
				graphics.lineTo(17.050000, 16.650000);
			}
			return sp;
		}

		override protected function buildUnenabledState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				//背景
				graphics.lineStyle();
				graphics.beginFill(0, 0);
				graphics.moveTo(23.000000, 5.750000);
				graphics.lineTo(23.000000, 17.250000);
				graphics.curveTo(23.000000, 19.600000, 21.350000, 21.350000);
				graphics.curveTo(19.600000, 23.000000, 17.250000, 23.000000);
				graphics.lineTo(5.750000, 23.000000);
				graphics.curveTo(3.400000, 23.000000, 1.750000, 21.350000);
				graphics.curveTo(0.000000, 19.600000, 0.000000, 17.250000);
				graphics.lineTo(0.000000, 5.750000);
				graphics.curveTo(0.000000, 3.400000, 1.750000, 1.750000);
				graphics.curveTo(3.400000, 0.000000, 5.750000, 0.000000);
				graphics.lineTo(17.250000, 0.000000);
				graphics.curveTo(19.600000, 0.000000, 21.350000, 1.750000);
				graphics.curveTo(23.000000, 3.400000, 23.000000, 5.750000);
				graphics.endFill();
				// Lines:

				graphics.lineStyle(3.000000, 0);
				graphics.moveTo(5.400000, 11.600000);
				graphics.lineTo(10.250000, 11.600000);
				graphics.lineTo(10.250000, 6.400000);
				graphics.lineTo(17.600000, 6.400000);
				graphics.moveTo(17.600000, 11.600000);
				graphics.lineTo(10.250000, 11.600000);
				graphics.lineTo(10.250000, 16.650000);
				graphics.lineTo(17.050000, 16.650000);
			}
			return sp;
		}
	}
}
