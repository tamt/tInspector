package com.wispagency.display {
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	/**
	 * ...
	 * @author Aleksandar Andreev
	 * @version 1.2
	 */
	public class Loader extends Sprite {

		private var realLoader : flash.display.Loader;
		private var loaderContext : LoaderContext = null;
		private var loader : URLLoader;
		private var loaderInfoReference : LoaderInfo;
		private var commObject : Object = { url:''};

		
		/**
		 * Contains the root display object of the SWF file or image (JPG, PNG, or GIF)
		 *  file that was loaded by using the load() or loadBytes() methods.
		 */
		public function get content() : DisplayObject {
			return realLoader.content;
		}

		/**
		 * Returns a LoaderInfo object corresponding to the object being loaded. LoaderInfo objects
		 *  are shared between the Loader object and the loaded content object. The LoaderInfo object
		 *  supplies loading progress information and statistics about the loaded file.
		 */
		public function get contentLoaderInfo() : LoaderInfo {
			return loaderInfoReference;
		}

		/**
		 * Creates a Loader object that you can use to load files, such as SWF, JPEG, GIF, or PNG files.
		 *  Call the load() method to load the asset as a child of the Loader instance.
		 *  You can then add the Loader object to the display list (for instance, by using the
		 *  addChild() method of a DisplayObjectContainer instance).
		 *  The asset appears on the Stage as it loads.
		 */
		public function Loader() {
			loader = new URLLoader();
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHttpStatus)
			loader.addEventListener(Event.COMPLETE, handleLoadComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handleURLLoadError);
			loader.addEventListener(ProgressEvent.PROGRESS, handleProgress)
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError)
			loader.dataFormat = URLLoaderDataFormat.BINARY;	
			
			
			realLoader = new flash.display.Loader();
			realLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoaderComplete)
			realLoader.contentLoaderInfo.addEventListener(Event.UNLOAD, handleUnload)
			realLoader.addEventListener(Event.INIT, handleInit)
			
			loaderInfoReference = new LoaderInfo(this, loader, realLoader, commObject)
			addChild(realLoader)
		}

		private function handleUnload(event : Event) : void {
			loaderInfoReference.dispatchEvent(event);
		}

		private function handleSecurityError(event : Event) : void {
			loaderInfoReference.dispatchEvent(event);
		}

		private function handleInit(event : Event) : void {
			loaderInfoReference.dispatchEvent(event);
		}

		private function handleLoaderComplete(event : Event) : void {
			loaderInfoReference.dispatchEvent(event);
		}

		/**
		 * Cancels a load() method operation that is currently in progress for the Loader instance.
		 */
		public function close() : void {
			commObject.url = '';
			loader.close();
			realLoader.close()
		}

		/**
		 * Loads a SWF, JPEG, progressive JPEG, unanimated GIF, or PNG file into an object that is a child of
		 *  this Loader object. If you load an animated GIF file, only the first frame is displayed.
		 *  As the Loader object can contain only a single child, issuing a subsequent load()
		 *  request terminates the previous request, if still pending, and commences a new load.
		 *
		 * @param request           <URLRequest> The absolute or relative URL of the SWF, JPEG, GIF, or PNG file to be loaded. A
		 *                            relative path must be relative to the main SWF file. Absolute URLs must include the
		 *                            protocol reference, such as http:// or file:///. Filenames cannot include disk drive
		 *                            specifications.
		 * @param context           <LoaderContext (default = null)> A LoaderContext object, which has properties that define the following:
		 *                            Whether or not to check for the existence of a policy file
		 *                            upon loading the object
		 *                            The ApplicationDomain for the loaded object
		 *                            The SecurityDomain for the loaded object
		 *                            For complete details, see the description of the properties in the
		 *                            LoaderContext class.
		 */
		public function load(request : URLRequest, context : LoaderContext = null) : void {
			loaderContext = context;
			commObject.url = request.url;
			loader.load(request);
		}

		
		private function handleProgress(event : ProgressEvent) : void {
			//trace('handleProgress ' + event);
			loaderInfoReference.dispatchEvent(event)
		}

		private function handleHttpStatus(event : HTTPStatusEvent) : void {
			contentLoaderInfo.dispatchEvent(event)
		}

		private function handleURLLoadError(event : IOErrorEvent) : void {
			//trace("URLLoader: " + event.text);
			loaderInfo.dispatchEvent(event);
		}		

		private function handleLoadComplete(event : Event) : void {
			realLoader.loadBytes(loader.data, loaderContext)
		}

		/**
		 * Loads from binary data stored in a ByteArray object.
		 *
		 * @param bytes             <ByteArray> A ByteArray object. The contents of the ByteArray can be
		 *                            any of the file formats supported by the Loader class: SWF, GIF, JPEG, or PNG.
		 * @param context           <LoaderContext (default = null)> A LoaderContext object. Only the applicationDomain property
		 *                            of the LoaderContext object applies{} the checkPolicyFile and securityDomain
		 *                            properties of the LoaderContext object do not apply.
		 */
		public function loadBytes(bytes : ByteArray, context : LoaderContext = null) : void {
			loaderContext = context;
			commObject.url = ''
		}

		/**
		 * Removes a child of this Loader object that was loaded by using the load() method.
		 *  The property of the associated LoaderInfo object is reset to null.
		 *  The child is not necessarily destroyed because other objects might have references to it{} however,
		 *  it is no longer a child of the Loader object.
		 */
		public function unload() : void {
			commObject.url = '';
			close()
			realLoader.unload()
		}

		override public function toString() : String {
			return '[Instance Of Wisp Loader]';
		}
	}
}