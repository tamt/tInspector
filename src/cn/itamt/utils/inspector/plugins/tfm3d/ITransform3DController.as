package cn.itamt.utils.inspector.plugins.tfm3d 
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix;
	import transform3d.toolbar.IDisplayObject;
	
	/**
	 * ...
	 * @author tamt
	 */
	public interface ITransform3DController extends IDisplayObject, IEventDispatcher
	{		
		function get target():DisplayObject;
		
		function set target(value:DisplayObject):void ;
		
		function convertMX3DtoMX(mx3d:*):Matrix;
	}
	
}