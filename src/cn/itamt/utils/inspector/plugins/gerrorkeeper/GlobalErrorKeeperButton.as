package cn.itamt.utils.inspector.plugins.gerrorkeeper {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.plugins.InspectorPluginId;
	import cn.itamt.utils.inspector.ui.InspectorButton;

	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;

	/**
	 * @author itamt@qq.com
	 */
	public class GlobalErrorKeeperButton extends InspectorButton {
		public function GlobalErrorKeeperButton() {
			super();

			_tip = InspectorLanguageManager.getStr(InspectorPluginId.GLOBAL_ERROR_KEEPER);
		}

		override public function set active(value : Boolean) : void {
			_active = value;
			if(!active) {
				this.downState = buildDownState();
				this.upState = buildUpState();
				this.overState = buildOverState();
				this.hitTestState = buildHitState();

				_tip = InspectorLanguageManager.getStr("GEK_Disabled");
			} else {
				this.downState = buildUpState();
				this.upState = buildActiveState();
				this.overState = buildDownState();
				this.hitTestState = buildHitState();

				_tip = InspectorLanguageManager.getStr("GEK_Enabled");
			}
		}

		override protected function buildDownState() : DisplayObject {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.beginFill(0, 1);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();

			g.lineStyle(3.000000, 0xffffff);
			g.moveTo(11.500000, 17.100000);
			g.lineTo(11.500000, 18.250000);
			g.moveTo(11.550000, 4.800000);
			g.lineTo(11.550000, 12.450000);
			return sp;
		}

		override protected function buildUpState() : DisplayObject {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.beginFill(0, 0);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();

			g.lineStyle(3.000000, 0xffffff);
			g.moveTo(11.500000, 17.100000);
			g.lineTo(11.500000, 18.250000);
			g.moveTo(11.550000, 4.800000);
			g.lineTo(11.550000, 12.450000);
			return sp;
		}

		protected function buildActiveState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.beginFill(0, 0);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();

			g.lineStyle(3.000000, 0x99cc00);
			g.moveTo(11.500000, 17.100000);
			g.lineTo(11.500000, 18.250000);
			g.moveTo(11.550000, 4.800000);
			g.lineTo(11.550000, 12.450000);
			return sp;
		}

		override protected function buildOverState() : DisplayObject {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.beginFill(0, 1);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();

			g.lineStyle(3.000000, 0x99cc00);
			g.moveTo(11.500000, 17.100000);
			g.lineTo(11.500000, 18.250000);
			g.moveTo(11.550000, 4.800000);
			g.lineTo(11.550000, 12.450000);
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
			g.moveTo(11.500000, 17.100000);
			g.lineTo(11.500000, 18.250000);
			g.moveTo(11.550000, 4.800000);
			g.lineTo(11.550000, 12.450000);
			return sp;
		}
	}
}
