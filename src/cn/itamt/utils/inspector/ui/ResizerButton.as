package cn.itamt.utils.inspector.ui {
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.Shape;
	import flash.display.SimpleButton;		

	/**
	 * 调整面板大小的小按钮
	 * @author itamt@qq.com
	 */
	public class ResizerButton extends SimpleButton {
		public function ResizerButton(w : Number = 10, h : Number = 10) {
			super(buildBlockShape(w, h), buildBlockShape(w, h), buildBlockShape(w, h), buildBlockShape(w, h));
		}

		private function buildBlockShape(w : Number, h : Number, color : uint = 0x464646) : Shape {
			var sp : Shape = new Shape();
			
			sp.graphics.lineStyle(1, 0x666666, 1, false, 'normal', CapsStyle.NONE, JointStyle.MITER);
			sp.graphics.beginFill(color);
			sp.graphics.moveTo(0, 0);
			sp.graphics.lineTo(-w, 0);			sp.graphics.lineTo(0, -h);			sp.graphics.lineTo(0, 0);
			sp.graphics.moveTo(-w / 2, 0);			sp.graphics.moveTo(0, -h / 2);
			sp.graphics.endFill();
			
			return sp;
		}
	}
}
