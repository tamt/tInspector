package transform3d
{
	import transform3d.controls.*;
	import transform3d.controls.rotation.*;
	import transform3d.cursors.*;
	import transform3d.util.Util;
	import transform3d.consts.Transform3DMode;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.*;
	import net.badimon.five3D.display.Scene3D;
	
	/**
	 * RotationTool component of Transform3DTool
	 * @author tamt
	 */
	public class RotationTool extends TransformControl
	{
		protected var _radius:Number = 50;
		public function get radius():Number {
			return _radius;
		}
		public function set radius(val:Number):void {
			_radius = val;
			if(_inited){
				_xCtrl.radius = _yCtrl.radius = _zCtrl.radius = _radius;
				_pCtrl.radius = _radius + 10;
				
				if (showOutCircle && target && (_mode == Transform3DMode.INTERNAL)) this.drawOutCircle();
				
				this.buildControlMask(_xMask);
				this.buildControlMask(_yMask);
				this.buildControlMask(_zMask);
			}
		}
		
		//---------------------------
		//controls
		//---------------------------
		protected var _xCtrl:XRotationControl;
		public function get xControl():XRotationControl {
			return _xCtrl;
		}
		protected var _yCtrl:YRotationControl;
		public function get yControl():YRotationControl {
			return _yCtrl;
		}
		protected var _zCtrl:ZRotationControl;
		public function get zControl():ZRotationControl {
			return _zCtrl;
		}
		protected var _pCtrl:PRotationControl;
		public function get pControl():PRotationControl {
			return _pCtrl;
		}
		
		//---------------------------
		//cursors
		//---------------------------
		//xctrl cursor
		protected var _xCursor:DisplayObject;
		public function get xCursor():DisplayObject {
			return _xCursor;
		}
		public function set xCursor(dp:DisplayObject):void {
			_xCursor = dp;
			if (_inited) {
				_xCtrl.setCursor(_xCursor);
			}
		}
		
		//yctrl cursor
		protected var _yCursor:DisplayObject;
		public function get yCursor():DisplayObject {
			return _yCursor;
		}
		public function set yCursor(dp:DisplayObject):void {
			_yCursor = dp;
			if (_inited) {
				_yCtrl.setCursor(_yCursor);
			}
		}
		//zctrl cursor
		protected var _zCursor:DisplayObject;
		public function get zCursor():DisplayObject {
			return _zCursor;
		}
		public function set zCursor(dp:DisplayObject):void {
			_zCursor = dp;
			if (_inited) {
				_zCtrl.setCursor(_zCursor);
			}
		}
		//pctrl cursor
		protected var _pCursor:DisplayObject;
		public function get pCursor():DisplayObject {
			return _pCursor;
		}
		public function set pCursor(dp:DisplayObject):void {
			_pCursor = dp;
			if (_inited) {
				_pCtrl.setCursor(_pCursor);
			}
		}
		
		//---------------------------
		//mask
		//---------------------------
		//show full circle rotation control, or half circle.
		private var _showFullControl:Boolean = false;
		public function get showFullControl():Boolean {
			return _showFullControl;
		}
		public function set showFullControl(val:Boolean):void {
			_showFullControl = val;
			if (_inited) {
				if (_showFullControl) {
					this.clearMask();
				}else {
					if(_canUseMask)this.applyMask();
				}
			}
		}
		//make use of mask for haflf circle control effect, _canUseMask implement wether can use mask in current context.
		private var _canUseMask:Boolean;
		protected var _xMask:Shape;
		protected var _yMask:Shape;
		protected var _zMask:Shape;
		protected var _maskContainer:Sprite;
		
		//---------------------------
		//out circle
		//---------------------------
		private var _outCircle:Shape;
		private var _outCircleStyle:Style = new Style(0, 0, 0x0, .7, 2);
		public function get outCircleStyle():Style {
			return _outCircleStyle;
		}
		public function set outCircleStyle(val:Style):void {
			_outCircleStyle = val;
			if (_inited && showOutCircle && target && (_mode == Transform3DMode.INTERNAL)) this.drawOutCircle();
		}
		private var _showOutCircle:Boolean = true;
		public function get showOutCircle():Boolean {
			return _showOutCircle;
		}
		public function set showOutCircle(val:Boolean):void {
			_showOutCircle = val;
			_outCircle.visible = _showOutCircle && (_mode == Transform3DMode.INTERNAL);
		}
		
		//-----------------------------
		//------- mode ----------
		//-----------------------------
		public override function set mode(val:uint):void {
			if (Transform3DMode.isInvalidMode(val)) return;
			_mode = val;
			
			if (!_inited) return;
			
			for each(var control:DimentionControl in _ctrls) {
				control.mode = _mode;
			}
			
			if (_mode == Transform3DMode.GLOBAL) {
				_pCtrl.visible = true;
				
				_canUseMask = false;
				this.clearMask();
				if(this._outCircle)this._outCircle.visible = false;
			}else if (_mode == Transform3DMode.INTERNAL) {
				_pCtrl.visible = false;
				
				_canUseMask = true;
				if (!_showFullControl && _target) this.applyMask();
				if (showOutCircle && _target) {
					this._outCircle.visible = true;
					this.drawOutCircle();
				}
			}
			
			this.update();
		}
		
		//---------------------------
		//---------- styles ---------
		//---------------------------
		protected var _xCtrlStyle:Style = new Style(0xff0000, .7, 0xff0000, .9,  1.5);
		public function get xCtrlStyle():Style {
			return _xCtrlStyle;
		}
		public function set xCtrlStyle(val:Style):void {
			_xCtrlStyle = val;
			if (_inited) {
				_xCtrl.style = _xCtrlStyle;
			}
		}
		
		protected var _yCtrlStyle:Style = new Style(0x00ff00, .7, 0x00ff00, .9,  1.5);
		public function get yCtrlStyle():Style {
			return _yCtrlStyle;
		}
		public function set yCtrlStyle(val:Style):void {
			_yCtrlStyle = val;
			if (_inited) {
				_yCtrl.style = _yCtrlStyle;
			}
		}
		
		protected var _zCtrlStyle:Style = new Style(0x0000ff, .7, 0x0000ff, .9,  1.5);
		public function get zCtrlStyle():Style {
			return _zCtrlStyle;
		}
		public function set zCtrlStyle(val:Style):void {
			_zCtrlStyle = val;
			if (_inited) {
				_zCtrl.style = _zCtrlStyle;
			}
		}
		
		protected var _pCtrlStyle:Style = new Style(0xff6600, 0, 0xff6600, .9,  1.5);
		public function get pCtrlStyle():Style {
			return _pCtrlStyle;
		}
		public function set pCtrlStyle(val:Style):void {
			_pCtrlStyle = val;
			if (_inited) {
				_pCtrl.style = _pCtrlStyle;
			}
		}
		
		//------------------------------
		//----on added on stage---------
		//------------------------------
		protected var _showPRotateCtrl:Boolean = true;
		public function get showPRotateCtrl():Boolean { return _showPRotateCtrl; }
		public function set showPRotateCtrl(value:Boolean):void 
		{
			_showPRotateCtrl = value;
			if (_inited) {
				if(_root.contains(_pCtrl))_root.removeChild(_pCtrl);
			}
		}
		
		//------------------------------
		//----on added on stage---------
		//------------------------------
		override protected function onAdded(evt:Event = null):void {
			_xCtrl = new XRotationControl();
			_yCtrl = new YRotationControl();
			_zCtrl = new ZRotationControl();
			_pCtrl = new PRotationControl();
			_ctrls = [_xCtrl, _yCtrl, _zCtrl, _pCtrl];
			
			_xCtrl.style = _xCtrlStyle;
			_yCtrl.style = _yCtrlStyle;
			_zCtrl.style = _zCtrlStyle;
			_pCtrl.style = _pCtrlStyle;
			
			_xCtrl.radius = _yCtrl.radius = _zCtrl.radius = _radius;
			_pCtrl.radius = _radius + 10;
			
			if(xCursor)_xCtrl.setCursor(xCursor);
			if(yCursor)_yCtrl.setCursor(yCursor);
			if(zCursor)_zCtrl.setCursor(zCursor);
			if(pCursor)_pCtrl.setCursor(pCursor);
			
			_xCtrl.name = "x";
			_yCtrl.name = "y";
			_zCtrl.name = "z";
			_pCtrl.name = "p";
			
			_root.addChild(_xCtrl);
			_root.addChild(_yCtrl);
			_root.addChild(_zCtrl);
			if(_showPRotateCtrl)_root.addChild(_pCtrl);
			
			//--------------------------------------------
			//-----for half circle control effect---------
			//--------------------------------------------
			this._maskContainer = new Sprite();
			this._maskContainer.mouseEnabled = false;
			this.addChild(this._maskContainer);
			
			_xMask = new Shape();
			this.buildControlMask(_xMask);
			this._maskContainer.addChild(_xMask);
			
			_yMask = new Shape();
			this.buildControlMask(_yMask);
			this._maskContainer.addChild(_yMask);
			
			_zMask = new Shape();
			this.buildControlMask(_zMask);
			this._maskContainer.addChild(_zMask);
			//---------------------------------------
			
			//---------------------------------------
			//-----draw out circle;
			//---------------------------------------
			_outCircle = new Shape();
			addChild(_outCircle);
			this.drawOutCircle();
			showOutCircle = _showOutCircle;
			
			//
			super.onAdded(evt);
		}
		
		override protected function onRemoved(evt:Event = null):void {
			this._maskContainer.removeChild(_xMask);
			this._maskContainer.removeChild(_yMask);
			this._maskContainer.removeChild(_zMask);
			
			_xMask = null;
			_yMask = null;
			_zMask = null;
			
			removeChild(this._maskContainer);
			this._maskContainer = null;
			
			removeChild(this._outCircle);
			_outCircle = null;
			
			_root.removeChild(_xCtrl);
			_root.removeChild(_yCtrl);
			_root.removeChild(_zCtrl);
			if(_root.contains(_pCtrl))_root.removeChild(_pCtrl);
			
			_xCtrl.dispose();
			_yCtrl.dispose();
			_zCtrl.dispose();
			_pCtrl.dispose();
			
			_xCtrl = null;
			_yCtrl = null;
			_xCtrl = null;
			_pCtrl = null;
			
			_ctrls = null;
			
			super.onRemoved(evt);
		}
		
		
		//-------------------------------------
		//-------------------------------------
		//-------------------------------------
		
		
		protected override function onActiveControl(ctrl:DimentionControl):void {
			super.onActiveControl(ctrl);
			
			if (_showFullControl || !_canUseMask || !(ctrl is RotationDimentionControl)) return;
			this.clearMask(ctrl.name);
		}
		
		protected override function onDeactiveControl(ctrl:DimentionControl):void {
			super.onDeactiveControl(ctrl);
			
			if (_showFullControl || !_canUseMask || !(ctrl is RotationDimentionControl)) return;
			this.applyMask(ctrl.name);
		}
		
		protected override function onChangeControlValue(ctrl:DimentionControl):void {
			if(_mode == Transform3DMode.INTERNAL){
				_targetMX.prependTranslation(_innerReg.x, _innerReg.y, _innerReg.z);
				
				switch(ctrl) {
					case _xCtrl:
						_targetMX.prependRotation(_xCtrl.degree, Vector3D.X_AXIS);
						break;
					case _yCtrl:
						_targetMX.prependRotation(_yCtrl.degree, Vector3D.Y_AXIS);
						break;
					case _zCtrl:
						_targetMX.prependRotation(_zCtrl.degree, Vector3D.Z_AXIS);
						break;
					case _pCtrl:
						_targetMX.prependRotation(_pCtrl.degreeX, Vector3D.X_AXIS);
						_targetMX.prependRotation(_pCtrl.degreeY, Vector3D.Y_AXIS);
						break;
				}
				
				_targetMX.prependTranslation( -_innerReg.x, -_innerReg.y, -_innerReg.z);
			}else if (_mode == Transform3DMode.GLOBAL) {
				var mx:Matrix3D = this._originConcatenatedMX.clone();
				var reg:Vector3D = mx.transformVector(_innerReg);
				mx.appendTranslation(-reg.x, -reg.y, -reg.z);
				switch(ctrl) {
					case _xCtrl:
						mx.appendRotation(_xCtrl.degree, Vector3D.X_AXIS);
						break;
					case _yCtrl:
						mx.appendRotation(_yCtrl.degree, Vector3D.Y_AXIS);
						break;
					case _zCtrl:
						mx.appendRotation(_zCtrl.degree, Vector3D.Z_AXIS);
						break;
					case _pCtrl:
						mx.appendRotation(_pCtrl.degreeX, Vector3D.X_AXIS);
						mx.appendRotation(_pCtrl.degreeY, Vector3D.Y_AXIS);
						break;
				}
				mx.appendTranslation(reg.x, reg.y, reg.z);
				
				var parentMX:Matrix3D = _originParentConcatenatedMX.clone();
				parentMX.invert();
				mx.append(parentMX);
				_targetMX = mx.clone();
			}
		}
		
		protected override function updateControls(deltaMX:Matrix3D = null):void {
			super.updateControls(deltaMX);
			
			for each(var ctrl:DimentionControl in _ctrls) {
				if (ctrl == _regCtrl || ctrl == _pCtrl) {
				}else {
					ctrl.matrix = _deltaMx;
				}
			}
			
			this._outCircle.x = _root.x;
			this._outCircle.y = _root.y;
			this.drawOutCircle();
			
			this._maskContainer.x = _root.x;
			this._maskContainer.y = _root.y;
			
			//for half circle control effect.
			if (!_canUseMask || _showFullControl) return;
			
			var tolerance:Number = 1;
			var crv:Vector3D = _deltaMx.decompose()[1];
			
			//_xCtrl
			var rz:Number = (Util.projectRotationZ(_xCtrl.matrix));
			var ty:Number = Math.sin(crv.y);
			_xMask.rotation = rz + (ty > 0?90: -90);
			if (!_xCtrl.actived) {
				ty = (crv.y * Util.RADIAN) % 90;
				if (Math.abs(ty) < tolerance || (90-Math.abs(ty))<tolerance) {
					this.clearMask("x");
				}else {
					this.applyMask("x");
				}
			}
			
			//_yCtrl
			rz = (Util.projectRotationZ(_yCtrl.matrix));
			ty = Math.sin(crv.x);
			_yMask.rotation = rz - (ty > 0?90: -90);
			if (!_yCtrl.actived) {
				ty = (crv.z * Util.RADIAN) % 90;
				if (Math.abs(ty) < tolerance || (90-Math.abs(ty))<tolerance) {
					this.clearMask("y");
				}else {
					this.applyMask("y");
				}
			}
			
			
			//_zCtrl
			rz = (Util.projectRotationZ(_zCtrl.matrix));
			ty = Math.cos(crv.x);
			_zMask.rotation = rz + (ty > 0?90: -90);
			if(!_zCtrl.actived){
				ty = (crv.x * Util.RADIAN) % 90;
				if (Math.abs(ty) < tolerance || (90-Math.abs(ty))<tolerance) {
					this.clearMask("z");
				}else {
					this.applyMask("z");
				}
			}
		}
		
		private function buildControlMask(shape:Shape):void {
			shape.graphics.beginFill(0xffffff, .5);
			shape.graphics.drawRect(-_radius*2, -_radius*2, 4*_radius, _radius*2+1);
			shape.graphics.endFill();
			shape.visible = false;
		}
		
		/**
		 * clear mask of one contrl
		 * @param	dimention
		 */
		private function clearMask(dimention:String = null):void {
			switch(dimention) {
				case "x":
					_xCtrl.shape.mask = null;
					break;
				case "y":
					_yCtrl.shape.mask = null;
					break;
				case "z":
					_zCtrl.shape.mask = null;
					break;
				case null:
					_xCtrl.shape.mask = null;
					_yCtrl.shape.mask = null;
					_zCtrl.shape.mask = null;
					this._maskContainer.graphics.clear();
			}
		}
		
		/**
		 * apply mask to contrl
		 * @param	dimention
		 */
		private function applyMask(dimention:String = null):void {
			switch(dimention) {
				case "x":
					_xCtrl.shape.mask = _xMask;
					break;
				case "y":
					_yCtrl.shape.mask = _yMask;
					break;
				case "z":
					_zCtrl.shape.mask = _zMask;
					break;
				case null:
					_xCtrl.shape.mask = _xMask;
					_yCtrl.shape.mask = _yMask;
					_zCtrl.shape.mask = _zMask;
			}
			
		}
		
		/**
		 * draw out circle of controls
		 */
		private function drawOutCircle():void {
			if (this._outCircle){
				this._outCircle.graphics.clear();
				this._outCircle.graphics.lineStyle(_outCircleStyle.borderThickness, _outCircleStyle.borderColor, _outCircleStyle.borderAlpha);
				this._outCircle.graphics.beginFill(_outCircleStyle.fillColor, _outCircleStyle.fillAlpha);
				this._outCircle.graphics.drawCircle(0, 0, _radius + .5);
				this._outCircle.graphics.endFill();
			}
		}
		
		protected override function clear():void {
			if(this._maskContainer)this._maskContainer.graphics.clear();
			if (this._outCircle)this._outCircle.graphics.clear();
			
			super.clear();
		}
	}
	
}
