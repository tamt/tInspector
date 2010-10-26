package cn.itamt.utils.inspector.plugins.fullscreen {
	import cn.itamt.utils.Debug;
	import cn.itamt.utils.inspector.core.BaseInspectorPlugin;
	import cn.itamt.utils.inspector.core.IInspector;
	import cn.itamt.utils.inspector.firefox.FlashPlayerEnvironment;
	import cn.itamt.utils.inspector.plugins.InspectorPluginId;

	import msc.console.mConsole;

	import flash.display.StageDisplayState;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;

	/**
	 * @author itamt[at]qq.com
	 */
	public class FullScreen extends BaseInspectorPlugin {
		private var _fullScreenByMe : Boolean = false;

		public function FullScreen() {
			super();
		}

		private function onFullScreen(event : FullScreenEvent) : void {
			if(event.fullScreen) {
				super.onActive();
			} else {
				super.onUnActive();
			}
		}

		// // // // // // // // //////////////////////
		// // // // // //      override     funcions/////////
		// // // // // // // // //////////////////////
		override public function onRegister(inspector : IInspector) : void {
			super.onRegister(inspector);

			_icon = new FullScreenButton();
		}

		override public function onUnRegister(inspector : IInspector) : void {
			super.onUnRegister(inspector);
		}

		override public function onTurnOn() : void {
			super.onTurnOn();

			if(_inspector.stage.displayState == StageDisplayState.FULL_SCREEN)
				onActive();
			_inspector.stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
		}

		override public function onTurnOff() : void {
			_isOn = false;

			if(_icon) {
				_icon.removeEventListener(MouseEvent.CLICK, onClickPluginIcon);
			}

			if(_actived && _fullScreenByMe)
				onUnActive();

			_inspector.stage.removeEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
		}

		override public function onActive() : void {
			super.onActive();

			if(_inspector.stage.displayState != StageDisplayState.FULL_SCREEN) {
				_fullScreenByMe = true;
				try {
					_inspector.stage.displayState = StageDisplayState.FULL_SCREEN;
				} catch(e : Error) {
					Debug.trace('[FullScreen][onActive]error when full screen');
					// ExternalInterface.call("fInspector.showFullScreenGuide", FlashPlayerEnvironment.swfId);
					mConsole.callMonitorProxyFun("showFullScreenGuide", FlashPlayerEnvironment.swfId);
				}
			}
		}

		override public function onUnActive() : void {
			super.onUnActive();

			if(_inspector.stage.displayState == StageDisplayState.FULL_SCREEN) {
				_inspector.stage.displayState = StageDisplayState.NORMAL;
			}
		}

		/**
		 * get this plugin's id
		 */
		override public function getPluginId() : String {
			return InspectorPluginId.FULL_SCREEN;
		}
	}
}
