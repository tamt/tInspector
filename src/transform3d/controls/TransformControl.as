package transform3d.controls 
{
	import transform3d.controls.rotation.*;
	import transform3d.events.TransformEvent;
	import transform3d.consts.Transform3DMode;
	import transform3d.util.Util;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.*;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import net.badimon.five3D.display.Scene3D;
	import net.badimon.five3D.display.Sprite3D;

	/**
	 * base Class of RotationTool and TranslationTool.
	 * @author tamt
	 */
	public class TransformControl extends Sprite implements ITransformControl
	{
		//root container of controls
		protected var _root:Scene3D;
		//skin container of controls
		protected var _skinContainer:Sprite;
		//
		protected var _inited:Boolean = false;
		
		//the Control display the registrantion.
		protected var _regCtrl:RegistrationControl;
		
		protected var _mode:uint = 1;
		public function get mode():uint {
			return _mode;
		}
		
		//set the transform mode, either Internal or Global mode.
		public function set mode(val:uint):void {
			if (Transform3DMode.isInvalidMode(val)) return;
			_mode = val;
			
			if (!_inited) return;
			
			for each(var control:DimentionControl in _ctrls) {
				control.mode = _mode;
			}
			
			this.update();
		}	
		
		//sotre the contrls used for interaction, x contrl, y contrl, z control...
		protected var _ctrls:Array;
		//target's registartion
		protected var _innerReg:Vector3D;
		public function get innerReg():Vector3D {
			return _innerReg;
		}
		public function set innerReg(val:Vector3D):void {
			_innerReg = val;
			if(_target){
				_reg = _target.local3DToGlobal(_innerReg);
				if (_inited) update();
			}
		}
		//target's registration relatie to Stage
		internal var _reg:Point;
		public function get registration():Point {
			return _reg;
		}
		//
		public function set registration(pt:Point):void {
			_reg = pt.clone();
			if (_target) {
				_innerReg = _target.globalToLocal3D(_reg);
				if (_inited) update();
			}
		}
		
		//regctrl cursor
		protected var _regCursor:DisplayObject;
		public function get regCursor():DisplayObject {
			return _regCursor;
		}
		public function set regCursor(dp:DisplayObject):void {
			_regCursor = dp;
			if (_inited) {
				_regCtrl.setCursor(_regCursor);
			}
		}
		
		//regctrl style
		protected var _regCtrlStyle:Style = new Style(0xffffff, 1, 0, 1, 1);;
		public function get regCtrlStyle():Style {
			return _regCtrlStyle;
		}
		public function set regCtrlStyle(val:Style):void {
			_regCtrlStyle = val;
			if (_inited) {
				_regCtrl.style = _regCtrlStyle;
			}
		}
		
		//target's origin mx3d, before transform.
		protected var _originMX:Matrix3D;
		//the mx3d will apply to target.
		protected var _targetMX:Matrix3D;
		//target's mx3d relative to this
		protected var _concatenatedMX:Matrix3D;
		public function get concatenatedMX():Matrix3D{
			return _concatenatedMX;
		} 
		//the mx3d will apply to tool's controls.
		protected var _controlMX:Matrix3D;
		public function get controlMX():Matrix3D{
			return _controlMX;
		}
		//the mx3d will apply to tool's controls. exclude translation data.
		protected var _deltaMx:Matrix3D;
		public function get deltaMX():Matrix3D{
			return _deltaMx;
		}
		
		protected var _originConcatenatedMX:Matrix3D;
		protected var _originParentConcatenatedMX:Matrix3D;
		
		//
		protected var _target:DisplayObject;
		public function get target():DisplayObject {
			return _target;
		}
		
		//set transform tool's target.
		public function set target(dp:DisplayObject):void {
			if (!isTargetValid(dp)) {
				return;
			}
			
			_target = dp;
			
			//clear control if target is null
			if (_target == null) {
				clear();
				return;
			}
			
			//show controls
			if (!_root.visible)_root.visible = true;
			//show skins
			if (!_skinContainer.visible)_skinContainer.visible = true;
			
			//conver target to 3d object if it's not
			if (_target.transform.matrix3D == null) {
				Util.converTo3DDisplayObject(_target);
			}
			
			var pt:Point = this.getProjectionCenter();
			_root.x = pt.x;
			_root.y = pt.y;
			_root.viewDistance = _target.root.transform.perspectiveProjection.focalLength;
			
			_concatenatedMX = this.getConcatenatedMatrix3D();
			_originMX = this.getMatrix3D();//this._target.transform.matrix3D.clone();
			_targetMX = _originMX.clone();
			
			if (_innerReg || _reg) {
				if (_reg == null)_reg = _target.local3DToGlobal(_innerReg);
				if (_innerReg == null)_innerReg = _target.globalToLocal3D(_reg);
			}else{
				//caculate the default registration.
				var internalRect:Rectangle = _target.getRect(_target);
				pt = new Point(internalRect.left + internalRect.width / 2, internalRect.top + internalRect.height / 2);
				_reg = _target.localToGlobal(pt);
				_innerReg = _target.globalToLocal3D(_reg);
			}
			this.update();
		}
		
		//--------------------------------
		//---------constructor------------
		//--------------------------------

		public function TransformControl() 
		{
			//create root container of sub controls
			_root = new Scene3D();
			addChild(_root);
			
			//create skin container
			_skinContainer = new Sprite();
			addChildAt(_skinContainer, 0);
			
			if (stage) onInterAdded();
			else addEventListener(Event.ADDED_TO_STAGE, onInterAdded);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onInterRemoved);
		}
		
		private function onInterAdded(evt:Event = null):void {
			if (_inited) return;
			_inited = true;
			this.onAdded(evt);
		}
		
		private function onInterRemoved(evt:Event = null):void {
			_inited = false;
			this.onRemoved(evt);
		}
		
		protected function onAdded(evt:Event = null):void {
			_regCtrl = new RegistrationControl();
			_regCtrl.style = _regCtrlStyle;
			if(regCursor)_regCtrl.setCursor(regCursor);
			_root.addChild(_regCtrl);
			_ctrls.push(_regCtrl);
			
			//apply default mode.
			this.mode = _mode;
			
			//listene events dispatch from x,y,z controls and reg control.
			this.addEventListener(Event.ACTIVATE, onControlActived);
			this.addEventListener(Event.DEACTIVATE, onControlDeactived);
			this.addEventListener(Event.CHANGE, onChange);
			_regCtrl.addEventListener(Event.CHANGE, onChangeReg);
			
			this.target = _target;
		}
		
		/**
		 * when control removed from Stage
		 * @param	evt
		 */
		protected function onRemoved(evt:Event = null):void {
			//stop listening Control events
			this.removeEventListener(Event.ACTIVATE, onControlActived);
			this.removeEventListener(Event.DEACTIVATE, onControlDeactived);
			this.removeEventListener(Event.CHANGE, onChange);
			
			//clear registration control
			_regCtrl.removeEventListener(Event.CHANGE, onChangeReg);
			if(_regCtrl.parent)_regCtrl.parent.removeChild(_regCtrl);
			_regCtrl.dispose();
			_regCtrl = null;
		}
		
		//--------------------------------
		//--------public functions--------
		//--------------------------------
		
		public function update(concatenatedMX:Matrix3D = null, controlMX:Matrix3D = null, deltaMX:Matrix3D = null):void {
			if (_target == null) return;
			_concatenatedMX = concatenatedMX?concatenatedMX.clone():this.getConcatenatedMatrix3D();
			_originMX = _target.transform.matrix3D; 
			_targetMX = _originMX.clone();
			
			interUpdate(controlMX, deltaMX);
		}
		
		/**
		 * is target valid?
		 * @param	target
		 * @return
		 */
		public function isTargetValid(dp:DisplayObject):Boolean {
			return !(dp == this || (dp && contains(dp)) || (dp is DisplayObjectContainer && (dp as DisplayObjectContainer).contains(this)));
		}
	
		public function dispose():void {
			onRemoved();
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		//--------------------------------
		//-------protected functions------
		//--------------------------------
		/**
		 * update function of control internal.
		 * @param	controlMX
		 * @param	deltaMX
		 */
		protected function interUpdate(controlMX:Matrix3D = null, deltaMX:Matrix3D = null):void {
			if(controlMX == null){
				var pos:Point = Util.local3DToTarget(_target, _innerReg, this); 
				if (_mode == Transform3DMode.GLOBAL) {
					_controlMX = new Matrix3D();
					_controlMX.position = new Vector3D(pos.x, pos.y, 0);
				}else if (_mode == Transform3DMode.INTERNAL) {
					_controlMX = _concatenatedMX.clone();
					_controlMX.position = new Vector3D(pos.x, pos.y, 0);
				}
			}else{
				_controlMX = controlMX.clone();
			}
			
			if(_inited){
				updateControls(deltaMX);
				_root.forceRender();
			}
		}
		
		/**
		 * update controls of tool
		 * @param	deltaMX
		 */
		protected function updateControls(deltaMX:Matrix3D = null):void {
			if(deltaMX == null){
				_deltaMx = _controlMX.clone();

				//extract the delta transform data(exclue translation data)
				var comps:Vector.<Vector3D> = new Vector.<Vector3D>(3);
				comps[0] = new Vector3D(0, 0, 0, 0)
				comps[1] = _deltaMx.decompose()[1].clone();
				comps[2] = new Vector3D(1, 1, 1, 0);
				_deltaMx.recompose(comps);
			}else{
				_deltaMx = deltaMX.clone();
			}

			_root.x = _controlMX.position.x;
			_root.y = _controlMX.position.y;
			
			_skinContainer.x = _root.x;
			_skinContainer.y = _root.y;
		}
		
		/**
		 * clear control, hide tools, skins.
		 */
		protected function clear():void {
			_target = null;
			_originMX = null;
			_targetMX = null;
			_controlMX = null;
			_root.visible = false;
			_skinContainer.visible = false;
		}
		
		/**
		 * handler tool's registration change event
		 * @param	evt
		 */
		protected function onChangeReg(evt:Event):void {
			if (_target == null) return;
			_reg = new Point(stage.mouseX - _regCtrl.dragOffsetX, stage.mouseY - _regCtrl.dragOffsetY);
			_innerReg = _target.globalToLocal3D(_reg);
			
			this.interUpdate();
			
			this.dispatchEvent(new TransformEvent(TransformEvent.REGISTRATION));
		}
		
		/**
		 * handle tool's value change event
		 * @param	evt
		 */
		private function onChange(evt:Event):void {
			if (_target == null) return;
			evt.stopImmediatePropagation();
			evt.preventDefault();
			
			//if the event target is _regCtrl, return, we handle it's event in onChangeReg
			if (evt.target == _regCtrl) return;
			
			_targetMX = _originMX.clone();
	
			this.onChangeControlValue(evt.target as DimentionControl);
		
			_target.transform.matrix3D = _targetMX;
			_concatenatedMX = this.getConcatenatedMatrix3D();
	
			interUpdate();
			this.dispatchEvent(new TransformEvent(TransformEvent.UPDATE));
		}
		/**
		 * handler of Control active
		 * @param	evt
		 */
		private function onControlActived(evt:Event):void {
			if (_target == null) return;
			if (!(evt.target is DimentionControl)) return;
			evt.stopImmediatePropagation();
			evt.preventDefault();
			
			_originMX = _target.transform.matrix3D.clone();
			
			this.onActiveControl(evt.target as DimentionControl);
		}
		
		/**
		 * handler of Control deactive 
		 * @param	evt
		 */
		private function onControlDeactived(evt:Event):void {
			if (_target == null) return;
			if (!(evt.target is DimentionControl)) return;
			evt.stopImmediatePropagation();
			evt.preventDefault();
			
			this.onDeactiveControl(evt.target as DimentionControl);
			this.interUpdate();
			this.dispatchEvent(new TransformEvent(TransformEvent.UPDATE));

			_originMX = _target.transform.matrix3D.clone();

		}
		
		/**
		 * when control value change
		 * @param	ctrl
		 */
		protected function onChangeControlValue(ctrl:DimentionControl):void {
			
		}
		
		/**
		 * called when control active
		 * @param	ctrl
		 */
		protected function onActiveControl(ctrl:DimentionControl):void {
			for each(var ctrl:DimentionControl in _ctrls) {
				if (ctrl == _regCtrl) continue;
				if (!ctrl.actived) {
					ctrl.alpha = 1;
				}else {
					ctrl.alpha = 1;
				}
			}
			
			if(_target){
				_originConcatenatedMX = this.getConcatenatedMatrix3D();
				_originParentConcatenatedMX = this.getParentConcatenatedMatrix3D(_target, _root);
			}
		}
		
		/**
		 * called when control deactive
		 * @param	ctrl
		 */
		protected function onDeactiveControl(ctrl:DimentionControl):void {
			for each(var ctrl:DimentionControl in _ctrls) {
				if (ctrl == _regCtrl) continue;
				ctrl.alpha = 1;
			}
		}
		
		/**
		 * get projection center of 3D space relative to control
		 * @return
		 */
		protected function getProjectionCenter():Point {
			var pt = _target.root.transform.perspectiveProjection.projectionCenter;
			pt = this.globalToLocal(pt);
			return pt;
		}

		protected function getConcatenatedMatrix3D():Matrix3D {
			var mx:Matrix3D = _target.transform.getRelativeMatrix3D(_root);
			return mx;
		}
		
		protected function getMatrix3D():Matrix3D {
			if(this._target.transform.matrix3D){
				return this._target.transform.matrix3D.clone();
			}else {
				var mx2d:Matrix = this._target.transform.matrix.clone();
				this._target.z = 1;
				this._target.z = 0;
				var mx3d:Matrix3D = this._target.transform.matrix3D.clone();
				this._target.transform.matrix = mx2d;
				return mx3d;
			}
		}
		
		/**
		 * get concatenated matrix3D of target's parent.
		 * @param	target			
		 * @param	relativeTo		relative coordinate
		 * @return
		 */
		protected function getParentConcatenatedMatrix3D(target:DisplayObject, relativeTo:DisplayObject):Matrix3D {
			var p:DisplayObjectContainer = target.parent;
			
			//if target is a 2D object
			if (p.transform.matrix) {
				//conver it to 3D object, 
				var mx2d:Matrix = p.transform.matrix.clone();
				p.z = 1;
				p.z = 0;
				//extract its matrix3D
				var mx3d:Matrix3D = p.transform.getRelativeMatrix3D(relativeTo);
				//revert target to 2D object
				p.transform.matrix = mx2d;
				return mx3d;
			}else {
				return p.transform.getRelativeMatrix3D(relativeTo);
			}
						
			return new Matrix3D();
		}
		

	}

}
