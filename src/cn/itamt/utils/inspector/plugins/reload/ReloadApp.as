package cn.itamt.utils.inspector.plugins.reload {
	import cn.itamt.utils.firefox.addon.FlashPlayerEnvironment;
	import cn.itamt.utils.inspector.plugins.InspectorPluginId;
	import cn.itamt.utils.inspector.core.IInspector;
	import cn.itamt.utils.inspector.core.BaseInspectorPlugin;

	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;

	/**
	 * @author itamt[at]qq.com
	 */
	public class ReloadApp extends BaseInspectorPlugin {
		public function ReloadApp() {
			super();
		}

		private function onClickReload(event : MouseEvent) : void {
			if(ExternalInterface.available) {
				ExternalInterface.call("fInspectorReloadSwf", FlashPlayerEnvironment.swfId);
			}
		}

		//////////////////////////////////////
		////////////override funcions/////////
		//////////////////////////////////////

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
