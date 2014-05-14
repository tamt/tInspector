package transform3d.controls.translation 
{
	import transform3d.consts.Transform3DMode;
	import flash.geom.Point;
	import transform3d.util.Util;
	import net.badimon.five3D.display.Scene3D;
	import net.badimon.five3D.utils.InternalUtils;
	/**
	 * y control of translation tool
	 * @author tamt
	 */
	public class YTranslationControl extends TranslationDimentionControl
	{
		public function YTranslationControl() 
		{
			super();
			_style.borderColor = 0x00ff00;
		}
		
		/**
		 * draw control graphics 
		 */
		protected override function draw():void {
			super.draw();
			
			_sp.graphics3D.clear();
			
			if(_mode == Transform3DMode.GLOBAL){
				_sp.graphics3D.lineStyle(_style.borderThickness, _style.borderColor);
				_sp.graphics3D.moveTo(0, 0);
				_sp.graphics3D.lineTo(0, this._length);
				_sp.graphics3D.lineStyle(4, _style.borderColor, 0);
				_sp.graphics3D.moveTo(0, 0);
				_sp.graphics3D.lineTo(0, this._length);
			}else if (_mode == Transform3DMode.INTERNAL) {
				_sp.graphics3D.lineStyle(_style.borderThickness, _style.borderColor);
				_sp.graphics3D.moveTo(0, 0);
				_sp.graphics3D.lineTo(0, this._length);
				_sp.graphics3D.lineStyle(4, _style.borderColor, 0);
				_sp.graphics3D.moveTo(0, 0);
				_sp.graphics3D.lineTo(0, this._length);
			}
			
		}
		
		/**
		 * when mouse draging mouse
		 */
		override protected function onDraging():void {
			var root:Scene3D = InternalUtils.getScene(this);
			_globalMousePoint = new Point(root.mouseX, root.mouseY);
			
			//caculate translate valuf of control
			var pt:Point = _globalMousePoint.subtract(_globalStartDragPoint);
			var b:Number = Math.atan2(pt.y, pt.x);
			var a:Number = Util.projectRotationY(this.matrix) / Util.RADIAN;
			a -= b;
			_value = Math.cos(a)*(Math.sqrt(pt.x * pt.x + pt.y * pt.y));
			
			//update textfield display value if showValue is true
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