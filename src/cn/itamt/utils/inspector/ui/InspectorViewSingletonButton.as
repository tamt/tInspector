package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;

	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.Shape;

	/**
	 * 单面板/多面板 模式.
	 * @author itamt@qq.com
	 */
	public class InspectorViewSingletonButton extends InspectorViewFullButton {
		public function InspectorViewSingletonButton() {
			super();
		}

		
		override protected function buildOverState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			
			//背景
			g.beginFill(0, 1);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();
				
			g.lineStyle(3, 0x99cc00, 1.0, false, "normal", CapsStyle.SQUARE, JointStyle.MITER);
			g.drawRect(6, 6, 9, 9);
			
			return sp;
		}

		override protected function buildDownState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			
			//背景
			g.beginFill(0, 1);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();
				
			g.lineStyle(3, 0xffffff, 1.0, false, "normal", CapsStyle.SQUARE, JointStyle.MITER);
			g.drawRect(6, 6, 9, 9);
			
			return sp;
		}

		override protected function buildUpState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			
			//背景
			g.beginFill(0, 0);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();
				
			g.lineStyle(3, 0xffffff, 1.0, false, "normal", CapsStyle.SQUARE, JointStyle.MITER);
			g.drawRect(6, 6, 9, 9);
			
			return sp;
		}

		
		//---------------------------
		//---------------------------
		//---------------------------

		override protected function buildOverState2() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			
			//背景
			g.beginFill(0, 1);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();
				
			g.lineStyle(3, 0x99cc00);
			g.drawRect(5, 5, 6, 6);			g.drawRect(9, 9, 6, 6);
			
			return sp;
		}

		override protected function buildDownState2() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			
			//背景
			g.beginFill(0, 1);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();
				
			g.lineStyle(3, 0xffffff);
			g.drawRect(5, 5, 6, 6);
			g.drawRect(9, 9, 6, 6);
			
			return sp;
		}

		override protected function buildUpState2() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			
			//背景
			g.beginFill(0, 0);
			g.drawRoundRect(0, 0, 23, 23, 10, 10);
			g.endFill();
				
			g.lineStyle(3, 0xffffff);
			g.drawRect(5, 5, 6, 6);
			g.drawRect(9, 9, 6, 6);
			
			return sp;
		}

		//-----------------------------------		//-----------------------------------		//-----------------------------------		//-----------------------------------

		override protected function updateStates() : void {
			super.updateStates();
			
			if(_normalMode) {
				_tip = InspectorLanguageManager.getStr('SingletonMode');
			} else {
				_tip = InspectorLanguageManager.getStr('MultipleMode');
			}
		}
	}
}
