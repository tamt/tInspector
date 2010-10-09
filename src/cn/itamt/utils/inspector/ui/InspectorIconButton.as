package cn.itamt.utils.inspector.ui {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;

	/**
	 * icon button.
	 * @author itamt[at]qq.com
	 */
	public class InspectorIconButton extends InspectorButton {
		private var bmd : BitmapData;

		public function InspectorIconButton(icon : String) {
			bmd = InspectorSymbolIcon.getIcon(icon);

			super();
		}

		override protected function buildUpState() : DisplayObject {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;

			g.beginFill(0xffffff, 0);
			g.drawRoundRect(0, 0, 16, 16, 10, 10);
			g.endFill();

			g.beginBitmapFill(bmd, new Matrix(1, 0, 0, 1, (16 - bmd.width) / 2, (16 - bmd.height) / 2), false);
			g.drawRect((16 - bmd.width) / 2, (16 - bmd.height) / 2, bmd.width, bmd.height);
			g.endFill();

			return sp;
		}

		override protected function buildOverState() : DisplayObject {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;

			g.beginFill(0xcccccc, 0);
			g.drawRoundRect(0, 0, 16, 16, 10, 10);
			g.endFill();

			g.beginBitmapFill(bmd, new Matrix(1, 0, 0, 1, (16 - bmd.width) / 2, (16 - bmd.height) / 2), false);
			g.drawRect((16 - bmd.width) / 2, (16 - bmd.height) / 2, bmd.width, bmd.height);
			g.endFill();

			sp.filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];

			return sp;
		}

		override protected function buildDownState() : DisplayObject {
			var sp : Shape = new Shape();
			with(sp) {
				graphics.beginFill(0xcccccc, 0);
				graphics.drawRoundRect(0, 0, 16, 16, 10, 10);
				graphics.endFill();
			}

			var g : Graphics = sp.graphics;
			g.beginBitmapFill(bmd, new Matrix(1, 0, 0, 1, (16 - bmd.width) / 2, (16 - bmd.height) / 2), false);
			g.drawRect((16 - bmd.width) / 2, (16 - bmd.height) / 2, bmd.width, bmd.height);
			g.endFill();

			return sp;
		}

		public function dispose():void {
			this.bmd = null;
		}
	}
}
