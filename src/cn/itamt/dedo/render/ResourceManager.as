package cn.itamt.dedo.render {
	import cn.itamt.dedo.manager.TilesManager;
	import cn.itamt.utils.DisplayObjectTool;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	/**
	 * @author itamt[at]qq.com
	 */
	public class ResourceManager {
		private var resources : Dictionary;
		private var listeners : Dictionary;

		public function ResourceManager():void {
			resources = new Dictionary();
			listeners = new Dictionary();
		}

		public function getTilesImage(tiles : TilesManager):BitmapData {
			var img : BitmapData;
			if(!resources[tiles.images.fileName]) {
				var loader : Loader = new Loader();
				loader.load(new URLRequest(tiles.images.fileName));
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(evt : Event):void {
					loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, arguments.callee);
					if(listeners[tiles.images.fileName]) {
						DisplayObjectTool.callLater(listeners[tiles.images.fileName]);
						delete listeners[tiles.images.fileName];
					}
					resources[tiles.images.fileName] = ((evt.target as LoaderInfo).content as Bitmap).bitmapData;
				});
			} else {
				img = resources[tiles.images.fileName];
			}
			return img;
		}

		/**
		 * listen one resource's load event.
		 */
		public function listenLoad(fileName : String, callback : Function) : void {
			if(listeners[fileName] != callback) {
				listeners[fileName] = callback;
			}
		}

		/**
		 * 设置某一格的位置数据
		 */
		public function setTilesImage(fileName : String, bmd : BitmapData):void {
			if(resources[fileName]) {
				delete resources[fileName];
			}
			resources[fileName] = bmd;
		}
	}
}
