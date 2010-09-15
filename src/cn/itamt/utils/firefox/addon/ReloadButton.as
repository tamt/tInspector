package cn.itamt.utils.firefox.addon {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.ui.InspectorButton;

	import flash.display.Shape;

	/**
	 * @author tamt
	 */
	public class ReloadButton extends InspectorButton {
		public function ReloadButton() : void {
			super();
			
			_tip = InspectorLanguageManager.getStr('ReloadSwf');
		}

		override protected function buildOverState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				//背景
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
				// Lines:
				graphics.lineStyle(3.000000, 0x99cc00);
				graphics.moveTo(15.350000, 11.900000);
				graphics.lineTo(15.300000, 12.350000);
				graphics.lineTo(15.200000, 12.800000);
				graphics.lineTo(15.050000, 13.450000);
				graphics.lineTo(13.900000, 15.100000);
				graphics.curveTo(12.450000, 16.550000, 10.400000, 16.550000);
				graphics.curveTo(8.300000, 16.600000, 6.800000, 15.100000);
				graphics.curveTo(5.350000, 13.650000, 5.400000, 11.550000);
				graphics.curveTo(5.400000, 9.500000, 6.800000, 8.050000);
				graphics.curveTo(7.800000, 7.050000, 9.100000, 6.700000);
				graphics.lineTo(9.600000, 6.600000);
				graphics.lineTo(10.400000, 6.550000);
				graphics.lineTo(11.100000, 6.600000);
			}
			
			return sp;
		}

		override protected function buildDownState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				//背景
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
				// Lines:
				graphics.lineStyle(3.000000, 0xffffff);
				graphics.moveTo(15.350000, 11.900000);
				graphics.lineTo(15.300000, 12.350000);
				graphics.lineTo(15.200000, 12.800000);
				graphics.lineTo(15.050000, 13.450000);
				graphics.lineTo(13.900000, 15.100000);
				graphics.curveTo(12.450000, 16.550000, 10.400000, 16.550000);
				graphics.curveTo(8.300000, 16.600000, 6.800000, 15.100000);
				graphics.curveTo(5.350000, 13.650000, 5.400000, 11.550000);
				graphics.curveTo(5.400000, 9.500000, 6.800000, 8.050000);
				graphics.curveTo(7.800000, 7.050000, 9.100000, 6.700000);
				graphics.lineTo(9.600000, 6.600000);
				graphics.lineTo(10.400000, 6.550000);
				graphics.lineTo(11.100000, 6.600000);
			}
			
			return sp;
		}

		override protected function buildUpState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				//背景
				graphics.beginFill(0, 0);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
				// Lines:
				graphics.lineStyle(3.000000, 0xffffff);
				graphics.moveTo(15.350000, 11.900000);
				graphics.lineTo(15.300000, 12.350000);
				graphics.lineTo(15.200000, 12.800000);
				graphics.lineTo(15.050000, 13.450000);
				graphics.lineTo(13.900000, 15.100000);
				graphics.curveTo(12.450000, 16.550000, 10.400000, 16.550000);
				graphics.curveTo(8.300000, 16.600000, 6.800000, 15.100000);
				graphics.curveTo(5.350000, 13.650000, 5.400000, 11.550000);
				graphics.curveTo(5.400000, 9.500000, 6.800000, 8.050000);
				graphics.curveTo(7.800000, 7.050000, 9.100000, 6.700000);
				graphics.lineTo(9.600000, 6.600000);
				graphics.lineTo(10.400000, 6.550000);
				graphics.lineTo(11.100000, 6.600000);
			}
			
			return sp;
		}

		override protected function buildUnenabledState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				//背景
				graphics.beginFill(0, 0);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
				// Lines:
				graphics.lineStyle(3.000000, 0xffffff);
				graphics.moveTo(15.350000, 11.900000);
				graphics.lineTo(15.300000, 12.350000);
				graphics.lineTo(15.200000, 12.800000);
				graphics.lineTo(15.050000, 13.450000);
				graphics.lineTo(13.900000, 15.100000);
				graphics.curveTo(12.450000, 16.550000, 10.400000, 16.550000);
				graphics.curveTo(8.300000, 16.600000, 6.800000, 15.100000);
				graphics.curveTo(5.350000, 13.650000, 5.400000, 11.550000);
				graphics.curveTo(5.400000, 9.500000, 6.800000, 8.050000);
				graphics.curveTo(7.800000, 7.050000, 9.100000, 6.700000);
				graphics.lineTo(9.600000, 6.600000);
				graphics.lineTo(10.400000, 6.550000);
				graphics.lineTo(11.100000, 6.600000);
			}
			
			return sp;
		}
	}
}
