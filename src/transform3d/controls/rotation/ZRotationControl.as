package transform3d.controls.rotation 
{
	import transform3d.controls.Style;
	import transform3d.consts.Transform3DMode;
	import flash.display.Shape;
	import flash.events.Event;
	/**
	 * z rotation control, used in RotationTool for z rotation interaction
	 * @author tamt
	 */
	public class ZRotationControl extends RotationDimentionControl
	{
		
		public function ZRotationControl() 
		{
			super();
			style = new Style(0x0000ff, .7, 0x0000ff, .9,  1.5);
		}
		
		/**
		 * draw control graphics
		 */
		protected override function draw():void {
			super.draw();
			
			_sp.graphics3D.clear();
			
			_sp.graphics3D.lineStyle(4, _style.borderColor, 0);
			_sp.graphics3D.drawCircle(0, 0, _radius);
			_sp.graphics3D.lineStyle(_style.borderThickness, _style.borderColor);
			_sp.graphics3D.drawCircle(0, 0, _radius);
		}
		
		/**
		 * when mouse start drag control
		 */
		override protected function onStartDrag():void {			
			super.onStartDrag();
			
			if (_mode == Transform3DMode.INTERNAL) {
				_startAngle3D = this.rotationZ + 90;
			}
		}
	}

}
