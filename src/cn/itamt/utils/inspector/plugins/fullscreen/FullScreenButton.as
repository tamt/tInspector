package cn.itamt.utils.inspector.plugins.fullscreen {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.ui.InspectorButton;

	import flash.display.Shape;

	/**
	 * @author tamt
	 */
	public class FullScreenButton extends InspectorButton {
		public function FullScreenButton() : void {
			super();
			
			_tip = InspectorLanguageManager.getStr('FullScreen');
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
				graphics.moveTo(15.150000, 5.250000);
				graphics.lineTo(18.300000, 5.250000);
				graphics.lineTo(18.300000, 8.400000);
				graphics.moveTo(5.100000, 8.400000);
				graphics.lineTo(5.100000, 5.250000);
				graphics.lineTo(8.250000, 5.250000);
				graphics.moveTo(8.250000, 18.450000);
				graphics.lineTo(5.100000, 18.450000);
				graphics.lineTo(5.100000, 15.500000);
				graphics.moveTo(18.300000, 15.500000);
				graphics.lineTo(18.300000, 18.450000);
				graphics.lineTo(15.150000, 18.450000);
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
				graphics.moveTo(15.150000, 5.250000);
				graphics.lineTo(18.300000, 5.250000);
				graphics.lineTo(18.300000, 8.400000);
				graphics.moveTo(5.100000, 8.400000);
				graphics.lineTo(5.100000, 5.250000);
				graphics.lineTo(8.250000, 5.250000);
				graphics.moveTo(8.250000, 18.450000);
				graphics.lineTo(5.100000, 18.450000);
				graphics.lineTo(5.100000, 15.500000);
				graphics.moveTo(18.300000, 15.500000);
				graphics.lineTo(18.300000, 18.450000);
				graphics.lineTo(15.150000, 18.450000);
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
				graphics.moveTo(15.150000, 5.250000);
				graphics.lineTo(18.300000, 5.250000);
				graphics.lineTo(18.300000, 8.400000);
				graphics.moveTo(5.100000, 8.400000);
				graphics.lineTo(5.100000, 5.250000);
				graphics.lineTo(8.250000, 5.250000);
				graphics.moveTo(8.250000, 18.450000);
				graphics.lineTo(5.100000, 18.450000);
				graphics.lineTo(5.100000, 15.500000);
				graphics.moveTo(18.300000, 15.500000);
				graphics.lineTo(18.300000, 18.450000);
				graphics.lineTo(15.150000, 18.450000);
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
				graphics.moveTo(15.150000, 5.250000);
				graphics.lineTo(18.300000, 5.250000);
				graphics.lineTo(18.300000, 8.400000);
				graphics.moveTo(5.100000, 8.400000);
				graphics.lineTo(5.100000, 5.250000);
				graphics.lineTo(8.250000, 5.250000);
				graphics.moveTo(8.250000, 18.450000);
				graphics.lineTo(5.100000, 18.450000);
				graphics.lineTo(5.100000, 15.500000);
				graphics.moveTo(18.300000, 15.500000);
				graphics.lineTo(18.300000, 18.450000);
				graphics.lineTo(15.150000, 18.450000);
			}
			
			return sp;
		}
	}
}
