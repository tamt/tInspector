package cn.itamt.utils.inspector.plugins.fullscreen {
	import cn.itamt.utils.inspector.consts.InspectorPluginId;
	import cn.itamt.utils.inspector.interfaces.IInspector;
	import cn.itamt.utils.inspector.ui.BaseInspectorPlugin;

	import flash.display.StageDisplayState;
	import flash.events.FullScreenEvent;

	/**
	 * @author itamt[at]qq.com
	 */
	public class FullScreen extends BaseInspectorPlugin {
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

		//////////////////////////////////////
		////////////override funcions/////////
		//////////////////////////////////////
		override public function onRegister(inspector : IInspector) : void {
			super.onRegister(inspector);
			
			_icon = new FullScreenButton();
		}

		override public function onUnRegister(inspector : IInspector) : void {
			super.onUnRegister(inspector);
		}

		override public function onTurnOn() : void {
			super.onTurnOn();
			
			if(_inspector.stage.displayState == StageDisplayState.FULL_SCREEN)onActive();
			_inspector.stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
		}

		override public function onTurnOff() : void {
			super.onTurnOff();
			_inspector.stage.removeEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
		}

		override public function onActive() : void {
			super.onActive();
			
			if(_inspector.stage.displayState != StageDisplayState.FULL_SCREEN) {
				_inspector.stage.displayState = StageDisplayState.FULL_SCREEN;
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
