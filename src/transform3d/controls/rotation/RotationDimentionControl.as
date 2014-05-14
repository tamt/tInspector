package transform3d.controls.rotation 
{
	import transform3d.controls.DimentionControl;
	import transform3d.controls.Style;
	import transform3d.consts.Transform3DMode;
	import transform3d.util.Util;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.filters.GradientGlowFilter;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import net.badimon.five3D.display.Shape3D;
	import net.badimon.five3D.utils.InternalUtils;
	
	/**
	 * base Class of x, y, z rotation controls
	 * @author tamt
	 */
	public class RotationDimentionControl extends DimentionControl
	{	
		//show dimention line
		public var showDimenLine:Boolean;
		
		//radius of control's circle graphics
		protected var _radius:Number = 100;
		public function get radius():Number {
			return _radius;
		}
		//radius of control's circle graphics
		public function set radius(val:Number):void{
			_radius = val;
			if (_inited) {
				//redraw the control's graphics if control inited(displayed)
				this.draw();
			}
		}
		
		//the angel when start drag
		protected var _startAngle:Number;
		//the angel in 3D coordinate when start drag
		protected var _startAngle3D:Number;
		//the registration point in Stage coordinate.
		protected var _globalRegPoint:Point;
		
		//rotation in degree
		public function get degree():Number {
			return _value;
		}
		
		/**
		 * set the style of this control
		 */
		public override function set style(val:Style):void{
			_style = val;
			_wedgeStyle = new Style(_style.fillColor, _style.fillAlpha);
			if (_inited) this.draw();
		}
		
		//style of wedge
		protected var _wedgeStyle:Style;
		//public function get wedgeStyle():Style {
			//return _wedgeStyle;
		//}
		//public function set wedgeStyle(style:Style):void {
			//_wedgeStyle = style;
			//if (_inited) this.draw();
		//}
		
		
		/**
		 * constructor
		 */
		public function RotationDimentionControl() 
		{
			super();
			_style.borderThickness = 1.5;
			_wedgeStyle = new Style(_style.fillColor, _style.fillAlpha);
		}
		
		override protected function onAdded(evt:Event = null):void {
			_wedgeStyle = new Style(_style.fillColor, _style.fillAlpha);
			super.onAdded(evt);
		}
		
		/**
		 * draw control graphics
		 */
		protected override function draw():void {
			if(showDimenLine){
				graphics3D.lineStyle(_style.borderThickness, _style.borderColor);
				graphics3D.moveToSpace(0, 0, 0);
				graphics3D.lineToSpace(_radius, 0, 0);
				graphics3D.lineStyle(_style.borderThickness, 0x00ff00);
				graphics3D.moveToSpace(0, 0, 0);
				graphics3D.lineToSpace(0, _radius, 0);
				graphics3D.lineStyle(_style.borderThickness, 0x0000ff);
				graphics3D.moveToSpace(0, 0, 0);
				graphics3D.lineToSpace(0, 0, _radius);
			}
		}
		
		/**
		 * when user start drag the control
		 */
		override protected function onStartDrag():void {
			super.onStartDrag();
			
			var regVector:Vector3D = this.concatenatedMatrix.position;
			_globalRegPoint = new Point(regVector.x, regVector.y);
			_startDragPoint = new Point(InternalUtils.getScene(this).mouseX - _globalRegPoint.x, InternalUtils.getScene(this).mouseY - _globalRegPoint.y);
			
			_startAngle = Math.atan2(_startDragPoint.y, _startDragPoint.x)*Util.RADIAN;
			_startAngle3D = Math.atan2(_startDragPoint3D.y, _startDragPoint3D.x)*Util.RADIAN;
		}
		
		/**
		 * when mouse draging the control
		 */
		override protected function onDraging():void {
			//update mouse distance to global registration point
			_mousePoint.x = InternalUtils.getScene(this).mouseX - _globalRegPoint.x
			_mousePoint.y = InternalUtils.getScene(this).mouseY - _globalRegPoint.y;
			
			//caculate the value of this control.
			_value = Math.atan2(_mousePoint.y, _mousePoint.x) * Util.RADIAN - _startAngle;
			var showValueNum:int = int(_value);
			if (Math.abs(showValueNum) > 180) {
				//keep showing degree value < 180
				if(showValueNum>0){
					showValueNum = showValueNum - 360;
				}else {
					showValueNum = showValueNum + 360;
				}
			}
			
			//update display the value degree, if showValue is true 
			if (showValue) {
				if (!_textfield.visible)_textfield.visible = true;
				_textfield.text = Math.round(showValueNum).toString();
				var pos:Point = Point.polar(20, (_startAngle + showValueNum / 2)/Util.RADIAN);
				_textfield.x = pos.x - _textfield.width / 2;
				_textfield.y = pos.y - _textfield.height / 2;
			}
			
			//draw circle graphics
			this.graphics3D.clear();
			this.graphics3D.lineStyle(_wedgeStyle.borderThickness, _wedgeStyle.borderColor, _wedgeStyle.borderAlpha);
			//this.graphics3D.beginFill(_wedgeStyle.fillColor, _wedgeStyle.fillAlpha*.3);
			this.graphics3D.drawCircle(0, 0, _radius);
			this.graphics3D.endFill();
			
			
			//draw wedge graphics
			this.graphics3D.beginFill(_wedgeStyle.fillColor, _wedgeStyle.fillAlpha);
			Util.drawWedge3D(this.graphics3D, 0, 0, this._radius, showValueNum, _startAngle3D);
			this.graphics3D.endFill();
		}
		
		/**
		 * called when mouse stop draging
		 */
		override protected  function onStopDrag():void {
			super.onStopDrag();
			//clear control graphics
			this.graphics3D.clear();
			//this.draw();
		}
		
		/**
		 * dispose this control, release memory
		 */
		override public function dispose():void {
			_wedgeStyle = null;
			
			super.dispose();
		}
		
	}

}
