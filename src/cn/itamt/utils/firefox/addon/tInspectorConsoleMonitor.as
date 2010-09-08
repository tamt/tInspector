package cn.itamt.utils.firefox.addon {
	import flash.events.Event;
	import flash.system.Capabilities;

	import cn.itamt.utils.Debug;

	import msc.console.mConsoleMonitor;

	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.text.TextField;

	/**
	 * @author itamt[at]qq.com
	 */
	public class tInspectorConsoleMonitor extends Sprite {
		private var monitor : mConsoleMonitor;

		public var tf : TextField;

		public function tInspectorConsoleMonitor() {
			Security.allowDomain("*");			Security.allowInsecureDomain("*");
			
			monitor = new mConsoleMonitor();
			monitor.visible = false;
			monitor.proxy = this;
			addChild(monitor);
			
			this.visible = false;
			
			if(ExternalInterface.available) {
				if(!Capabilities.isDebugger) {
					try {
						Debug.trace('[tInspectorConsoleMonitor]fInspector.setEnable', 3);
						ExternalInterface.call("fInspector.setEnable", false);
					}catch(e : Error) {
					}
					return;
				}
				if(FlashPlayerEnvironment.isInFirefox()) {
					ExternalInterface.addCallback('startInspector', startInspector);
					ExternalInterface.addCallback('stopInspector', stopInspector);					ExternalInterface.addCallback('clearAllConnections', clearAllConnections);
				}
			}
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		public function reloadSwf() : void {
			ExternalInterface.call("fInspector.reloadSwf", false);
		}

		private function onAdded(evt : Event) : void {
			for(var i : int = 0;i < this.stage.numChildren;i++) {
				this.stage.getChildAt(i).visible = false;
			}
		}

		public function startInspector() : void {
			alert('[tInspectorConsoleMonitor][startInspector]');
			monitor.callFun('startInspector');
		}

		public function stopInspector() : void {
			alert('[tInspectorConsoleMonitor][stopInspector]');
			monitor.callFun('stopInspector');
		}

		public function clearAllConnections() : void {
			alert('[tInspectorConsoleMonitor][clearAllConnections]');
			monitor.deconstructAllConnections();
		}

		private function alert(str : String) : void {
			if(tf == null)addChild(tf = new TextField());
			tf.autoSize = 'left';
			tf.text = str;
			
			Debug.trace('[tInspectorConsoleMonitor][alert]' + str);
		}
	}
}
