package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;

	import flash.display.Shape;	

	/**
	 * @author tamt
	 */
	public class InspectorViewInfoButton extends InspectorViewOperationButton {
		public function InspectorViewInfoButton() : void {
			super();
			
			_tip = InspectorLanguageManager.getStr('InspectInfo');
		}

		override protected function buildOverState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				//背景
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
				
				graphics.lineStyle(3, 0x99cc00);
				graphics.moveTo(5.2, 9.2);
				graphics.curveTo(11.5, 2, 17.8, 9.2);
				graphics.moveTo(5.2, 13.8);
				graphics.curveTo(11.5, 21, 17.8, 13.8);
				graphics.moveTo(10.9, 11.5);
				graphics.lineTo(12, 11.5);
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
				graphics.moveTo(5.2, 9.2);
				graphics.curveTo(11.5, 2, 17.8, 9.2);
				graphics.moveTo(5.2, 13.8);
				graphics.curveTo(11.5, 21, 17.8, 13.8);
				graphics.moveTo(10.9, 11.5);
				graphics.lineTo(12, 11.5);
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
				graphics.moveTo(5.2, 9.2);
				graphics.curveTo(11.5, 2, 17.8, 9.2);
				graphics.moveTo(5.2, 13.8);
				graphics.curveTo(11.5, 21, 17.8, 13.8);
				graphics.moveTo(10.9, 11.5);
				graphics.lineTo(12, 11.5);
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
				graphics.moveTo(5.2, 9.2);
				graphics.curveTo(11.5, 2, 17.8, 9.2);
				graphics.moveTo(5.2, 13.8);
				graphics.curveTo(11.5, 21, 17.8, 13.8);
				graphics.moveTo(10.9, 11.5);
				graphics.lineTo(12, 11.5);
			}
			return sp;
		}
	}
}
