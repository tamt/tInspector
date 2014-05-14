package transform3d.controls.scale 
{
	import flash.geom.Point;
	import transform3d.controls.DimentionControl;
	import transform3d.controls.Style;
	
	/**
	 * 
	 * @author tamt
	 */
	public class ScaleControl extends DimentionControl
	{
		private var _size:Number = 10;
		private var _distanceX:Number = 0;
		private var _distanceY:Number = 0;
		
		private var _globalStartDragPoint:Point;
		
		public function ScaleControl() 
		{
			super();
			_style = new Style(0xffffff, 1, 0x000000, 1, 2);
		}
		
		/**
		 * draw the control graphics
		 */
		protected override function draw():void {
			super.draw();
			
			_sp.graphics3D.clear();
			_sp.graphics3D.lineStyle(_style.borderThickness, _style.borderColor, _style.borderAlpha);
			_sp.graphics3D.beginFill(_style.fillColor, _style.fillAlpha);
			_sp.graphics3D.drawRect(-_size/2, -_size/2, _size, _size);
			//_sp.graphics3D.drawCircle(0, 0, _size / 2);
			_sp.graphics3D.endFill();
			
		}
		
		/**
		 * when user start drag the registration point
		 */
		protected override function onStartDrag():void {
			super.onStartDrag();
			
			_globalStartDragPoint = _globalMousePoint.clone();
		}
		
		/**
		 * when user draging the registration point
		 */
		protected override function onDraging():void {
			super.onDraging();
			
			_distanceX = stage.mouseX - _globalStartDragPoint.x;
			_distanceY = stage.mouseY - _globalStartDragPoint.y;
		}
		
		/**
		 * when user stop drag the registration point
		 */
		protected override function onStopDrag():void {
			super.onStopDrag();
		}
		
		public function get size():Number { return _size; }
		
		public function set size(value:Number):void 
		{
			_size = value;
			
			if (_inited) {
				this.clear();
				this.draw();
			}
		}
		
		public function get distanceX():Number { return _distanceX; }
		
		public function get distanceY():Number { return _distanceY; }
		
	}

}