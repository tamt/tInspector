package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;

	import flash.events.MouseEvent;	

	import cn.itamt.utils.inspector.ui.InspectorViewOperationButton;

	import flash.display.Shape;	

	/**
	 * 面板的‘最小化/还原’按钮。
	 * @author itamt@qq.com
	 */
	public class InspectorViewResizeButton extends InspectorViewOperationButton {
		public function InspectorViewResizeButton() {
			super();
			
			_tip = InspectorLanguageManager.getStr('MinimizePanel');
			
			this.addEventListener(MouseEvent.CLICK, onToggleMode, false, 0, true);
			this.updateStates();
		}

		override protected function buildOverState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				//背景
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
				
				graphics.lineStyle(3, 0xff0000);
				graphics.moveTo(10, 13);
				graphics.lineTo(16, 13);
			}
			return sp;
		}

		override protected function buildDownState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				//背景
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
				
				
				graphics.lineStyle(3, 0xffffff);
				graphics.moveTo(10, 13);
				graphics.lineTo(16, 13);
			}
			return sp;
		}

		override protected function buildUpState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				//背景
				graphics.beginFill(0, 0);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
				
				graphics.lineStyle(3, 0xff0000);
				graphics.moveTo(10, 13);
				graphics.lineTo(16, 13);
			}
			return sp;
		}

		
		//---------------------------
		//---------------------------
		//---------------------------

		protected function buildOverState2() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				//背景
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
				
				graphics.lineStyle(3, 0xff0000);
				graphics.drawRect(8, 8, 7, 7);
			}
			return sp;
		}

		protected function buildDownState2() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				//背景
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
				
				
				graphics.lineStyle(3, 0xffffff);
				graphics.drawRect(8, 8, 7, 7);
			}
			return sp;
		}

		protected function buildUpState2() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				//背景
				graphics.beginFill(0, 0);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
				
				graphics.lineStyle(3, 0xff0000);
				graphics.drawRect(8, 8, 7, 7);
			}
			return sp;
		}

		//-----------------------------
		//-----------------------------
		private var _normalMode : Boolean = true;

		public function get normalMode() : Boolean {
			return _normalMode;
		}

		//切换按钮状态
		private function onToggleMode(evt : MouseEvent) : void {
			_normalMode = !_normalMode;
			
			updateStates();
		}

		private function updateStates() : void {
			if(_normalMode) {
				this.downState = buildDownState();
				this.upState = buildUpState();
				this.overState = buildOverState();
				this.hitTestState = buildHitState();
			
			
				_tip = InspectorLanguageManager.getStr('MinimizePanel');
			} else {
				this.downState = buildDownState2();
				this.upState = buildUpState2();
				this.overState = buildOverState2();
				this.hitTestState = buildHitState();
			
				_tip = InspectorLanguageManager.getStr('RestorePanel');
			}
		}

		//
		//
		override public function set enabled(val : Boolean) : void {
			if(!val) {
				this.downState = this.upState = this.overState = this.hitTestState = buildUnenabledState();
			} else {
				this.updateStates();
			}
			super.enabled = val;
		}
	}
}
