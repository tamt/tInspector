package transform3d.controls 
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	
	/**
	 * interface of TransformControl
	 * @author tamt
	 */
	public interface ITransformControl 
	{
		/**
		 * transform mode of control
		 */
		function get mode():uint;
		function set mode(val:uint):void;
		
		/**
		 * transform target of control
		 */
		function get target():DisplayObject;
		function set target(val:DisplayObject):void;
		
		/**
		 * target's registartion relatie to Stage
		 */
		function get registration():Point;
		function set registration(pt:Point):void;
		
		/**
		 * target's registartion
		 */
		function get innerReg():Vector3D;
		function set innerReg(val:Vector3D):void;
		
		/**
		 * is target valid
		 * @param	target
		 * @return
		 */
		function isTargetValid(target:DisplayObject):Boolean;
		
		/**
		 * update control,(redraw, recaculate transform matrix)
		 * @param	concatenatedMX 		concatenated matrix3d of target
		 * @param	controlMX			matrix3d of control
		 * @param	deltaMX				delta matrix3d of target(doesn't include translation data)
		 */
		function update(concatenatedMX:Matrix3D = null, controlMX:Matrix3D = null, deltaMX:Matrix3D = null):void;
	}
	
}
