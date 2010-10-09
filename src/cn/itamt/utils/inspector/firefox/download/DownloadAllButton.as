package cn.itamt.utils.inspector.firefox.download {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.ui.InspectorButton;

	import flash.display.DisplayObject;
	import flash.display.Shape;

	/**
	 * @author tamt
	 */
	public class DownloadAllButton extends InspectorButton {
		public function DownloadAllButton() : void {
			super();
			
			_tip = InspectorLanguageManager.getStr('ReloadSwf');
		}

		override protected function buildOverState() : DisplayObject {
			var sp : Shape = new Shape();
			with(sp) {
				//背景
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
				// Lines:
				graphics.lineStyle(3.000000, 0x99cc00);
				graphics.moveTo(5.000000, 18.750000);
				graphics.lineTo(18.000000, 18.750000);
				graphics.moveTo(11.500000, 3.900000);
				graphics.lineTo(11.500000, 12.850000);
				
				graphics.moveTo(6.650000, 9.150000);
				graphics.lineTo(11.500000, 14.700000);
				graphics.lineTo(16.400000, 9.150000);
			}
			
			return sp;
		}

		override protected function buildDownState() : DisplayObject {
			var sp : Shape = new Shape();
			with(sp) {
				//背景
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
				// Lines:
				graphics.lineStyle(3.000000, 0xffffff);
				graphics.moveTo(5.000000, 18.750000);
				graphics.lineTo(18.000000, 18.750000);
				
				graphics.moveTo(11.500000, 3.900000);
				graphics.lineTo(11.500000, 12.850000);
				
				graphics.moveTo(6.650000, 9.150000);
				graphics.lineTo(11.500000, 14.700000);
				graphics.lineTo(16.400000, 9.150000);
			}
			
			return sp;
		}

		override protected function buildUpState() : DisplayObject {
			var sp : Shape = new Shape();
			with(sp) {
				//背景
				graphics.beginFill(0, 0);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
				// Lines:
				graphics.lineStyle(3.000000, 0xffffff);
				graphics.moveTo(5.000000, 18.750000);
				graphics.lineTo(18.000000, 18.750000);
				
				graphics.moveTo(11.500000, 3.900000);
				graphics.lineTo(11.500000, 12.850000);
				
				graphics.moveTo(6.650000, 9.150000);
				graphics.lineTo(11.500000, 14.700000);
				graphics.lineTo(16.400000, 9.150000);
			}
			
			return sp;
		}

		override protected function buildUnenabledState() : DisplayObject {
			var sp : Shape = new Shape();
			with(sp) {
				//背景
				graphics.beginFill(0, 0);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
				// Lines:
				graphics.lineStyle(3.000000, 0xffffff);
				graphics.moveTo(5.000000, 18.750000);
				graphics.lineTo(18.000000, 18.750000);
				
				graphics.moveTo(11.500000, 3.900000);
				graphics.lineTo(11.500000, 12.850000);
				
				graphics.moveTo(6.650000, 9.150000);
				graphics.lineTo(11.500000, 14.700000);
				graphics.lineTo(16.400000, 9.150000);
			}
			
			return sp;
		}
	}
}
