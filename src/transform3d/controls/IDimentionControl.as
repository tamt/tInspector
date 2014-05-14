package transform3d.controls 
{
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author tamt
	 */
	public interface IDimentionControl 
	{
		function get value():Number;
		function get actived():Boolean;
		function get shape():DisplayObject;
		
		function set style(val:Style):void;
		function get style():Style;
		
		function set mode(val:uint):void;
		function get mode():uint;
		
		function set skin(val:DisplayObject):void;
		function get skin():DisplayObject;
		
		function setCursor(dp:DisplayObject):void;
		
		function set alpha(val:Number):void;
		function get alpha():Number;
	
		function set name(val:String):void;
		function get name():String;
	}
}