package cn.itamt.utils.inspector.firefox.download {
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import cn.itamt.utils.inspector.core.IInspector;
	import cn.itamt.utils.inspector.core.IInspectorPlugin;
	import cn.itamt.utils.inspector.core.InspectTarget;
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.popup.InspectorPopupManager;
	import cn.itamt.utils.inspector.popup.PopupAlignMode;

	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Security;

	/**
	 * @author itamt[at]qq.com
	 */
	public class DownloadAll implements IInspectorPlugin {
		private var _actived : Boolean;
		private var _icon : DownloadAllButton;
		private var _inspector : IInspector;
		private var _panel : DownloadAllPanel;
		private var _loadeds : Array;

		public function DownloadAll() {
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
		}

		// // // // // ////////////////////////////
		// // //   /实现接口：IInspectorPlugin//////
		// // // // // ////////////////////////////
		public function getPluginId() : String {
			return "DownloadAll";
		}

		public function getPluginIcon() : DisplayObject {
			if(_icon == null) {
				_icon = new DownloadAllButton();
			}
			return _icon;
		}

		public function getPluginVersion() : String {
			return "1.0";
		}

		public function getPluginName(lang : String) : String {
			if(lang == "cn") {
				return "下载";
			} else {
				return "download";
			}
		}

		public function contains(child : DisplayObject) : Boolean {
			return this._panel && this._panel.contains(child);
		}

		public function onRegister(inspector : IInspector) : void {
			_inspector = inspector;
			if(_inspector.root) {
				if(this._loadeds == null) {
					this._loadeds = new Array();
					this._loadeds.push(new LoadedStuffInfo(_inspector.root.loaderInfo.url, _inspector.root.loaderInfo.contentType));
				}
				_inspector.root.addEventListener("allComplete", allCompleteHandler);
			}
		}

		public function onUnRegister(inspector : IInspector) : void {
			this._loadeds = null;
		}

		public function onRegisterPlugin(pluginId : String) : void {
		}

		public function onUnRegisterPlugin(pluginId : String) : void {
		}

		public function onActive() : void {
			_actived = true;
			this._icon.active = true;

			_panel = new DownloadAllPanel(InspectorLanguageManager.getStr("DownloadAll"));
			_panel.setData(this._loadeds);
			_panel.addEventListener(Event.CLOSE, unactiveThisPlugin);
			_panel.addEventListener("clear", onClickClear);
			_panel.addEventListener(MouseEvent.CLICK, onClickLoadedItem);
			InspectorPopupManager.popup(_panel, PopupAlignMode.CENTER);
		}

		public function onUnActive() : void {
			_actived = false;
			this._icon.active = false;

			_panel.removeEventListener(Event.CLOSE, unactiveThisPlugin);
			_panel.removeEventListener("clear", onClickClear);
			InspectorPopupManager.remove(_panel);
		}

		public function onTurnOn() : void {
			if(this._icon) {
				this._icon.addEventListener(MouseEvent.CLICK, toggleThisPlugin);
			}
		}

		public function onTurnOff() : void {
			if(this._icon) {
				this._icon.removeEventListener(MouseEvent.CLICK, toggleThisPlugin);
			}
		}

		public function onInspect(target : InspectTarget) : void {
		}

		public function onLiveInspect(target : InspectTarget) : void {
		}

		public function onStopLiveInspect() : void {
		}

		public function onStartLiveInspect() : void {
		}

		public function onUpdate(target : InspectTarget = null) : void {
		}

		public function onInspectMode(clazz : Class) : void {
		}

		public function onActivePlugin(pluginId : String) : void {
		}

		public function onUnActivePlugin(pluginId : String) : void {
		}

		public function get isActive() : Boolean {
			return _actived;
		}

		//
		//
		//
		private function toggleThisPlugin(event : MouseEvent) : void {
			if(this.isActive) {
				this._inspector.pluginManager.unactivePlugin(this.getPluginId());
			} else {
				this._inspector.pluginManager.activePlugin(this.getPluginId());
			}
		}

		private function unactiveThisPlugin(event : Event) : void {
			this._inspector.pluginManager.unactivePlugin(this.getPluginId());
		}

		private function onClickClear(event : Event) : void {
			this._loadeds = null;
			if(this._panel) {
				this._panel.update();
			}
		}

		private function allCompleteHandler(evt : Event) : void {
			var loaderInfo : LoaderInfo = evt.target as LoaderInfo;
			if(loaderInfo) {
				if(loaderInfo.url) {
					for each (var stuff : LoadedStuffInfo in this._loadeds) {
						if(stuff.url == loaderInfo.url && stuff.contentType == loaderInfo.contentType) {
							return;
						}
					}

					this._loadeds.push(new LoadedStuffInfo(loaderInfo.url, loaderInfo.contentType));
					if(this._panel)
						this._panel.update();
				}
			}
		}

		private function onClickLoadedItem(event : MouseEvent) : void {
			if(event.target is LoadedStuffItemRenderer){
				var stuff:LoadedStuffInfo = (event.target as LoadedStuffItemRenderer).data as LoadedStuffInfo;
				// navigateToURL(new URLRequest(stuff.url), "_blank");
				this.popupLoadedStuffInfoPanel(stuff);
			}
		}
		
		private function popupLoadedStuffInfoPanel(info:LoadedStuffInfo):void{
			//
		}
	}
}
