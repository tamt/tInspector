package cn.itamt.utils.inspector.core.propertyview {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.ui.InspectorButton;

	import flash.display.DisplayObject;
	import flash.display.Shape;

	/**
	 * @author tamt
	 */
	public class PropertiesViewButton extends InspectorButton {
		public function PropertiesViewButton() : void {
			super();

			_tip = InspectorLanguageManager.getStr('InspectInfo');
		}

		override protected function buildOverState() : DisplayObject {
			var sp : Shape = new Shape();
			with(sp) {
				// 背景
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

		override protected function buildDownState() : DisplayObject {
			var sp : Shape = new Shape();
			with(sp) {
				// 背景
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

		override protected function buildUpState() : DisplayObject {
			var sp : Shape = new Shape();
			with(sp) {
				// 背景
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

		override protected function buildUnenabledState() : DisplayObject {
			var sp : Shape = new Shape();
			with(sp) {
				// 背景
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
