package cn.itamt.utils.inspector.plugins.swfinfo {
	import cn.itamt.utils.inspector.plugins.InspectorPluginId;
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.ui.InspectorButton;

	import flash.display.Graphics;
	import flash.display.Shape;

	/**
	 * @author itamt@qq.com
	 */
	public class SwfInfoButton extends InspectorButton {
		public function SwfInfoButton() {
			super();
			
			_tip = InspectorLanguageManager.getStr(InspectorPluginId.SWFINFO_VIEW);
		}

		override protected function buildDownState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.beginFill(0, 1);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();
			
			g.lineStyle(3.000000, 0xffffff);
			g.moveTo(17.000000, 5.500000);
			g.curveTo(14.700000, 5.500000, 12.950000, 7.050000);
			g.curveTo(11.100000, 8.750000, 11.050000, 11.450000);
			g.lineTo(11.050000, 12.000000);
			g.lineTo(16.400000, 11.850000);
			g.moveTo(11.050000, 12.000000);
			g.curveTo(10.950000, 14.150000, 10.000000, 15.500000);
			g.curveTo(8.700000, 17.550000, 6.000000, 17.550000);
			return sp;
		}

		override protected function buildUpState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.beginFill(0, 0);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();
			
			g.lineStyle(3.000000, 0xffffff);
			g.moveTo(17.000000, 5.500000);
			g.curveTo(14.700000, 5.500000, 12.950000, 7.050000);
			g.curveTo(11.100000, 8.750000, 11.050000, 11.450000);
			g.lineTo(11.050000, 12.000000);
			g.lineTo(16.400000, 11.850000);
			g.moveTo(11.050000, 12.000000);
			g.curveTo(10.950000, 14.150000, 10.000000, 15.500000);
			g.curveTo(8.700000, 17.550000, 6.000000, 17.550000);
			return sp;
		}

		override protected function buildOverState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.beginFill(0, 1);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();
			
			g.lineStyle(3.000000, 0x99cc00);
			g.moveTo(17.000000, 5.500000);
			g.curveTo(14.700000, 5.500000, 12.950000, 7.050000);
			g.curveTo(11.100000, 8.750000, 11.050000, 11.450000);
			g.lineTo(11.050000, 12.000000);
			g.lineTo(16.400000, 11.850000);
			g.moveTo(11.050000, 12.000000);
			g.curveTo(10.950000, 14.150000, 10.000000, 15.500000);
			g.curveTo(8.700000, 17.550000, 6.000000, 17.550000);
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
			g.moveTo(17.000000, 5.500000);
			g.curveTo(14.700000, 5.500000, 12.950000, 7.050000);
			g.curveTo(11.100000, 8.750000, 11.050000, 11.450000);
			g.lineTo(11.050000, 12.000000);
			g.lineTo(16.400000, 11.850000);
			g.moveTo(11.050000, 12.000000);
			g.curveTo(10.950000, 14.150000, 10.000000, 15.500000);
			g.curveTo(8.700000, 17.550000, 6.000000, 17.550000);
			return sp;
		}
	}
}
