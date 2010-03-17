package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.inspector.ui.InspectorViewOperationButton;

	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;	

	/**
	 * 调整形状和大小的点按钮.
	 * @author itamt@qq.com
	 */
	public class LiveTransformPointBtn extends InspectorViewOperationButton {
		private var downHandler : Function;
		private var upHandler : Function;
		private var dragHandler : Function;

		public var lastMousePt : Point;

		public function LiveTransformPointBtn(onMouseDown : Function = null, onMouseUp : Function = null, onDrag : Function = null) {
			super();
			
			downHandler = onMouseDown;
			upHandler = onMouseUp;
			dragHandler = onDrag;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}

		private var inited : Boolean;

		private function onAdded(evt : Event) : void {
			if(inited)return;
			
			inited = true;
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);			this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		private function onRemoved(evt : Event) : void {
			inited = false;
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		private function onMouseDown(evt : MouseEvent) : void {
			lastMousePt = new Point(evt.stageX, evt.stageY);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			if(this.downHandler)this.downHandler.call(null, this);
		}

		private function onMouseUp(evt : MouseEvent) : void {
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			if(this.downHandler)this.upHandler.call(null, this);
		}

		private function onMouseMove(evt : MouseEvent) : void {
			if(this.dragHandler)this.dragHandler.call(null, this);
			
			lastMousePt.x = evt.stageX;
			lastMousePt.y = evt.stageY;
		}

		override protected function buildDownState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.lineStyle(1, 0xffffff);
			g.beginFill(0xff0000, 1);
			g.drawRect(-4, -4, 8, 8);
			g.endFill();
			return sp;
		}

		override protected function buildUpState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.lineStyle(1, 0xffffff);
			g.beginFill(0, 1);
			g.drawRect(-4, -4, 8, 8);
			g.endFill();
			return sp;
		}

		override protected function buildOverState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.lineStyle(1, 0);
			g.beginFill(0x99cc00, 1);
			g.drawRect(-4, -4, 8, 8);
			g.endFill();
			return sp;
		}

		override protected function buildHitState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.lineStyle(1, 0xffffff);
			g.beginFill(0, 1);
			g.drawRect(-4, -4, 8, 8);
			g.endFill();
			return sp;
		}

		override protected function buildUnenabledState() : Shape {
			var sp : Shape = new Shape();
			var g : Graphics = sp.graphics;
			g.lineStyle(1, 0xffffff);
			g.beginFill(0, 1);
			g.drawRect(-4, -4, 8, 8);
			g.endFill();
			return sp;
		}
	}
}
