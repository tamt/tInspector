package transform3d.controls.translation 
{
	import transform3d.controls.DimentionControl;
	import transform3d.util.Util;
	import flash.display.Sprite;
	import flash.geom.Point;
	import net.badimon.five3D.utils.InternalUtils;
	
	/**
	 * base Class of x, y, z translation control.
	 * @author tamt
	 */
	public class TranslationDimentionControl extends DimentionControl
	{
		//arrow size of control graphics
		protected var _arrowSize:Number = 10;
		/**
		 * arrow length of control graphics
		 */
		protected var _length:Number = 80;
		public function get length():Number {
			return _length;
		}
		public function set length(val:Number):void {
			_length = val;
		}
		
		/**
		 * translate value of control
		 */
		public function get distance():Number {
			return _value;
		}
		
		//start drag point relative to global coordinate
		protected var _globalStartDragPoint:Point;
		
		public function TranslationDimentionControl() 
		{
			super();
			
			_style.borderThickness = 2;
		}
		
		/**
		 * when mouse start drag control
		 */
		protected override function onStartDrag():void {
			super.onStartDrag();
			
			var root:Sprite = InternalUtils.getScene(this);
			_globalStartDragPoint = new Point(root.mouseX, root.mouseY);
		}
		
		/**
		 * when mouse draging control
		 */
		override protected function onDraging():void {
			var root:Sprite = InternalUtils.getScene(this);
			_globalMousePoint = new Point(root.mouseX, root.mouseY);
			
			//caculate translate value
			var pt:Point = _globalMousePoint.subtract(_globalStartDragPoint);
			var b:Number = Math.atan2(pt.y, pt.x);
			var a:Number = Util.projectRotationX(this.matrix) / Util.RADIAN;
			a -= b;
			_value = Math.cos(a)*(Math.sqrt(pt.x * pt.x + pt.y * pt.y));
			
			//update display value textfield if showValue is true.
			if (showValue) {
				if (!_textfield.visible)_textfield.visible = true;
				_textfield.text = Math.round(_value).toString();
				var pos:Point = Point.interpolate(_globalStartDragPoint, _mousePoint, .5);
				_textfield.x = pos.x - _textfield.width / 2;
				_textfield.y = pos.y - _textfield.height / 2;
			}
		}
		
	}

}
