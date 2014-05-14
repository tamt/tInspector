package transform3d.controls.translation 
{
	import transform3d.consts.Transform3DMode;
	import flash.geom.Point;
	import transform3d.util.Util;
	import net.badimon.five3D.display.Scene3D;
	import net.badimon.five3D.utils.InternalUtils;
	/**
	 * z control of translation tool
	 * @author tamt
	 */
	public class ZTranslationControl extends TranslationDimentionControl
	{
		
		public function ZTranslationControl() 
		{
			super();
			_style.fillColor = 0x0000ff;
			_style.fillAlpha = 1;
			_style.borderColor = 0x0000ff;
		}
		
		/**
		 * draw control graphics
		 */
		protected override function draw():void {
			super.draw();
			
			_sp.graphics3D.clear();
			
			if (_mode == Transform3DMode.GLOBAL) {
				//_sp.graphics3D.beginFill(_style.fillColor, _style.fillAlpha);
				_sp.graphics3D.beginFill(_style.borderColor, _style.borderAlpha);
				_sp.graphics3D.drawCircle(0, 0, 30);
				_sp.graphics3D.endFill();
			}else if (_mode == Transform3DMode.INTERNAL) {
				_sp.graphics3D.lineStyle(_style.borderThickness, _style.borderColor);
				_sp.graphics3D.moveToSpace(0, 0, 0);
				_sp.graphics3D.lineToSpace(0, 0, _length);
				_sp.graphics3D.lineStyle(4, _style.borderColor, 0);
				_sp.graphics3D.moveToSpace(0, 0, 0);
				_sp.graphics3D.lineToSpace(0, 0, _length);
			}
			
		}
		
		/**
		 * when mouse draging conrol
		 */
		override protected function onDraging():void {
			var root:Scene3D = InternalUtils.getScene(this);
			_globalMousePoint = new Point(root.mouseX, root.mouseY);
			
			//caculate translate value
			var pt:Point = _globalMousePoint.subtract(_globalStartDragPoint);
			var b:Number = Math.atan2(pt.y, pt.x);
			var a:Number = Util.projectRotationZ(this.matrix) / Util.RADIAN;
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