package cn.itamt.utils.firefox.addon {
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
			addChild(monitor);
			
			this.visible = false;
			
			if(ExternalInterface.available) {
				if(!Capabilities.isDebugger) {
					try {
						ExternalInterface.call("showNeedDebuggerFP");
					}catch(e : Error) {
					}
					return;
				}
				if(FlashPlayerEnvironment.isInFirefox()) {
					ExternalInterface.addCallback('startInspector', startInspector);
					ExternalInterface.addCallback('stopInspector', stopInspector);					ExternalInterface.addCallback('clearAllConnections', clearAllConnections);
				}
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
