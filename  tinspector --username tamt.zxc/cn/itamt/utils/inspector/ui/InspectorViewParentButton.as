package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;

	import flash.display.Shape;	

	/**
	 * @author tamt
	 */
	public class InspectorViewParentButton extends InspectorViewOperationButton {
		public function InspectorViewParentButton() : void {
			super();
			
			_tip = InspectorLanguageManager.getStr('InspectParent');
		}

		override protected function buildOverState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				//背景
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
				
				graphics.lineStyle(3, 0x99cc00);
				graphics.moveTo(5.2, 4.9);
				graphics.lineTo(17.8, 4.9);
				graphics.moveTo(13.2, 12.4);
				graphics.lineTo(11.5, 10.7);
				graphics.lineTo(9.8, 12.4);
				graphics.moveTo(6.9, 18.6);
				graphics.lineTo(16.1, 18.6);
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
				graphics.moveTo(5.2, 4.9);
				graphics.lineTo(17.8, 4.9);
				graphics.moveTo(13.2, 12.4);
				graphics.lineTo(11.5, 10.7);
				graphics.lineTo(9.8, 12.4);
				graphics.moveTo(6.9, 18.6);
				graphics.lineTo(16.1, 18.6);
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
				graphics.moveTo(5.2, 4.9);
				graphics.lineTo(17.8, 4.9);
				graphics.moveTo(13.2, 12.4);
				graphics.lineTo(11.5, 10.7);
				graphics.lineTo(9.8, 12.4);
				graphics.moveTo(6.9, 18.6);
				graphics.lineTo(16.1, 18.6);
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
				graphics.moveTo(5.2, 4.9);
				graphics.lineTo(17.8, 4.9);
				graphics.moveTo(13.2, 12.4);
				graphics.lineTo(11.5, 10.7);
				graphics.lineTo(9.8, 12.4);
				graphics.moveTo(6.9, 18.6);
				graphics.lineTo(16.1, 18.6);
			}
			return sp;
		}
	}
}
