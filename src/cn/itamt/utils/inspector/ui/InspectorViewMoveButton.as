package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import flash.display.Shape;	

	/**
	 * @author tamt
	 */
	public class InspectorViewMoveButton extends InspectorViewOperationButton {
		public function InspectorViewMoveButton() : void {
			super();
			
			_tip = InspectorLanguageManager.getStr('LiveMove');
		}

		override protected function buildOverState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				//背景
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
				
				graphics.lineStyle(3, 0x99cc00);
				graphics.moveTo(11.5, 4.2);
				graphics.lineTo(13.2, 5.9);
				graphics.moveTo(11.5, 4.2);
				graphics.lineTo(9.8, 5.9);
				graphics.moveTo(17.1, 9.8);
				graphics.lineTo(18.8, 11.5);
				graphics.lineTo(17.1, 13.2);
				graphics.moveTo(9.8, 17.1);
				graphics.lineTo(11.5, 18.8);
				graphics.lineTo(13.2, 17.1);
				graphics.moveTo(5.9, 13.2);
				graphics.lineTo(4.2, 11.5);
				graphics.lineTo(5.9, 9.8);
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
				graphics.moveTo(11.5, 4.2);
				graphics.lineTo(13.2, 5.9);
				graphics.moveTo(11.5, 4.2);
				graphics.lineTo(9.8, 5.9);
				graphics.moveTo(17.1, 9.8);
				graphics.lineTo(18.8, 11.5);
				graphics.lineTo(17.1, 13.2);
				graphics.moveTo(9.8, 17.1);
				graphics.lineTo(11.5, 18.8);
				graphics.lineTo(13.2, 17.1);
				graphics.moveTo(5.9, 13.2);
				graphics.lineTo(4.2, 11.5);
				graphics.lineTo(5.9, 9.8);
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
				graphics.moveTo(11.5, 4.2);
				graphics.lineTo(13.2, 5.9);
				graphics.moveTo(11.5, 4.2);
				graphics.lineTo(9.8, 5.9);
				graphics.moveTo(17.1, 9.8);
				graphics.lineTo(18.8, 11.5);
				graphics.lineTo(17.1, 13.2);
				graphics.moveTo(9.8, 17.1);
				graphics.lineTo(11.5, 18.8);
				graphics.lineTo(13.2, 17.1);
				graphics.moveTo(5.9, 13.2);
				graphics.lineTo(4.2, 11.5);
				graphics.lineTo(5.9, 9.8);
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
				graphics.moveTo(11.5, 4.2);
				graphics.lineTo(13.2, 5.9);
				graphics.moveTo(11.5, 4.2);
				graphics.lineTo(9.8, 5.9);
				graphics.moveTo(17.1, 9.8);
				graphics.lineTo(18.8, 11.5);
				graphics.lineTo(17.1, 13.2);
				graphics.moveTo(9.8, 17.1);
				graphics.lineTo(11.5, 18.8);
				graphics.lineTo(13.2, 17.1);
				graphics.moveTo(5.9, 13.2);
				graphics.lineTo(4.2, 11.5);
				graphics.lineTo(5.9, 9.8);
			}
			return sp;
		}
	}
}
