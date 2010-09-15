package cn.itamt.utils.inspector.plugins.stats {
	import cn.itamt.utils.inspector.consts.InspectorPluginId;
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.ui.InspectorButton;

	import flash.display.Graphics;
	import flash.display.Shape;

	/**
	 * @author itamt@qq.com
	 */
	public class AppStatsButton extends InspectorButton {
		public function AppStatsButton() {
			super();
			
			_tip = InspectorLanguageManager.getStr(InspectorPluginId.APPSTATS_VIEW);
		}

		override protected function buildDownState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.beginFill(0, 1);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();
			
			g.lineStyle(3.000000, 0xffffff);
			g.moveTo(3.750000, 11.600000);
			g.curveTo(5.000000, 5.100000, 7.450000, 5.050000);
			g.curveTo(9.900000, 5.000000, 11.250000, 11.550000);
			g.curveTo(12.500000, 17.600000, 15.150000, 17.500000);
			g.curveTo(17.850000, 17.300000, 19.300000, 10.500000);
			return sp;
		}

		override protected function buildUpState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.beginFill(0, 0);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();
			
			g.lineStyle(3.000000, 0xffffff);
			g.moveTo(3.750000, 11.600000);
			g.curveTo(5.000000, 5.100000, 7.450000, 5.050000);
			g.curveTo(9.900000, 5.000000, 11.250000, 11.550000);
			g.curveTo(12.500000, 17.600000, 15.150000, 17.500000);
			g.curveTo(17.850000, 17.300000, 19.300000, 10.500000);
			return sp;
		}

		override protected function buildOverState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.beginFill(0, 1);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();
			
			g.lineStyle(3.000000, 0x99cc00);
			g.moveTo(3.750000, 11.600000);
			g.curveTo(5.000000, 5.100000, 7.450000, 5.050000);
			g.curveTo(9.900000, 5.000000, 11.250000, 11.550000);
			g.curveTo(12.500000, 17.600000, 15.150000, 17.500000);
			g.curveTo(17.850000, 17.300000, 19.300000, 10.500000);
			return sp;
		}

		override protected function buildHitState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.beginFill(0, 1);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();
			return sp;
		}

		override protected function buildUnenabledState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.beginFill(0, 0);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();
			
			g.lineStyle(3.000000, 0xffffff);
			g.moveTo(3.750000, 11.600000);
			g.curveTo(5.000000, 5.100000, 7.450000, 5.050000);
			g.curveTo(9.900000, 5.000000, 11.250000, 11.550000);
			g.curveTo(12.500000, 17.600000, 15.150000, 17.500000);
			g.curveTo(17.850000, 17.300000, 19.300000, 10.500000);
			return sp;
		}
	}
}
