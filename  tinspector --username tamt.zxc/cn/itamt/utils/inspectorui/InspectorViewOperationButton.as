package cn.itamt.utils.inspectorui {
	import flash.display.Shape;
	import flash.display.SimpleButton;	

	/**
	 * @author tamt
	 */
	class InspectorViewOperationButton extends SimpleButton {
		public function InspectorViewOperationButton() : void {
			this.downState = buildDownState();
			this.upState = buildUpState();
			this.overState = buildOverState();
			this.hitTestState = buildHitState();
		} 

		protected function buildDownState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
			}
			return sp;
		}

		protected function buildUpState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
			}
			return sp;
		}

		protected function buildOverState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
			}
			return sp;
		}

		protected function buildHitState() : Shape {
			var sp : Shape = new Shape();
			with(sp) {
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
			}
			return sp;
		}
	}
}
