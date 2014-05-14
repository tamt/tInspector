package transform3d.controls.rotation 
{
	import flash.display.Shape;
	import flash.events.Event;
	import net.badimon.five3D.utils.InternalUtils;
	/**
	 * Perspective rotation control, will transform target's rotationX and rotationY value.
	 * @author tamt
	 */
	public class PRotationControl extends RotationDimentionControl
	{
		//get control degree value in x dimention
		private var _degreeX:Number;
		public function get degreeX():Number {
			return _degreeX;
		}
		
		//get control degree value in y dimention
		private var _degreeY:Number;
		public function get degreeY():Number {
			return _degreeY;
		}
		
		//-----------------------------------
		//-----------------------------------
		//-----------------------------------
		/**
		 * Perspective rotation control, will transform target's rotationX and rotationY value.
		 */
		public function PRotationControl() 
		{
			super();
			//set the radius of the circle graphics
			this._radius = 60;
			//set the border color of the circle graphics
			this._style.borderColor = 0xff6600;
		}
		
		/**
		 * draw control graphics
		 */
		protected override function draw():void {
			_sp.graphics3D.clear();
			_sp.graphics3D.lineStyle(_style.borderThickness, _style.borderColor);
			_sp.graphics3D.drawCircle(0, 0, _radius);
			_sp.graphics3D.lineStyle(4, _style.borderColor, 0);
			_sp.graphics3D.drawCircle(0, 0, _radius);
		}
		
		/**
		 * called when draging this control
		 */
		override protected function onDraging():void {
			//caculate the mouse distance to registration
			_mousePoint.x = InternalUtils.getScene(this).mouseX - _globalRegPoint.x
			_mousePoint.y = InternalUtils.getScene(this).mouseY - _globalRegPoint.y;
			
			//caculate the degree value in x/y dimention
			_degreeY = (_mousePoint.x - _startDragPoint.x)*1.5;
			_degreeX = (_mousePoint.y - _startDragPoint.y)*1.5;
		}
		
		/**
		 * called when stop draging
		 */
		protected override function onStopDrag():void {
			//reset degree value
			_degreeX = _degreeY = 0;
		}
		
	}

}
