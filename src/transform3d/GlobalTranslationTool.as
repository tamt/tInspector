package transform3d 
{
	import transform3d.controls.DimentionControl;
	import transform3d.controls.Style;
	import transform3d.controls.TransformControl;
	import transform3d.controls.translation.GlobalTranslationControl;
	import transform3d.util.Util;
	import flash.display.DisplayObject;
	import flash.geom.Orientation3D;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class GlobalTranslationTool extends TransformControl
	{
		protected var _gCtrl:GlobalTranslationControl;
		public function get ctrl():GlobalTranslationControl {
			return _gCtrl;
		}
		
		protected var _ctrlStyle:Style = new Style(0, NaN, 0x0066ff, 1, 1);
		public function get ctrlStyle():Style {
			return _ctrlStyle;
		}
		public function set ctrlStyle(val:Style):void {
			_ctrlStyle = val;
			if (_inited) {
				_gCtrl.style = _ctrlStyle;
			}
		}
		
		//mouse cursor
		private var _cursor:DisplayObject;
		public function get cursor():DisplayObject {
			return _cursor;
		}
		public function set cursor(val:DisplayObject):void {
			_cursor = val;
			if (_inited) {
				_gCtrl.setCursor(_cursor);
			}
		}
		
		public override function set target(dp:DisplayObject):void {
			if (!isTargetValid(dp)) {
				return;
			}
			
			super.target = dp;
			
			if (_inited) {
				_gCtrl.skin = _target;
				if(_target){
					var rect:Rectangle = _target.getBounds(_gCtrl);
					_gCtrl.targetRect = rect;
				}
			}
		}
		
		public function GlobalTranslationTool() 
		{
			super();
		}
		
		protected override function onAdded(evt:Event = null):void {
			_gCtrl = new GlobalTranslationControl();
			_gCtrl.style = _ctrlStyle;
			//_gCtrl.mouseEnabled = _gCtrl.mouseChildren = false;
			_ctrls = [_gCtrl];
			
			if(cursor)_gCtrl.setCursor(cursor);
			_root.addChild(_gCtrl);
			
			super.onAdded(evt);
			
			_root.removeChild(_regCtrl);
		}
		
		override protected function onRemoved(evt:Event = null):void {
			super.onRemoved(evt);
			
			_gCtrl.dispose();
			_gCtrl = null;
		}
				
		protected override function updateControls(deltaMX:Matrix3D = null):void {
			super.updateControls(deltaMX);
			
			var rect:Rectangle = _target.getBounds(_gCtrl);
			_gCtrl.targetRect = rect;
		}
	
		protected override function onChangeControlValue(ctrl:DimentionControl):void {
			if (ctrl == _gCtrl) {
				//var focalLen:Number = _target.root.transform.perspectiveProjection.focalLength;
				//var ratio:Number = Math.sin(_target.root.transform.perspectiveProjection.fieldOfView * .5 / Util.RADIAN);
				//var pos:Vector3D = _target.transform.matrix3D.position;
				//ratio = (focalLen + pos.z) / focalLen ;
				
				var mx:Matrix3D = this._originConcatenatedMX.clone();
				mx.appendTranslation(_gCtrl.valueX, _gCtrl.valueY, 0);
				var parentMX:Matrix3D = _originParentConcatenatedMX.clone();
				parentMX.invert();
				mx.append(parentMX);
				_targetMX = mx.clone();
			}
		}
		
	}

}
