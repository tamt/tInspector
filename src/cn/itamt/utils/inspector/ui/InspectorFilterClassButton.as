package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;

	import flash.display.Shape;

	/**
	 * @author itamt@qq.com
	 */
	public class InspectorFilterClassButton extends InspectorViewOperationButton {
		private var _active : Boolean = true;

		public function InspectorFilterClassButton() {
			super();
			
			_tip = InspectorLanguageManager.getStr('SetFilterClass');
		}

		public function set active(value : Boolean) : void {
			_active = value;
			if(active) {
				this.downState = buildDownState();
				this.upState = buildUpState();
				this.overState = buildOverState();
				this.hitTestState = buildHitState();
			
				_tip = InspectorLanguageManager.getStr('SetFilterClass');
			} else {
				this.downState = buildUpState();
				this.upState = buildDownState();
				this.overState = buildOverState();
				this.hitTestState = buildHitState();
			
				_tip = InspectorLanguageManager.getStr('unSetFilterClass');
			}
		}

		public function get active() : Boolean {
			return _active;
		}

		override protected function buildOverState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				// Fills:
				graphics.lineStyle();
				graphics.beginFill(0x000000);
				graphics.moveTo(21.350000, 1.750000);
				graphics.curveTo(23.000000, 3.400000, 23.000000, 5.750000);
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
				graphics.beginFill(0x99cc00);
				graphics.moveTo(13.150000, 9.800000);
				graphics.curveTo(13.900000, 10.500000, 13.900000, 11.500000);
				graphics.curveTo(13.900000, 12.500000, 13.150000, 13.200000);
				graphics.curveTo(12.450000, 13.900000, 11.500000, 13.900000);
				graphics.curveTo(10.550000, 13.900000, 9.800000, 13.200000);
				graphics.curveTo(9.100000, 12.500000, 9.100000, 11.500000);
				graphics.curveTo(9.100000, 10.500000, 9.800000, 9.800000);
				graphics.curveTo(10.550000, 9.100000, 11.500000, 9.100000);
				graphics.curveTo(12.450000, 9.100000, 13.150000, 9.800000);
				graphics.endFill();
				// Lines:
				graphics.lineStyle(3.000000, 0x99cc00);
				graphics.moveTo(15.000000, 5.300000);
				graphics.lineTo(7.600000, 5.300000);
				graphics.curveTo(4.150000, 5.300000, 4.150000, 8.750000);
				graphics.lineTo(4.150000, 13.950000);
				graphics.curveTo(4.150000, 17.400000, 7.600000, 17.400000);
				graphics.lineTo(15.000000, 17.400000);
				graphics.curveTo(18.450000, 17.400000, 18.450000, 13.950000);
				graphics.lineTo(18.450000, 8.750000);
				graphics.curveTo(18.450000, 5.300000, 15.000000, 5.300000);
			}
			return sp;
		}

		override protected function buildDownState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				// Fills:
				graphics.lineStyle();
				graphics.beginFill(0x000000);
				graphics.moveTo(21.350000, 1.750000);
				graphics.curveTo(23.000000, 3.400000, 23.000000, 5.750000);
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
				graphics.beginFill(0xffffff);
				graphics.moveTo(13.150000, 9.800000);
				graphics.curveTo(13.900000, 10.500000, 13.900000, 11.500000);
				graphics.curveTo(13.900000, 12.500000, 13.150000, 13.200000);
				graphics.curveTo(12.450000, 13.900000, 11.500000, 13.900000);
				graphics.curveTo(10.550000, 13.900000, 9.800000, 13.200000);
				graphics.curveTo(9.100000, 12.500000, 9.100000, 11.500000);
				graphics.curveTo(9.100000, 10.500000, 9.800000, 9.800000);
				graphics.curveTo(10.550000, 9.100000, 11.500000, 9.100000);
				graphics.curveTo(12.450000, 9.100000, 13.150000, 9.800000);
				graphics.endFill();
				// Lines:

				graphics.lineStyle(3.000000, 0xffffff);
				graphics.moveTo(15.000000, 5.300000);
				graphics.lineTo(7.600000, 5.300000);
				graphics.curveTo(4.150000, 5.300000, 4.150000, 8.750000);
				graphics.lineTo(4.150000, 13.950000);
				graphics.curveTo(4.150000, 17.400000, 7.600000, 17.400000);
				graphics.lineTo(15.000000, 17.400000);
				graphics.curveTo(18.450000, 17.400000, 18.450000, 13.950000);
				graphics.lineTo(18.450000, 8.750000);
				graphics.curveTo(18.450000, 5.300000, 15.000000, 5.300000);
