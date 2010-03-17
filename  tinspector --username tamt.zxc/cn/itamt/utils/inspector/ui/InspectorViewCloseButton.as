package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;

	import flash.display.Shape;			

	/**
	 * @author tamt
	 */
	public class InspectorViewCloseButton extends InspectorViewOperationButton {
		public function InspectorViewCloseButton() : void {
			super();
			
			_tip = InspectorLanguageManager.getStr('Close');
		}

		override protected function buildOverState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				//背景
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
				
				graphics.lineStyle(3, 0xff0000);
				graphics.moveTo(8.7, 8.7);
				graphics.lineTo(14.2, 14.2);
				graphics.moveTo(8.7, 14.2);
				graphics.lineTo(14.2, 8.7);
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
				graphics.moveTo(8.7, 8.7);
				graphics.lineTo(14.2, 14.2);
				graphics.moveTo(8.7, 14.2);
				graphics.lineTo(14.2, 8.7);
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
				
				graphics.lineStyle(3, 0xff0000);
				graphics.moveTo(8.7, 8.7);
				graphics.lineTo(14.2, 14.2);
				graphics.moveTo(8.7, 14.2);
				graphics.lineTo(14.2, 8.7);
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
				graphics.moveTo(8.7, 8.7);
				graphics.lineTo(14.2, 14.2);
				graphics.moveTo(8.7, 14.2);
				graphics.lineTo(14.2, 8.7);
			}
			return sp;
		}
	}
}
