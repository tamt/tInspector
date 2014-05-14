package transform3d 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import transform3d.consts.Transform3DMode;
	import transform3d.controls.DimentionControl;
	import transform3d.controls.scale.ScaleControl;
	import transform3d.controls.Style;
	import transform3d.controls.TransformControl;
	import transform3d.util.Util;
	
	/**
	 * scale transform tool
	 * @author tamt
	 */
	public class ScaleTool extends TransformControl
	{
		private var _cursor:DisplayObject;
		public function get cursor():DisplayObject { return _cursor; }
		
		public function set cursor(value:DisplayObject):void 
		{
			_cursor = value;
			if (_inited) {
				for each(var ctrl:DimentionControl in _ctrls) {
					if (ctrl is ScaleControl) ctrl.setCursor(_cursor);
				}
			}
		}
		
		private var _style:Style = new Style(0xffffff, 1, 0x000000, 1, 2);
		
		public function get style():Style 
		{
			return _style;
		}
		
		public function set style(value:Style):void 
		{
			_style = value;
			if (_inited) {				
				for each(var ctrl:DimentionControl in _ctrls) {
					if (ctrl is ScaleControl) ctrl.style = _style;
				}
			}
		}
		
		private var _size:Number = 10;
		
		public function get size():Number 
		{
			return _size;
		}
		
		public function set size(value:Number):void 
		{
			_size = value;
			if (_inited) {				
				for each(var ctrl:DimentionControl in _ctrls) {
					if (ctrl is ScaleControl) {
						(ctrl as ScaleControl).size = _size;
					}
				}
			}
		}
		
		
		private var _tl:ScaleControl;
		private var _tc:ScaleControl;
		private var _tr:ScaleControl;
		private var _l:ScaleControl;
		private var _r:ScaleControl;
		private var _bl:ScaleControl;
		private var _bc:ScaleControl;
		private var _br:ScaleControl;
		
		private var _originRect:Rectangle;
		private var _rotateCtrls:Boolean = true;
		
		protected override function onAdded(evt:Event = null):void {
			_tl = new ScaleControl;
			_tc = new ScaleControl;
			_tr = new ScaleControl;
			_l = new ScaleControl;
			_r = new ScaleControl;
			_bl = new ScaleControl;
			_bc = new ScaleControl;
			_br = new ScaleControl;
			
			_ctrls = [_tl, _tc, _tr, _l, _r, _bl, _bc, _br];
			
			for each(var ctrl:DimentionControl in _ctrls) {
				_root.addChild(ctrl);
				if (ctrl is ScaleControl) {
					ctrl.setCursor(_cursor);
					ctrl.style = _style;
					(ctrl as ScaleControl).size = _size;
				}
			}
			
			super.onAdded(evt);
		}
		
		protected override function onRemoved(evt:Event = null):void {
			for each(var ctrl:DimentionControl in _ctrls) {
				if (ctrl is ScaleControl) _root.removeChild(ctrl);
			}
			
			_tl = null;
			_tc = null;
			_tr = null;
			_l = null;
			_r = null;
			_bl = null;
			_bc = null;
			_br = null;
			
			super.onRemoved(evt);
		}
		
		protected override function onActiveControl(ctrl:DimentionControl):void {
			super.onActiveControl(ctrl);
			
			if (_target) {
				_originRect = this.getBounds(_root);
			}
		}
		
		protected override function onChangeControlValue(ctrl:DimentionControl):void {
			var scaleCtrl:ScaleControl = ctrl as ScaleControl;
			var directionX:int;
			var directionY:int;
			var xvalue:Number;
			var yvalue:Number;
			
			if (mode == Transform3DMode.GLOBAL) {
				if (_originRect == null) return;
				
				var mx:Matrix3D = this._originConcatenatedMX.clone();
				var reg:Vector3D = mx.transformVector(_innerReg);
				mx.appendTranslation( -reg.x, -reg.y, -reg.z);
				
				directionX = 1;
				directionY = 1;
				switch(scaleCtrl) {
					case _tc:
						directionY = -1;
						directionX = 0;
						break;
					case _tl:
						directionY = -1;
						directionX = -1;
						break;
					case _tr:
						directionY = -1;
						break;
					case _l:
						directionY = 0;
						directionX = -1;
						break;
					case _r:
						directionY = 0;
						break;
					case _bc:
						directionX = 0;
						break;
					case _bl:
						directionX = -1;
						break;
					case _br:
						break;
				}
				
				xvalue = directionX * scaleCtrl.distanceX / _originRect.width;
				yvalue = directionY * scaleCtrl.distanceY / _originRect.height;
				
				if (xvalue == -1) xvalue = -0.999;
				if (yvalue == -1) yvalue = -0.999;
				mx.appendScale(1 + xvalue, 1 + yvalue, 1);
				mx.appendTranslation(reg.x, reg.y, reg.z);
				
				var parentMX:Matrix3D = _originParentConcatenatedMX.clone();
				parentMX.invert();
				mx.append(parentMX);
				_targetMX = mx.clone();
			}else if (mode == Transform3DMode.INTERNAL) {				
				directionX = 1;
				directionY = 1;
				switch(scaleCtrl) {
					case _tc:
						directionY = -1;
						directionX = 0;
						break;
					case _tl:
						directionY = -1;
						directionX = -1;
						break;
					case _tr:
						directionY = -1;
						break;
					case _l:
						directionY = 0;
						directionX = -1;
						break;
					case _r:
						directionY = 0;
						break;
					case _bc:
						directionX = 0;
						break;
					case _bl:
						directionX = -1;
						break;
					case _br:
						break;
				}
				
				xvalue = directionX * scaleCtrl.distanceX / _originRect.width;
				yvalue = directionY * scaleCtrl.distanceY / _originRect.height;
				
				if (xvalue == -1) xvalue = -0.999;
				if (yvalue == -1) yvalue = -0.999;
				_targetMX.prependTranslation(_innerReg.x, _innerReg.y, _innerReg.z);
				_targetMX.prependScale(1 + xvalue, 1 + yvalue, 1);
				_targetMX.prependTranslation( -_innerReg.x, -_innerReg.y, -_innerReg.z);
			}
		}
		
		
		protected override function updateControls(deltaMX:Matrix3D = null):void {
			super.updateControls(deltaMX);
			
			var rect:Rectangle;
			if (mode == Transform3DMode.GLOBAL) {
				rect = this.target.getBounds(this._root);
				
				_tl.x = rect.left;
				_tl.y = rect.top;
				_tc.x = rect.left / 2 + rect.right / 2;
				_tc.y = rect.top;
				_tr.x = rect.right;
				_tr.y = rect.top;
				
				_l.x = rect.left;
				_l.y = rect.top / 2 + rect.bottom / 2;
				_r.x = rect.right;
				_r.y = rect.top / 2 + rect.bottom / 2;
				
				_bl.x = rect.left;
				_bl.y = rect.bottom;
				_bc.x = rect.left / 2 + rect.right / 2;
				_bc.y = rect.bottom;
				_br.x = rect.right;
				_br.y = rect.bottom;
			}else if (mode == Transform3DMode.INTERNAL) {
				rect = this.target.getBounds(this.target);
				
				var tl:Point = Util.localToTarget(target, rect.topLeft, _root);
				var tc:Point = Util.localToTarget(target, new Point(rect.left/2 + rect.right/2, rect.top), _root);
				var tr:Point = Util.localToTarget(target, new Point(rect.right, rect.top), _root);
				
				var l:Point = Util.localToTarget(target, new Point(rect.left, rect.top / 2 + rect.bottom / 2), _root);
				var r:Point = Util.localToTarget(target, new Point(rect.right, rect.top / 2 + rect.bottom / 2), _root);
				
				var bl:Point = Util.localToTarget(target, new Point(rect.left, rect.bottom), _root);
				var bc:Point = Util.localToTarget(target, new Point(rect.left / 2 + rect.right / 2, rect.bottom), _root);
				var br:Point = Util.localToTarget(target, rect.bottomRight, _root);
		
				_tl.x = tl.x;
				_tl.y = tl.y;
				_tc.x = tc.x;
				_tc.y = tc.y;
				_tr.x = tr.x;
				_tr.y = tr.y;
				
				_l.x = l.x;
				_l.y = l.y;
				_r.x = r.x;
				_r.y = r.y;
				
				_bl.x = bl.x;
				_bl.y = bl.y;
				_bc.x = bc.x;
				_bc.y = bc.y;
				_br.x = br.x;
				_br.y = br.y;
				
				_root.graphics.clear();
				_root.graphics.lineStyle(1, 0);
				_root.graphics.moveTo(_tl.x, _tl.y);
				_root.graphics.lineTo(_tr.x, _tr.y);
				_root.graphics.lineTo(_br.x, _br.y);
				_root.graphics.lineTo(_bl.x, _bl.y);
				_root.graphics.lineTo(_tl.x, _tl.y);
				
				if(_rotateCtrls){
					_tl.rotationZ = projectRotationX(_tl.y);
					_tc.rotationZ = projectRotationX(_tc.y);
					_tr.rotationZ = projectRotationX(_tr.y);
					_l.rotationZ = projectRotationX(_l.y);
					_r.rotationZ = projectRotationX(_r.y);
					_bc.rotationZ = projectRotationX(_bc.y);
					_bl.rotationZ = projectRotationX(_bl.y);
					_br.rotationZ = projectRotationX(_br.y);
				}
			}
		}
		
		override public function set mode(val:uint):void {
			if (Transform3DMode.isInvalidMode(val)) return;
			super.mode = val;
			
			_root.graphics.clear();
		}	
		
		override protected function clear():void {
			super.clear();
			
			_root.graphics.clear();
		}
		
		public function projectRotationX(val:Number):Number {
			var mx:Matrix3D = _targetMX.clone();
			//mx.prependRotation(-90, Vector3D.Z_AXIS);
			
			var vt:Vector3D = new Vector3D(val, 0, 0);
			vt = mx.deltaTransformVector(vt);
			var a:Number = Math.atan2(vt.y, vt.x);
			
			return a * Util.RADIAN;
		}
	}

}