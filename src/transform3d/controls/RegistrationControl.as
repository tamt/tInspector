package transform3d.controls 
{
	import flash.display.Shape;
	import flash.events.Event;
	/**
	 * RegistrationControl, registration point control of TranslationTool/RotationTool
	 * @author tamt
	 */
	public class RegistrationControl extends DimentionControl
	{
		//radius of circle of control
		private var _radius:Number = 5;
		
		/**
		 * x offset of drag point from registration
		 */
		private var _dragOffsetX:Number = 0;
		public function get dragOffsetX():Number {
			return _dragOffsetX;
		}
		
		/**
		 * y offset of drag point from registration
		 */
		private var _dragOffsetY:Number = 0;
		public function get dragOffsetY():Number {
			return _dragOffsetY;
		}
		
		public function RegistrationControl() 
		{
			super();
			_style.fillColor = 0xffffff;
			_style.fillAlpha = 1;
		}
		
		/**
		 * draw control graphics
		 */
		protected override function draw():void {
			_sp.graphics3D.clear();
			_sp.graphics3D.lineStyle(_style.borderThickness, _style.borderColor, _style.borderAlpha);
			_sp.graphics3D.beginFill(_style.fillColor, _style.fillAlpha);
			_sp.graphics3D.drawCircle(0, 0, _radius);
			_sp.graphics3D.endFill();
		}
		
		/**
		 * when mouse start drag control
		 */
		protected override function onStartDrag():void {
			super.onStartDrag();
			
			//store the offset of drag point from registration
			_dragOffsetX = this.mouseX;
			_dragOffsetY = this.mouseY;
		}
		
		/**
		 * when mouse stop drag control
		 */
		protected override function onStopDrag():void {
			super.onStopDrag();
		}	
	}
}