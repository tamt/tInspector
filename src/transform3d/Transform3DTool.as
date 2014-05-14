package transform3d 
{
	import transform3d.consts.Transform3DMode;
	import transform3d.consts.TransformToolMode;
	import transform3d.controls.Control;
	import transform3d.controls.ITransformControl;
	import transform3d.controls.Style;
	import transform3d.controls.TransformControl;
	import transform3d.controls.translation.GlobalTranslationControl;
	import transform3d.cursors.CustomMouseCursor;
	import transform3d.events.TransformEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.geom.Rectangle;

	/**
	 * Transform3DTool, contains two tool components: RotationTool, TranslationTool.
	 * @example
	 * var tool3d:Transform3DTool = new Transform3DTool();
	 * addChild(tool3d);
	 * 
	 * tool3d.target = mc1;
	 * 
	 * tool3d.addEventListener(TransformEvent.UPDATE, updateEventHandler);
	 * @author tamt
	 */
	public class Transform3DTool extends Control implements ITransformControl
	{
		//tool to transform target's rotation
		private var _rTool:RotationTool;
		//tool to transform target's translation
		private var _tTool:TranslationTool;
		//tool to transform target's scale
		private var _sTool:ScaleTool;
		//tool to transform target's translation relation Stage's coordinates
		private var _gTool:GlobalTranslationTool;
		
		//tool to transform target's rotation
		public function get rotationTool():RotationTool {
			return _rTool;
		}
		
		//tool to transform target's translation
		public function get translationTool():TranslationTool {
			return _tTool;
		}
		
		//tool to transform target's scale
		public function get scaleTool():ScaleTool { return _sTool; }
		
		//tool to transform target's translation relation Stage's coordinates
		public function get globalTranslationTool():GlobalTranslationTool {
			return _gTool;
		}
				
		//transform mode, will be "internal" or "global"
		protected var _mode:uint = Transform3DMode.GLOBAL;
		public function get mode():uint {
			return _mode;
		}
		
		//transform mode, will be "internal" or "global"
		public function set mode(val:uint):void {
			if (Transform3DMode.isInvalidMode(val)) return;
			
			_mode = val;
			//set all tool's mode
			_rTool.mode = _mode;
			_tTool.mode = _mode;
			_sTool.mode = _mode;
			_gTool.mode = _mode;
		}
		
		protected var _tool:String = "scale";
		
		/**
		 * select use a tool
		 */
		public function selectTool(tool:String = null):void {
			if (tool == null) tool = TransformToolMode.ALL;
			if (TransformToolMode.isInvalidMode(tool)) return;
			
			switch(tool) {
				case TransformToolMode.ROTATION:
					if (!this.contains(_rTool)) addChild(_rTool);
					break;
				case TransformToolMode.TRANSLATION:
					if (!this.contains(_tTool)) addChild(_tTool);
					break;
				case TransformToolMode.SCALE:
					if (!this.contains(_sTool)) addChild(_sTool);
					break;
				case TransformToolMode.GLOBAL_TRANSLATION:
					if (!this.contains(_gTool)) addChild(_gTool);
					break;
				case TransformToolMode.ALL:
					this.selectTool(TransformToolMode.ROTATION);
					this.selectTool(TransformToolMode.TRANSLATION);
					this.selectTool(TransformToolMode.SCALE);
					this.selectTool(TransformToolMode.GLOBAL_TRANSLATION);
					break;
					
			}
		}
		
		/**
		 * deselect use a tool
		 */
		public function deselectTool(tool:String = null):void {
			if (tool == null) tool = TransformToolMode.ALL;
			if (TransformToolMode.isInvalidMode(tool)) return;
			
			switch(tool) {
				case TransformToolMode.ROTATION:
					if (this.contains(_rTool)) removeChild(_rTool);
					break;
				case TransformToolMode.TRANSLATION:
					if (this.contains(_tTool)) removeChild(_tTool);
					break;
				case TransformToolMode.SCALE:
					if (this.contains(_sTool)) removeChild(_sTool);
					break;
				case TransformToolMode.GLOBAL_TRANSLATION:
					if (this.contains(_gTool)) removeChild(_gTool);
					break;
				case TransformToolMode.ALL:
					this.deselectTool(TransformToolMode.ROTATION);
					this.deselectTool(TransformToolMode.TRANSLATION);
					this.deselectTool(TransformToolMode.SCALE);
					this.deselectTool(TransformToolMode.GLOBAL_TRANSLATION);
					break;
					
			}
		}
		
		public function toolInuse(tool:String):Boolean {
			if (TransformToolMode.isInvalidMode(tool)) return false;
			
			switch(tool) {
				case TransformToolMode.ROTATION:
					return this.contains(_rTool);
					break;
				case TransformToolMode.TRANSLATION:
					return this.contains(_tTool);
					break;
				case TransformToolMode.SCALE:
					return this.contains(_sTool);
					break;
				case TransformToolMode.GLOBAL_TRANSLATION:
					return this.contains(_gTool);
					break;
				case TransformToolMode.ALL:	
					return toolInuse(TransformToolMode.ROTATION) && toolInuse(TransformToolMode.TRANSLATION) && toolInuse(TransformToolMode.SCALE) && toolInuse(TransformToolMode.GLOBAL_TRANSLATION);
					break;
					
			}
			return false;
		}
		
		protected var _target:DisplayObject;
		public function get target():DisplayObject {
			return _target;
		}
		
		/**
		 * set target of Transform3DTool
		 */
		public function set target(val:DisplayObject):void {
			if (!this.isTargetValid(val)) return;
			
			_target = val;
			
			//set all tool's target
			_rTool.target = _target;
			_tTool.target = _target;
			_sTool.target = _target;
			_gTool.target = _target;
		}
		
		//-----------------------------
		//--------registration---------
		//-----------------------------
		//target's registration relatie to Stage
		protected var _reg:Point;
		public function get registration():Point {
			return _reg;
		}
		
		/**
		 * set target's registration(relative to Stage's corrdinate)
		 * @param pt	target's registration relatie to Stage's coordinate
		 */
		public function set registration(pt:Point):void {
			_reg = pt.clone();
			//set all tool's registration
			_rTool.registration = _reg;
			_sTool.registration = _reg;
			_tTool.registration = _reg;
			_gTool.registration = _reg;
		}
		
		//target's registration
		protected var _innerReg:Vector3D;
		public function get innerReg():Vector3D {
			return _innerReg;
		}
		
		/**
		 * set target's inner registration(relative to target's corrdinate)
		 * @param val	target's registration relatie to target's corrdinate
		 */
		public function set innerReg(val:Vector3D):void {
			_innerReg = val.clone();
			
			//set all tool's inner registration
			_rTool.innerReg = _innerReg;
			_sTool.innerReg = _innerReg;
			_tTool.innerReg = _innerReg;
			_gTool.innerReg = _innerReg;
		}
		
		//--------------------------------
		//---------- styles --------------
		//--------------------------------
		protected var _xCtrlStyle:Style = new Style(0xff0000, .7, 0xff0000, .9,  1.5);
		public function get xCtrlStyle():Style {
			return _xCtrlStyle;
		}
		/**
		 * x control's style
		 */
		public function set xCtrlStyle(val:Style):void {
			_xCtrlStyle = val;
			if (_inited) {
				//set all tool's x control's style
				_rTool.xCtrlStyle = _xCtrlStyle;
				_tTool.xCtrlStyle = _xCtrlStyle;
			}
		}
		
		protected var _yCtrlStyle:Style = new Style(0x00ff00, .7, 0x00ff00, .9,  1.5);
		public function get yCtrlStyle():Style {
			return _yCtrlStyle;
		}
		/**
		 * y control's style
		 */
		public function set yCtrlStyle(val:Style):void {
			_yCtrlStyle = val;
			if(_inited){
				//set all tool's y control's style
				_rTool.yCtrlStyle = _yCtrlStyle;
				_tTool.yCtrlStyle = _yCtrlStyle;
			}
		}
		
		protected var _zCtrlStyle:Style = new Style(0x0000ff, .7, 0x0000ff, .9,  1.5);
		public function get zCtrlStyle():Style {
			return _zCtrlStyle;
		}
		/**
		 * z control's style
		 */
		public function set zCtrlStyle(val:Style):void {
			_zCtrlStyle = val;
			if(_inited){
				//set all tool's z control's style
				_rTool.zCtrlStyle = _zCtrlStyle;
				_tTool.zCtrlStyle = _zCtrlStyle;
			}
		}
		
		//regctrl style
		protected var _regCtrlStyle:Style = new Style(0xffffff, 1, 0, 1, 1);;
		public function get regCtrlStyle():Style {
			return _regCtrlStyle;
		}
		/**
		 * reg control's style
		 */
		public function set regCtrlStyle(val:Style):void {
			_regCtrlStyle = val;
			
			if (_inited) {
				//set all tool's registartion control's style
				_rTool.regCtrlStyle = _regCtrlStyle;
				_tTool.regCtrlStyle = _regCtrlStyle;
				_sTool.regCtrlStyle = _regCtrlStyle;
			}
		}
		
		//-------------------------------
		//---------tool components-------
		//-------------------------------
		//store all tools
		private var _tools:Array = [];
		
		//---------------------------------
		//----------- constructor ---------
		//---------------------------------
		public function Transform3DTool() 
		{
			_gTool = new  GlobalTranslationTool();
			//addChild(_gTool);
			
			_rTool = new RotationTool();
			//addChild(_rTool);
			
			_tTool = new TranslationTool();
			//addChild(_tTool);
			
			_sTool = new ScaleTool();
			//addChild(_sTool);
			
			_tools = [_rTool, _tTool, _sTool, _gTool];
			
			super();
			
			//setup mode/target/tool default value
			this.mode = _mode;
			this.target = _target;
		}
		
		/**
		 * called when Transform3DTool added to Stage
		 * @param	evt
		 */
		protected override function onAdded(evt:Event = null):void {
			super.onAdded(evt);
			
			//init custom mouse cursor.
			CustomMouseCursor.init(this.root as DisplayObjectContainer);
			
			//listen tool's udpate event and registration change event.
			for each(var tool:TransformControl in _tools) {
				tool.addEventListener(TransformEvent.UPDATE, onToolUpdate);
				tool.addEventListener(TransformEvent.REGISTRATION, onRegistrationUpdate);
			}
		}
		
		/**
		 * called when Transform3DTool removed from Stage
		 * @param	evt
		 */
		protected override function onRemoved(evt:Event = null):void {
			super.onRemoved(evt);
			
			for each(var tool:TransformControl in _tools) {
				tool.removeEventListener(TransformEvent.UPDATE, onToolUpdate);
				tool.removeEventListener(TransformEvent.REGISTRATION, onRegistrationUpdate);
			}
			
		}
		
		/**
		 * called when one tool update
		 * @param	evt
		 */
		protected function onToolUpdate(evt:Event):void {
			var curTool:TransformControl = evt.target as TransformControl;
			for each(var tool:TransformControl in _tools) {
				if (tool != curTool) {
					tool.update(curTool.concatenatedMX, curTool.controlMX, curTool.deltaMX);
				}
			}
			
			//dispatch update event.
			dispatchEvent(new TransformEvent(TransformEvent.UPDATE, true, true));
		}
		
		/**
		 * called when one tool registration change
		 * @param	evt
		 */
		protected function onRegistrationUpdate(evt:Event):void {
			var curTool:TransformControl = evt.target as TransformControl;
			for each(var tool:TransformControl in _tools) {
				if (tool != curTool) {
					//tool.innerReg = curTool.innerReg;
					tool.registration = curTool.registration;
				}
			}
			
			_reg = curTool.registration.clone();
			
			//dispatche registration change event.
			dispatchEvent(new TransformEvent(TransformEvent.REGISTRATION, true, true));
		}
		
		
		//------------------------------------
		//-----------public functions---------
		//------------------------------------
		
		/**
		 * update tool status
		 * @param	concatenatedMX		target's concatenated matrix3D
		 * @param	controlMX			tool's control matrix3D
		 * @param	deltaMX				tool's control matrix3D(doesn't include translation data)
		 */
		public function update(concatenatedMX:Matrix3D = null, controlMX:Matrix3D = null, deltaMX:Matrix3D = null):void {
			if (this.contains(_rTool)) _rTool.update(concatenatedMX, controlMX, deltaMX);
			if (this.contains(_tTool))_tTool.update(concatenatedMX, controlMX, deltaMX);
			if (this.contains(_sTool))_sTool.update(concatenatedMX, controlMX, deltaMX);
			if(this.contains(_gTool))_gTool.update(concatenatedMX, controlMX, deltaMX)
		}
		
		/**
		 * is target valid
		 * @param	target
		 * @return
		 */
		public function isTargetValid(dp:DisplayObject):Boolean {
			return !(dp == this || (dp is Stage) || (dp && contains(dp)) || (dp is DisplayObjectContainer && (dp as DisplayObjectContainer).contains(this)));
		}
		
	}

}
