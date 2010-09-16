package com.wispagency.display
{
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.utils.ByteArray;
	import com.wispagency.display.Loader;
	import flash.display.Loader
	import flash.system.ApplicationDomain;
	import flash.display.DisplayObject;
	
	
	/**
	 * ...
	 * @author Aleksandar Andreev
	 * @version 1.2
	 */
	public class LoaderInfo extends EventDispatcher 
	{
		protected var urlLoader:URLLoader;
		
		protected var displayLoader:flash.display.Loader;
		
		protected var parentLoader:com.wispagency.display.Loader;
		
		protected var commObject:Object;
		
		public function LoaderInfo(parentLoaderReference:com.wispagency.display.Loader, urlLoaderReference:URLLoader, displayLoaderReference:flash.display.Loader, commObjectReference:Object) {
			parentLoader = parentLoaderReference;
			urlLoader = urlLoaderReference;
			displayLoader = displayLoaderReference;
			commObject = commObjectReference;
		}
		
		override public function toString():String 
		{
			return '[Object Wisp LoaderInfo]';
		}
		
		override public function dispatchEvent(event:Event):Boolean 
		{
			return super.dispatchEvent(event);
		}
		
		/**
		 * The ActionScript version of the loaded SWF file.
		 *  The language version is specified by using the enumerations in the
		 *  ActionScriptVersion class, such as ActionScriptVersion.ACTIONSCRIPT2
		 *  and ActionScriptVersion.ACTIONSCRIPT3.
		 */
		public function get actionScriptVersion():uint {
			return displayLoader.contentLoaderInfo.actionScriptVersion;
		}
		
		/**
		 * When an external SWF file is loaded, all ActionScript 3.0 definitions contained in the loaded
		 *  class are stored in the applicationDomain property.
		 */
		public function get applicationDomain():ApplicationDomain {
			return displayLoader.contentLoaderInfo.applicationDomain;
		}
		
		/**
		 * The bytes associated with a LoaderInfo object.
		 */
		public function get bytes():ByteArray {
			return displayLoader.contentLoaderInfo['bytes'];
		}
		
		/**
		 * The number of bytes that are loaded for the media. When this number equals
		 *  the value of bytesTotal, all of the bytes are loaded.
		 */
		public function get bytesLoaded():uint {
			return displayLoader.contentLoaderInfo.bytesLoaded;
		}
		
		
		/**
		 * The number of compressed bytes in the entire media file.
		 */
		public function get bytesTotal():uint {
			return displayLoader.contentLoaderInfo.bytesTotal;
		}
		
		/**
		 * Expresses the trust relationship from content (child) to the Loader (parent).
		 *  If the child has allowed the parent access, true; otherwise,
		 *  false. This property is set to true if the child object
		 *  has called the allowDomain() method to grant permission to the parent domain
		 *  or if a cross-domain policy is loaded at the child domain that grants permission
		 *  to the parent domain. If child and parent are in
		 *  the same domain, this property is set to true.
		 */
		public function get childAllowsParent():Boolean {
			return displayLoader.contentLoaderInfo.childAllowsParent
		}
		
		/**
		 * A object that can be set by the loaded content's code to expose properties and methods that can be accessed
		 *  by code in the Loader object's sandbox. This sandbox bridge lets content from a non-application domain have
		 *  controlled access to scripts in the AIR application sandbox, and vice versa. The sandbox bridge serves as a gateway between
		 *  the sandboxes, providing explicit interaction between application and non-application security sandboxes.
		 */
		public function get childSandboxBridge():Object {
			return displayLoader.contentLoaderInfo['childSandboxBridge'];
		}
		public function set childSandboxBridge(value:Object):void {
			displayLoader.contentLoaderInfo['childSandboxBridge'] = value;
		}
		
		
		/**
		 * The loaded object associated with this LoaderInfo object.
		 */
		public function get content():DisplayObject {
			return displayLoader.contentLoaderInfo.content;
		}
		/**
		 * The MIME type of the loaded file. The value is null if not enough of the file has loaded
		 *  in order to determine the type. The following list gives the possible values:
		 *  "application/x-shockwave-flash"
		 *  "image/jpeg"
		 *  "image/gif"
		 *  "image/png"
		 */
		public function get contentType():String {
			return displayLoader.contentLoaderInfo.contentType;
		}
		/**
		 * The nominal frame rate, in frames per second, of the loaded SWF file. This
		 *  number is often an integer, but need not be.
		 */
		public function get frameRate():Number {
			return displayLoader.contentLoaderInfo.frameRate;
		}
		/**
		 * The nominal height of the loaded file. This value might differ from the actual
		 *  height at which the content is displayed, since the loaded content or its parent
		 *  display objects might be scaled.
		 */
		public function get height():int {
			return displayLoader.contentLoaderInfo.height;
		}
		
		/**
		 * The Loader object associated with this LoaderInfo object. If this LoaderInfo object
		 *  is the loaderInfo property of the instance of the main class of the SWF file, no
		 *  Loader object is associated.
		 */
		
		public function get loader():com.wispagency.display.Loader {
			return parentLoader;
		}
		
		/**
		 * The URL of the SWF file that initiated the loading of the media
		 *  described by this LoaderInfo object.  For the instance of the main class of the SWF file, this
		 *  URL is the same as the SWF file's own URL.
		 */
		public function get loaderURL():String {
			return displayLoader.contentLoaderInfo.loaderURL;
		}
		/**
		 * An object that contains name-value pairs that represent the parameters provided
		 *  to the loaded SWF file.
		 */
		public function get parameters():Object {
			return displayLoader.contentLoaderInfo.parameters;
		}
		/**
		 * Expresses the trust relationship from Loader (parent) to the content (child).
		 *  If the parent has allowed the child access, true; otherwise,
		 *  false. This property is set to true if the parent object
		 *  called the allowDomain() method to grant permission to the child domain
		 *  or if a cross-domain policy file is loaded at the parent domain granting permission
		 *  to the child domain. If child and parent are in
		 *  the same domain, this property is set to true.
		 */
		public function get parentAllowsChild():Boolean {
			return displayLoader.contentLoaderInfo.parentAllowsChild;
		}
		
		/**
		 * A object that can be set by code in the Loader object's sandbox to expose properties and methods that can be accessed
		 *  by the loaded content's code. This sandbox bridge lets content from a non-application domain have controlled
		 *  access to scripts in the AIR application sandbox, and vice versa. The sandbox bridge serves as a gateway between
		 *  the sandboxes, providing explicit interaction between application and non-application security sandboxes.
		 */
		public function get parentSandboxBridge():Object {
			return displayLoader.contentLoaderInfo['parentSandboxBridge'];
		}
		public function set parentSandboxBridge(value:Object):void {
			displayLoader.contentLoaderInfo['parentSandboxBridge'] = value;
		}
		
		/**
		 * Expresses the domain relationship between the loader and the content: true if they have
		 *  the same origin domain; false otherwise.
		 */
		public function get sameDomain():Boolean {
			return displayLoader.contentLoaderInfo.sameDomain;
		}
		
		/**
		 * An EventDispatcher instance that can be used to exchange events across security boundaries.
		 *  Even when the Loader object and the loaded content originate from security domains that do not trust
		 *  one another, both can access sharedEvents and send and receive events via this object.
		 */
		public function get sharedEvents():EventDispatcher {
			return displayLoader.contentLoaderInfo.sharedEvents;
		}
		/**
		 * The file format version of the loaded SWF file.
		 *  The file format is specified using the enumerations in the
		 *  SWFVersion class, such as SWFVersion.FLASH7 and SWFVersion.FLASH9.
		 */
		public function get swfVersion():uint {
			return displayLoader.contentLoaderInfo.swfVersion;
		}
		/**
		 * The URL of the media being loaded.
		 */
		public function get url():String {
			return commObject.url;
		}
		
		/**
		 * The nominal width of the loaded content. This value might differ from the actual
		 *  width at which the content is displayed, since the loaded content or its parent
		 *  display objects might be scaled.
		 */
		public function get width():int {
			return displayLoader.contentLoaderInfo.width;
		}
		/**
		 * Returns the LoaderInfo object associated with a SWF file defined as an object.
		 *
		 * @param object            <Object> The object for which you want to get an associated LoaderInfo object.
		 * @return                  <LoaderInfo> The associated LoaderInfo object. Returns null when called
		 *                            in non-debugger builds (or when debugging is not enabled) or if the referenced object
		 *                            does not have an associated LoaderInfo object (such as some objects used by the AIR runtime).
		 */
		public static function getLoaderInfoByDefinition(object:Object):LoaderInfo {
			return flash.display.Loader['getLoaderInfoByDefinition'](object);
		}
		
	}
	
}