package cn.itamt.utils.inspector.core {
	import cn.itamt.utils.Debug;

	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;

	/**
	 * @author itamt[at]qq.com
	 */
	public class InspectorPluginManager extends EventDispatcher implements IInspectorPluginManager {

		/**
		 * store all plugins.
		 */
		private var _plugins : Dictionary;

		/**
		 * store the register order of each plugin in id.
		 */
		private var _pluginOrders : Array;

		private var _pluginList : XML;

		private var _inspector : IInspector;

		public function InspectorPluginManager(inspector : IInspector) {
			super();
			
			this._inspector = inspector;
		}

		/**
		 * 往tInspector註冊一個插件
		 */
		public function registerPlugin(plugin : IInspectorPlugin) : void {
			if(_plugins == null)_plugins = new Dictionary();
			
			if(plugin == null) {
				throw new Error("registerPlugin with a null plugin.");
				return;
			}
			var id : String = plugin.getPluginId();
			if(id == null) {
				throw new Error("registerPlugin:getPluginId() return null");
				return;
			}
			
			//sort order of plugin.
			if(_pluginOrders == null)_pluginOrders = [];
			var i : int = _pluginOrders.indexOf(id);
			if(i >= 0) {
				_pluginOrders.splice(i, 1);
			}
			_pluginOrders.push(id);
			
			//store the plugin to _plugins.
			if(plugin != _plugins[id]) {
				plugin.onRegister(_inspector);
				
				for(var t:String in _plugins) {
					plugin.onRegisterPlugin(t);
				}
				
				_plugins[id] = plugin;
			}
			
			for each(var item:IInspectorPlugin in _plugins) {
				item.onRegisterPlugin(id);
			}
		}

		/**
		 * 删除註冊一個功能模塊
		 */
		public function unregisterPlugin(id : String) : void {
			if(_plugins == null)_plugins = new Dictionary();
			var view : IInspectorPlugin = _plugins[id];
			if(view != null) {		
				view.onUnRegister(this._inspector);
			
				for each(var item:IInspectorPlugin in _plugins) {
					item.onUnRegisterPlugin(id);
				}
			
				delete	_plugins[id];
			}
		}

		/**
		 * 开启Inspector的视图.
		 */
		public function activePlugin(id : String) : void {
			if(_plugins == null)return;
			
			var view : IInspectorPlugin = _plugins[id];
			if(view) {
				if(!view.isActive)view.onActive();
				if(this._inspector.getCurInspectTarget() != null) {
					if(!this._inspector.isLiveInspecting) {
						view.onInspect(this._inspector.getCurInspectTarget());
					} else {
						view.onLiveInspect(this._inspector.getCurInspectTarget());
					}
				}
				for each(var item:IInspectorPlugin in _plugins) {
					item.onActivePlugin(id);
				}
			} else {
				trace(id + '没有注册，不能开启。使用Inspector.registerPlugin来注册功能，然后再调用Inspector.activePlugin');
			}
		}

		/**
		 * 关闭Inspector的视图.
		 */
		public function unactivePlugin(id : String) : void {
			Debug.trace('[Inspector][unactiveView]');
			if(_plugins[id] != null) {
				(_plugins[id] as IInspectorPlugin).onUnActive();
			}
			
			for each(var view:IInspectorPlugin in _plugins) {
				if(view.isActive)view.onUnActivePlugin(id);
			}
		}

		public function togglePluginById(id : String) : void {
			var view : IInspectorPlugin = _plugins[id];
			if(view.isActive) {
				view.onUnActive();
			} else {
				view.onActive();
			}
		}

		public function getPluginById(viewId : String) : IInspectorPlugin {
			if(_plugins == null)return null;
			return _plugins[viewId];
		}

		/**
		 * get all the plugins registered to Inspector.
		 */
		public function getPlugins() : Array {
			var arr : Array = [];
			var ids : Array = getPluginIds();
			for(var i : int = 0;i < ids.length;i++) {
				arr.push(getPluginById(ids[i]));
			}
			
			return arr;
		}

		/**
		 * get all the plugin's id registered to Inspector.
		 */
		public function getPluginIds() : Array {
			return this._pluginOrders.slice();
		}

		/**
		 * load a plugin, and register it to tInspector after load.
		 */
		public function loadPlugin(req : URLRequest) : void {
			Debug.trace('[InspectorPluginManager][loadPlugin]' + req.url);
			var loader : URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.load(req);
			loader.addEventListener(Event.COMPLETE, onPluginBytesLoad);
		}

		public function loadPluginList(req : URLRequest) : void {
			Debug.trace('[InspectorPluginManager][loadPlugin]' + req.url);
			var loader : URLLoader = new URLLoader();
			loader.load(req);
			loader.addEventListener(Event.COMPLETE, onPluginListLoad);
		}

		//////////////////////////////////////
		//////////private functions///////////
		//////////////////////////////////////

		private function onPluginListLoad(event : Event) : void {
			_pluginList = new XML((event.target as URLLoader).data); 
		}

		private function onPluginBytesLoad(event : Event) : void {
			var loader : Loader = new Loader();
			loader.loadBytes((event.target as URLLoader).data, new LoaderContext(false, new ApplicationDomain(ApplicationDomain.currentDomain)));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPluginLoad);
		}

		private function onPluginLoad(evt : Event) : void {
			var loaderInfo : LoaderInfo = evt.target as LoaderInfo;
			if(loaderInfo.content is IInspectorPlugin) {
				var plugin : IInspectorPlugin = loaderInfo.content as IInspectorPlugin;
				this.registerPlugin(plugin);
			} else {
				Debug.trace('[InspectorPluginManager][onPluginLoad]' + loaderInfo.url + ' is NOT an IInspectorPlugin.');
			}
		}
	}
}
