package cn.itamt.utils.inspector.plugins.gerrorkeeper {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.ui.InspectorButton;

	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;

	/**
	 * @author itamt@qq.com
	 */
	public class GlobalErrorsHistoryButton extends InspectorButton {
		public function GlobalErrorsHistoryButton() {
			super();

			_tip = InspectorLanguageManager.getStr("GEK_History");
		}

		override public function set active(value : Boolean) : void {
			_active = value;
			if(!active) {
				this.downState = buildDownState();
				this.upState = buildUpState();
				this.overState = buildOverState();
				this.hitTestState = buildHitState();
			} else {
				this.downState = buildUpState();
				this.upState = buildActiveState();
				this.overState = buildDownState();
				this.hitTestState = buildHitState();
			}
		}

		override protected function buildDownState() : DisplayObject {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.beginFill(0, 1);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();

			g.lineStyle(3.000000, 0xffffff);
			g.moveTo(4.400000, 5.300000);
			g.lineTo(11.900000, 5.300000);
			g.moveTo(4.400000, 11.300000);
			g.lineTo(11.900000, 11.300000);
			g.moveTo(4.400000, 17.750000);
			g.lineTo(11.900000, 17.750000);
			g.moveTo(17.200000, 17.750000);
			g.lineTo(18.350000, 17.750000);
			g.moveTo(17.200000, 11.300000);
			g.lineTo(18.350000, 11.300000);
			g.moveTo(17.200000, 5.300000);
			g.lineTo(18.350000, 5.300000);
			return sp;
		}

		override protected function buildUpState() : DisplayObject {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.beginFill(0, 0);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();

			g.lineStyle(3.000000, 0xffffff);
			g.moveTo(4.400000, 5.300000);
			g.lineTo(11.900000, 5.300000);
			g.moveTo(4.400000, 11.300000);
			g.lineTo(11.900000, 11.300000);
			g.moveTo(4.400000, 17.750000);
			g.lineTo(11.900000, 17.750000);
			g.moveTo(17.200000, 17.750000);
			g.lineTo(18.350000, 17.750000);
			g.moveTo(17.200000, 11.300000);
			g.lineTo(18.350000, 11.300000);
			g.moveTo(17.200000, 5.300000);
			g.lineTo(18.350000, 5.300000);
			return sp;
		}

		protected function buildActiveState() : DisplayObject {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.beginFill(0, 0);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();

			g.lineStyle(3.000000, 0x99cc00);
			g.moveTo(4.400000, 5.300000);
			g.lineTo(11.900000, 5.300000);
			g.moveTo(4.400000, 11.300000);
			g.lineTo(11.900000, 11.300000);
			g.moveTo(4.400000, 17.750000);
			g.lineTo(11.900000, 17.750000);
			g.moveTo(17.200000, 17.750000);
			g.lineTo(18.350000, 17.750000);
			g.moveTo(17.200000, 11.300000);
			g.lineTo(18.350000, 11.300000);
			g.moveTo(17.200000, 5.300000);
			g.lineTo(18.350000, 5.300000);
			return sp;
		}

		override protected function buildOverState() : DisplayObject {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.beginFill(0, 1);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();

			g.lineStyle(3.000000, 0x99cc00);
			g.moveTo(4.400000, 5.300000);
			g.lineTo(11.900000, 5.300000);
			g.moveTo(4.400000, 11.300000);
			g.lineTo(11.900000, 11.300000);
			g.moveTo(4.400000, 17.750000);
			g.lineTo(11.900000, 17.750000);
			g.moveTo(17.200000, 17.750000);
			g.lineTo(18.350000, 17.750000);
			g.moveTo(17.200000, 11.300000);
			g.lineTo(18.350000, 11.300000);
			g.moveTo(17.200000, 5.300000);
			g.lineTo(18.350000, 5.300000);
			return sp;
		}

		override protected function buildHitState() : DisplayObject {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.beginFill(0, 1);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();
			return sp;
		}

		override protected function buildUnenabledState() : DisplayObject {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.beginFill(0, 0);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();

			g.lineStyle(3.000000, 0xffffff);
			g.moveTo(4.400000, 5.300000);
			g.lineTo(11.900000, 5.300000);
			g.moveTo(4.400000, 11.300000);
			g.lineTo(11.900000, 11.300000);
			g.moveTo(4.400000, 17.750000);
			g.lineTo(11.900000, 17.750000);
			g.moveTo(17.200000, 17.750000);
			g.lineTo(18.350000, 17.750000);
			g.moveTo(17.200000, 11.300000);
			g.lineTo(18.350000, 11.300000);
			g.moveTo(17.200000, 5.300000);
			g.lineTo(18.350000, 5.300000);
			return sp;
		}
	}
}
