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
		protected var _w:Number = 16;
		protected var _h:Number = 16;
		
		private var bmd : BitmapData;
		
		/**
		 * @param	icon 字符串(从InspectorSymbolIcon中获取位图)或者位图数据
		 */
		public function InspectorIconButton(icon : * ) {
			if(icon is String){
				bmd = InspectorSymbolIcon.getIcon(icon);
			}else if (icon is BitmapData) {
				bmd = icon as BitmapData;
			}
			
			_w = bmd.width;
			_h = bmd.height;

			super();
		}
		
		public function setSize(w:Number, h:Number):void {
			_w = w;
			_h = h;

			if(!active) {
				this.downState = buildDownState();
				this.upState = buildUpState();
				this.overState = buildOverState();
				this.hitTestState = buildHitState();
			} else {
				this.downState = buildUpState();
				this.upState = buildOverState();
				this.overState = buildDownState();
				this.hitTestState = buildHitState();
			}
		}

		override protected function buildUpState() : DisplayObject {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;

			g.beginFill(0xffffff, 0);
			g.drawRoundRect(0, 0, _w, _h, 10, 10);
			g.endFill();

			g.beginBitmapFill(bmd, new Matrix(1, 0, 0, 1, (_w - bmd.width) / 2, (_h - bmd.height) / 2), false);
			g.drawRect((_w - bmd.width) / 2, (_h - bmd.height) / 2, bmd.width, bmd.height);
			g.endFill();

			sp.filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];

			return sp;
		}

		override protected function buildOverState() : DisplayObject {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;

			g.beginFill(0xcccccc, 0);
			g.drawRoundRect(0, 0, _w, _h, 10, 10);
			g.endFill();

			g.beginBitmapFill(bmd, new Matrix(1, 0, 0, 1, (_w - bmd.width) / 2, (_h - bmd.height) / 2), false);
			g.drawRect((_w - bmd.width) / 2, (_h - bmd.height) / 2, bmd.width, bmd.height);
			g.endFill();

			return sp;
		}

		override protected function buildDownState() : DisplayObject {
			var sp : Shape = new Shape();
			with(sp) {
				graphics.beginFill(0xcccccc, 0);
				graphics.drawRoundRect(0, 0, _w, _h, 10, 10);
				graphics.endFill();
			}

			var g : Graphics = sp.graphics;
			g.beginBitmapFill(bmd, new Matrix(1, 0, 0, 1, (_w - bmd.width) / 2, (_h - bmd.height) / 2), false);
			g.drawRect((_w - bmd.width) / 2, (_h - bmd.height) / 2, bmd.width, bmd.height);
			g.endFill();

			return sp;
		}
		
		override protected function buildHitState() : DisplayObject {
			var sp : Shape = new Shape();
			with(sp) {
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, _w, _h, 10, 10);
				graphics.endFill();
			}
			return sp;
		}

		public function dispose():void {
			this.bmd = null;
		}
	}
}
