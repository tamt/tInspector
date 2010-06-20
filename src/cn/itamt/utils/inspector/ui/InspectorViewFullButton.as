package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.ui.InspectorViewOperationButton;

	import flash.display.Shape;
	import flash.events.MouseEvent;	

	/**
	 * 查看完整属性按钮
	 * @author itamt@qq.com
	 */
	public class InspectorViewFullButton extends InspectorViewOperationButton {

		public function InspectorViewFullButton() {
			super();
			
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
				
				graphics.lineStyle(3, 0x99cc00);
				graphics.moveTo(6, 5);
				graphics.lineTo(15, 5);
				graphics.moveTo(6, 10);
				graphics.lineTo(15, 10);
				graphics.moveTo(6, 15);
				graphics.lineTo(15, 15);
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
				graphics.moveTo(6, 5);
				graphics.lineTo(15, 5);
				graphics.moveTo(6, 10);
				graphics.lineTo(15, 10);
				graphics.moveTo(6, 15);
				graphics.lineTo(15, 15);
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
				
				graphics.lineStyle(3, 0xffffff);
				graphics.moveTo(6, 5);
				graphics.lineTo(15, 5);
				graphics.moveTo(6, 10);
				graphics.lineTo(15, 10);
				graphics.moveTo(6, 15);
				graphics.lineTo(15, 15);
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
				
				graphics.lineStyle(3, 0x99cc00);
				graphics.moveTo(6, 6);
				graphics.lineTo(15, 6);
				graphics.moveTo(6, 13);
				graphics.lineTo(15, 13);
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
				graphics.moveTo(6, 6);
				graphics.lineTo(15, 6);
				graphics.moveTo(6, 13);
				graphics.lineTo(15, 13);
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
				
				graphics.lineStyle(3, 0xffffff);
				graphics.moveTo(6, 6);
				graphics.lineTo(15, 6);
				graphics.moveTo(6, 13);
				graphics.lineTo(15, 13);
			}
			return sp;
		}

		//-----------------------------
		//-----------------------------
		protected var _normalMode : Boolean = true;

		public function get normalMode() : Boolean {
			return _normalMode;
		}

		//切换按钮状态
		private function onToggleMode(evt : MouseEvent) : void {
			_normalMode = !_normalMode;
			
			updateStates();
		}

		protected function updateStates() : void {
			if(_normalMode) {
				this.downState = buildDownState();
				this.upState = buildUpState();
				this.overState = buildOverState();
				this.hitTestState = buildHitState();
			
				_tip = InspectorLanguageManager.getStr('ViewFullProperties');
			} else {
				this.downState = buildDownState2();
				this.upState = buildUpState2();
				this.overState = buildOverState2();
				this.hitTestState = buildHitState();
			
				_tip = InspectorLanguageManager.getStr('ViewMarkedProperties');
			}
		}

		//
		//
		override public function set enabled(val : Boolean) : void {
			super.enabled = val;
			if(!val) {
				this.downState = this.upState = this.overState = this.hitTestState = buildUnenabledState();
			} else {
				this.updateStates();
			}
		}

		override protected function buildUnenabledState() : Shape {
			var sp : Shape = new Shape();
			if(_normalMode) {
				with(sp) {
					//背景
					graphics.beginFill(0, 0);
					graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
					graphics.endFill();
				
					graphics.lineStyle(3, 0x000000);
					graphics.moveTo(6, 5);
					graphics.lineTo(15, 5);
					graphics.moveTo(6, 10);
					graphics.lineTo(15, 10);
					graphics.moveTo(6, 15);
					graphics.lineTo(15, 15);
				}
			} else {
				with(sp) {
					//背景
					graphics.beginFill(0, 0);
					graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
					graphics.endFill();
				
					graphics.lineStyle(3, 0x000000);
					graphics.moveTo(6, 6);
					graphics.lineTo(15, 6);
					graphics.moveTo(6, 13);
					graphics.lineTo(15, 13);
				}
			}
			return sp;
		}
	}
}
