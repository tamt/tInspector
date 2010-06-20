package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;

	import flash.display.Shape;	

	/**
	 * @author tamt
	 */
	public class InspectorViewBrotherButton extends InspectorViewOperationButton {
		public function InspectorViewBrotherButton() : void {
			super();
			
			_tip = InspectorLanguageManager.getStr('InspectBrother');
		}

		override protected function buildOverState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				//背景
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
				
				graphics.lineStyle(3, 0x99cc00);
				graphics.moveTo(4.8, 6.9);
				graphics.lineTo(4.8, 16.2);
				graphics.moveTo(10.4, 9.8);
				graphics.lineTo(12.1, 11.5);
				graphics.lineTo(10.4, 13.2);
				graphics.moveTo(18.4, 6.9);
				graphics.lineTo(18.4, 16.2);
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
				
				graphics.lineStyle(3, 0xffffff);
				graphics.moveTo(4.8, 6.9);
				graphics.lineTo(4.8, 16.2);
				graphics.moveTo(10.4, 9.8);
				graphics.lineTo(12.1, 11.5);
				graphics.lineTo(10.4, 13.2);
				graphics.moveTo(18.4, 6.9);
				graphics.lineTo(18.4, 16.2);
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
				
				graphics.lineStyle(3, 0xffffff);
				graphics.moveTo(4.8, 6.9);
				graphics.lineTo(4.8, 16.2);
				graphics.moveTo(10.4, 9.8);
				graphics.lineTo(12.1, 11.5);
				graphics.lineTo(10.4, 13.2);
				graphics.moveTo(18.4, 6.9);
				graphics.lineTo(18.4, 16.2);
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
				
				graphics.lineStyle(3, 0x000000);
				graphics.moveTo(4.8, 6.9);
				graphics.lineTo(4.8, 16.2);
				graphics.moveTo(10.4, 9.8);
				graphics.lineTo(12.1, 11.5);
				graphics.lineTo(10.4, 13.2);
				graphics.moveTo(18.4, 6.9);
				graphics.lineTo(18.4, 16.2);
			}
			return sp;
		}
	}
}
