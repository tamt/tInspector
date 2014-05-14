package transform3d.toolbar 
{
	import flash.accessibility.AccessibilityProperties;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;


	/**
	 *
	 *  An interface that represents a DisplayObject.
	 *	
	 *	IMPORTANT: This interface should NEVER appear in any API!! It only
	 *	exists to be extended by other interfaces so that when you try to
	 *	access (for example) ScrollPane.x, you won't get an error.
	 *
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author     Matthew Tretter (matthew@exanimo.com)
	 *	@version    2008.01.17
	 *
	 */
	public interface IDisplayObject extends IEventDispatcher
	{
		//
		// accessors
		//


		/**
		 * @copy flash.display.DisplayObject#accessibilityProperties	 
		 */		 		 		
		function get accessibilityProperties():AccessibilityProperties;
		/**
		 * @private
		 */		 		
		function set accessibilityProperties(accessibilityProperties:AccessibilityProperties):void;


		/**
		 * @copy flash.display.DisplayObject#alpha	 
		 */	
		function get alpha():Number;
		/**
		 * @private
		 */	
		function set alpha(alpha:Number):void;
		
		
		/**
		 * @copy flash.display.DisplayObject#blendMode	 
		 */	
		function get blendMode():String;
		/**
		 * @private
		 */	
		function set blendMode(blendMode:String):void;
		
		
		/**
		 * @copy flash.display.DisplayObject#cacheAsBitmap	 
		 */	
		function get cacheAsBitmap():Boolean;
		/**
		 * @private
		 */	
		function set cacheAsBitmap(cacheAsBitmap:Boolean):void;
		
		
		/**
		 * @copy flash.display.DisplayObject#filters	 
		 */	
		function get filters():Array;
		/**
		 * @private
		 */	
		function set filters(filters:Array):void;
		
		
		/**
		 * @copy flash.display.DisplayObject#height	 
		 */	
		function get height():Number;
		/**
		 * @private
		 */	
		function set height(height:Number):void;
		
		
		/**
		 * @copy flash.display.DisplayObject#loaderInfo	 
		 */	
		function get loaderInfo():LoaderInfo;
		
		
		/**
		 * @copy flash.display.DisplayObject#mask	 
		 */	
		function get mask():DisplayObject;
		/**
		 * @private
		 */	
		function set mask(mask:DisplayObject):void;
		
		
		/**
		 * @copy flash.display.DisplayObject#mouseX	 
		 */	
		function get mouseX():Number;
		
		
		/**
		 * @copy flash.display.DisplayObject#mouseY	 
		 */	
		function get mouseY():Number;
		

		/**
		 * @copy flash.display.DisplayObject#name	 
		 */	
		function get name():String;
		/**
		 * @private
		 */	
		function set name(name:String):void;
		
		
		/**
		 * @copy flash.display.DisplayObject#opaqueBackground	 
		 */	
		function get opaqueBackground():Object;
		/**
		 * @private
		 */	
		function set opaqueBackground(opaqueBackground:Object):void;
		
		
		/**
		 * @copy flash.display.DisplayObject#parent	 
		 */	
		function get parent():DisplayObjectContainer;
		
		
		/**
		 * @copy flash.display.DisplayObject#root	 
		 */	
		function get root():DisplayObject;
		
		
		/**
		 * @copy flash.display.DisplayObject#rotation	 
		 */	
		function get rotation():Number;
		/**
		 * @private
		 */	
		function set rotation(rotation:Number):void;
		
		
		/**
		 * @copy flash.display.DisplayObject#scale9Grid	 
		 */	
		function get scale9Grid():Rectangle;
		/**
		 * @private
		 */	
		function set scale9Grid(scale9Grid:Rectangle):void;
		
		
		/**
		 * @copy flash.display.DisplayObject#scaleX	 
		 */	
		function get scaleX():Number;
		/**
		 * @private
		 */	
		function set scaleX(scaleX:Number):void;
		
		
		/**
		 * @copy flash.display.DisplayObject#scaleY	 
		 */	
		function get scaleY():Number;
		/**
		 * @private
		 */	
		function set scaleY(scaleY:Number):void;
		
		
		/**
		 * @copy flash.display.DisplayObject#scrollRect	 
		 */	
		function get scrollRect():Rectangle;
		/**
		 * @private
		 */	
		function set scrollRect(scrollRect:Rectangle):void;
		
		
		/**
		 * @copy flash.display.DisplayObject#stage	 
		 */	
		function get stage():Stage;
		
		
		/**
		 * @copy flash.display.DisplayObject#transform	 
		 */	
		function get transform():Transform;
		/**
		 * @private
		 */	
		function set transform(transform:Transform):void;


		/**
		 * @copy flash.display.DisplayObject#visible	 
		 */	
		function get visible():Boolean;
		/**
		 * @private
		 */	
		function set visible(visible:Boolean):void;


		/**
		 * @copy flash.display.DisplayObject#width	 
		 */	
		function get width():Number;
		/**
		 * @private
		 */	
		function set width(width:Number):void;
		
		
		/**
		 * @copy flash.display.DisplayObject#x	 
		 */	
		function get x():Number;
		/**
		 * @private
		 */	
		function set x(x:Number):void;
		
		
		/**
		 * @copy flash.display.DisplayObject#y	 
		 */	
		function get y():Number;
		/**
		 * @private
		 */	
		function set y(y:Number):void;




		//
		// methods
		//


		/**
		 * @copy flash.display.DisplayObject#getBounds()	 
		 */	
		function getBounds(targetCoordinateSpace:DisplayObject):Rectangle;


		/**
		 * @copy flash.display.DisplayObject#getRect()	 
		 */	
		function getRect(targetCoordinateSpace:DisplayObject):Rectangle;
		
		
		/**
		 * @copy flash.display.DisplayObject#globalToLocal()	 
		 */	
		function globalToLocal(point:Point):Point;
		
		
		/**
		 * @copy flash.display.DisplayObject#hitTestObject()	 
		 */	
		function hitTestObject(obj:DisplayObject):Boolean;


		/**
		 * @copy flash.display.DisplayObject#hitTestPoint()	 
		 */	
		function hitTestPoint(x:Number, y:Number, shapeFlag:Boolean = false):Boolean;
		
		
		/**
		 * @copy flash.display.DisplayObject#localToGlobal()	 
		 */	
		function localToGlobal(point:Point):Point;
	}
	
}