package cn.itamt.utils.inspector.firefox.reloadapp {
	import cn.itamt.utils.inspector.core.BaseInspectorPlugin;
	import cn.itamt.utils.inspector.core.IInspector;
	import cn.itamt.utils.inspector.firefox.FlashPlayerEnvironment;
	import cn.itamt.utils.inspector.plugins.InspectorPluginId;

	import msc.console.mConsoleClient;

	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;

	/**
	 * TODO:ReloadApp可以通过ConsoleMonitor根据swf的url地址来实现.
	 * @author itamt[at]qq.com
	 */
	public class ReloadApp extends BaseInspectorPlugin {
		public function ReloadApp() {
			super();
		}

		private function onClickReload(event : MouseEvent) : void {
			if(ExternalInterface.available) {
				if(FlashPlayerEnvironment.swfId) {
					//ExternalInterface.call("fInspectorReloadSwf", FlashPlayerEnvironment.swfId);
					mConsoleClient.callMonitorProxyFun("reloadSwf", FlashPlayerEnvironment.swfId);
				} else {
					mConsoleClient.callMonitorProxyFun("reloadSwfByUrl", FlashPlayerEnvironment.url);
				}
			}
		}

		// // // ////////////////////////////////
		// // // //////override  funcions/////////
		// // // ////////////////////////////////
		override public function onRegister(inspector : IInspector) : void {
			super.onRegister(inspector);

			_icon = new ReloadButton();
		}

		override public function onUnRegister(inspector : IInspector) : void {
			super.onUnRegister(inspector);
		}

		override public function onTurnOn() : void {
			super.onTurnOn();
			_icon.addEventListener(MouseEvent.CLICK, onClickReload);
		}

		override public function onTurnOff() : void {
			_icon.removeEventListener(MouseEvent.CLICK, onClickReload);
			super.onTurnOff();
		}

		/**
		 * get this plugin's id
		 */
		override public function getPluginId() : String {
			return InspectorPluginId.RELOAD_APP;
		}
	}
}
