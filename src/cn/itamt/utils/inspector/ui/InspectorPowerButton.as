package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;

	import flash.display.Shape;

	/**
	 * @author tamt
	 */
	public class InspectorPowerButton extends InspectorButton {
		public function InspectorPowerButton() : void {
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
				graphics.lineStyle(3.000000, 0xffffff);
				graphics.moveTo(15.700000, 6.500000);
				graphics.lineTo(16.450000, 7.150000);
				graphics.lineTo(17.200000, 8.000000);
				graphics.lineTo(17.550000, 8.550000);
				graphics.curveTo(18.500000, 10.150000, 18.500000, 12.150000);
				graphics.curveTo(18.500000, 15.000000, 16.450000, 17.050000);
				graphics.curveTo(14.400000, 19.150000, 11.500000, 19.150000);
				graphics.curveTo(8.650000, 19.150000, 6.550000, 17.050000);
				graphics.curveTo(4.500000, 15.000000, 4.500000, 12.150000);
				graphics.curveTo(4.500000, 10.150000, 5.450000, 8.550000);
				graphics.lineTo(5.850000, 8.000000);
				graphics.lineTo(6.550000, 7.150000);
				graphics.lineTo(7.350000, 6.500000);
				graphics.lineStyle(3.000000, 0xffffff);
				graphics.moveTo(11.500000, 3.900000);
				graphics.lineTo(11.500000, 11.200000);
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
				graphics.moveTo(15.700000, 6.500000);
				graphics.lineTo(16.450000, 7.150000);
				graphics.lineTo(17.200000, 8.000000);
				graphics.lineTo(17.550000, 8.550000);
				graphics.curveTo(18.500000, 10.150000, 18.500000, 12.150000);
				graphics.curveTo(18.500000, 15.000000, 16.450000, 17.050000);
				graphics.curveTo(14.400000, 19.150000, 11.500000, 19.150000);
				graphics.curveTo(8.650000, 19.150000, 6.550000, 17.050000);
				graphics.curveTo(4.500000, 15.000000, 4.500000, 12.150000);
				graphics.curveTo(4.500000, 10.150000, 5.450000, 8.550000);
				graphics.lineTo(5.850000, 8.000000);
				graphics.lineTo(6.550000, 7.150000);
				graphics.lineTo(7.350000, 6.500000);
				graphics.lineStyle(3.000000, 0xffffff);
				graphics.moveTo(11.500000, 3.900000);
				graphics.lineTo(11.500000, 11.200000);
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
				graphics.moveTo(15.700000, 6.500000);
				graphics.lineTo(16.450000, 7.150000);
				graphics.lineTo(17.200000, 8.000000);
				graphics.lineTo(17.550000, 8.550000);
				graphics.curveTo(18.500000, 10.150000, 18.500000, 12.150000);
				graphics.curveTo(18.500000, 15.000000, 16.450000, 17.050000);
				graphics.curveTo(14.400000, 19.150000, 11.500000, 19.150000);
				graphics.curveTo(8.650000, 19.150000, 6.550000, 17.050000);
				graphics.curveTo(4.500000, 15.000000, 4.500000, 12.150000);
				graphics.curveTo(4.500000, 10.150000, 5.450000, 8.550000);
				graphics.lineTo(5.850000, 8.000000);
				graphics.lineTo(6.550000, 7.150000);
				graphics.lineTo(7.350000, 6.500000);
				graphics.lineStyle(3.000000, 0xffffff);
				graphics.moveTo(11.500000, 3.900000);
				graphics.lineTo(11.500000, 11.200000);
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
				graphics.moveTo(15.700000, 6.500000);
				graphics.lineTo(16.450000, 7.150000);
				graphics.lineTo(17.200000, 8.000000);
				graphics.lineTo(17.550000, 8.550000);
				graphics.curveTo(18.500000, 10.150000, 18.500000, 12.150000);
				graphics.curveTo(18.500000, 15.000000, 16.450000, 17.050000);
				graphics.curveTo(14.400000, 19.150000, 11.500000, 19.150000);
				graphics.curveTo(8.650000, 19.150000, 6.550000, 17.050000);
				graphics.curveTo(4.500000, 15.000000, 4.500000, 12.150000);
				graphics.curveTo(4.500000, 10.150000, 5.450000, 8.550000);
				graphics.lineTo(5.850000, 8.000000);
				graphics.lineTo(6.550000, 7.150000);
				graphics.lineTo(7.350000, 6.500000);
				graphics.lineStyle(3.000000, 0xffffff);
				graphics.moveTo(11.500000, 3.900000);
				graphics.lineTo(11.500000, 11.200000);
			}
			
			return sp;
		}
	}
}
