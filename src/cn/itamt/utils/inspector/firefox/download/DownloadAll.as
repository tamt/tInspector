package cn.itamt.utils.inspector.firefox.download {
	import cn.itamt.utils.inspector.core.IInspector;
	import cn.itamt.utils.inspector.core.IInspectorPlugin;
	import cn.itamt.utils.inspector.core.InspectTarget;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.system.Security;

	/**
	 * @author itamt[at]qq.com
	 */
	public class DownloadAll extends Sprite implements IInspectorPlugin {

		private var _actived : Boolean;
		private var _icon : DownloadAllButton;

		public function DownloadAll() {
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
		}

		//////////////////////////////////////
		///////实现接口：IInspectorPlugin//////
		//////////////////////////////////////

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

		override public function contains(child : DisplayObject) : Boolean {
			return super.contains(child);
		}

		public function onRegister(inspector : IInspector) : void {
		}

		public function onUnRegister(inspector : IInspector) : void {
		}

		public function onRegisterPlugin(pluginId : String) : void {
		}

		public function onUnRegisterPlugin(pluginId : String) : void {
		}

		public function onActive() : void {
			_actived = true;
		}

		public function onUnActive() : void {
			_actived = false;
		}

		public function onTurnOn() : void {
		}

		public function onTurnOff() : void {
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
	}
}