//			
			}
			return sp;
		}

		override protected function buildUpState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				// Fills:
				graphics.lineStyle();
				graphics.beginFill(0x000000, 0);
				graphics.moveTo(21.350000, 1.750000);
				graphics.curveTo(23.000000, 3.400000, 23.000000, 5.750000);
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
				graphics.beginFill(0xffffff);
				graphics.moveTo(13.150000, 9.800000);
				graphics.curveTo(13.900000, 10.500000, 13.900000, 11.500000);
				graphics.curveTo(13.900000, 12.500000, 13.150000, 13.200000);
				graphics.curveTo(12.450000, 13.900000, 11.500000, 13.900000);
				graphics.curveTo(10.550000, 13.900000, 9.800000, 13.200000);
				graphics.curveTo(9.100000, 12.500000, 9.100000, 11.500000);
				graphics.curveTo(9.100000, 10.500000, 9.800000, 9.800000);
				graphics.curveTo(10.550000, 9.100000, 11.500000, 9.100000);
				graphics.curveTo(12.450000, 9.100000, 13.150000, 9.800000);
				graphics.endFill();
				// Lines:

				graphics.lineStyle(3.000000, 0xffffff);
				graphics.moveTo(15.000000, 5.300000);
				graphics.lineTo(7.600000, 5.300000);
				graphics.curveTo(4.150000, 5.300000, 4.150000, 8.750000);
				graphics.lineTo(4.150000, 13.950000);
				graphics.curveTo(4.150000, 17.400000, 7.600000, 17.400000);
				graphics.lineTo(15.000000, 17.400000);
				graphics.curveTo(18.450000, 17.400000, 18.450000, 13.950000);
				graphics.lineTo(18.450000, 8.750000);
				graphics.curveTo(18.450000, 5.300000, 15.000000, 5.300000);
			}
			return sp;
		}

		override protected function buildUnenabledState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				// Fills:
				graphics.lineStyle();
				graphics.beginFill(0x000000, 0);
				graphics.moveTo(21.350000, 1.750000);
				graphics.curveTo(23.000000, 3.400000, 23.000000, 5.750000);
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
				graphics.beginFill(0);
				graphics.moveTo(13.150000, 9.800000);
				graphics.curveTo(13.900000, 10.500000, 13.900000, 11.500000);
				graphics.curveTo(13.900000, 12.500000, 13.150000, 13.200000);
				graphics.curveTo(12.450000, 13.900000, 11.500000, 13.900000);
				graphics.curveTo(10.550000, 13.900000, 9.800000, 13.200000);
				graphics.curveTo(9.100000, 12.500000, 9.100000, 11.500000);
				graphics.curveTo(9.100000, 10.500000, 9.800000, 9.800000);
				graphics.curveTo(10.550000, 9.100000, 11.500000, 9.100000);
				graphics.curveTo(12.450000, 9.100000, 13.150000, 9.800000);
				graphics.endFill();
				// Lines:
				graphics.lineStyle(3.000000, 0);
				graphics.moveTo(15.000000, 5.300000);
				graphics.lineTo(7.600000, 5.300000);
				graphics.curveTo(4.150000, 5.300000, 4.150000, 8.750000);
				graphics.lineTo(4.150000, 13.950000);
				graphics.curveTo(4.150000, 17.400000, 7.600000, 17.400000);
				graphics.lineTo(15.000000, 17.400000);
				graphics.curveTo(18.450000, 17.400000, 18.450000, 13.950000);
				graphics.lineTo(18.450000, 8.750000);
				graphics.curveTo(18.450000, 5.300000, 15.000000, 5.300000);
			}
			return sp;
		}
	}
}
