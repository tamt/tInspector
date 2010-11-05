package cn.itamt.utils.inspector.firefox {
	import cn.itamt.utils.Debug;
	import cn.itamt.utils.inspector.firefox.setting.fInspectorConfig;
	import cn.itamt.utils.inspector.plugins.InspectorPluginId;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.text.TextField;

	/**
	 * @author itamt[at]qq.com
	 */
	public class tInspectorConsoleMonitor extends Sprite {
		private var controller : finspectorController;

		public var tf : TextField;

		public function tInspectorConsoleMonitor() {
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");

			controller = new finspectorController();
			controller.visible = false;
			controller.proxy = this;
			controller.enable = fInspectorConfig.getEnable();
			addChild(controller);

			this.visible = false;

			if(ExternalInterface.available) {
				if(!Capabilities.isDebugger) {
					try {
						Debug.trace('[tInspectorConsoleMonitor]fInspector.setEnable', 3);
						ExternalInterface.call("fInspector.setEnable", false);
					} catch(e : Error) {
					}
					return;
				}
				if(FlashPlayerEnvironment.isInFirefox()) {
					ExternalInterface.addCallback('startInspector', startInspector);
					ExternalInterface.addCallback('stopInspector', stopInspector);
					ExternalInterface.addCallback('toggleInspector', toggleInspector);
					ExternalInterface.addCallback('toggleInspectorByUrl', toggleInspectorByUrl);
					ExternalInterface.addCallback('clearAllConnections', clearAllConnections);
					ExternalInterface.addCallback('selectPlugin', selectPlugin);
					ExternalInterface.addCallback('rejectPlugin', rejectPlugin);
				}
			}

			if(controller.enable) {
				this.startInspector();
			} else {
				this.stopInspector();
			}
			
			var arr:Array;
			if(fInspectorConfig.getPlugins() == null){
				arr = [InspectorPluginId.APPSTATS_VIEW, InspectorPluginId.FULL_SCREEN, InspectorPluginId.GLOBAL_ERROR_KEEPER, InspectorPluginId.RELOAD_APP, InspectorPluginId.DOWNLOAD_ALL, InspectorPluginId.SWFINFO_VIEW];
				if(arr){
					for(var i:int = 0; i<arr.length; i++){
						ExternalInterface.call("fInspector.showCheckInspectorPlugin", arr[i], true);					
					}
				}
			}else{
				arr = fInspectorConfig.getEnablePlugins();
				if(arr){
					for(var i:int = 0; i<arr.length; i++){
						ExternalInterface.call("fInspector.showCheckInspectorPlugin", arr[i], true);					
					}
				}	
			}

			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		private function rejectPlugin(pluginId : String) : void {
			fInspectorConfig.setDisablePlugin(pluginId);
			fInspectorConfig.save();
		}

		private function selectPlugin(pluginId : String) : void {
			fInspectorConfig.setEnablePlugin(pluginId);
			fInspectorConfig.save();			
		}

		/*************************************
		 *********public functions************
		 ************************************/

		public function reloadSwf() : void {
			ExternalInterface.call("fInspector.reloadSwf", false);
		}

		public function startInspector() : void {
			alert('[tInspectorConsoleMonitor][startInspector]');
			controller.enable = true;
			controller.callFun('startInspector');

			//
			fInspectorConfig.setEnable(true);
			fInspectorConfig.save();

			//
			ExternalInterface.call("fInspector.onInspectorState", "on");
		}

		public function stopInspector() : void {
			alert('[tInspectorConsoleMonitor][stopInspector]');
			controller.enable = false;
			controller.callFun('stopInspector');

			fInspectorConfig.setEnable(false);
			fInspectorConfig.save();

			//
			ExternalInterface.call("fInspector.onInspectorState", "off");
		}

		public function toggleInspector():void {
			if(controller.enable) {
				this.stopInspector();
			} else {
				this.startInspector();
			}
		}

		public function clearAllConnections() : void {
			alert('[tInspectorConsoleMonitor][clearAllConnections]');
			controller.deconstructAllConnections();
		}

		public function showFullScreenGuide(swfId : String):void {
			Debug.trace('[tInspectorConsoleMonitor][showFullScreenGuide]');
			ExternalInterface.call("fInspector.showFullScreenGuide", swfId);
		}
		
		public function showFullScreenGuideByUrl(swfUrl : String):void {
			ExternalInterface.call("fInspector.showFullScreenGuideByUrl", swfUrl);
		}
		
		public function reloadSwfByUrl(swfUrl : String):void {
			ExternalInterface.call("fInspector.reloadSwfByUrl", swfUrl);	
		}

		public function toggleInspectorByUrl(swfUrl : String):void {
			Debug.trace('[tInspectorConsoleMonitor][startInspectorByUrl]' + swfUrl);
			controller.callInspectorFunBySwfUrl("toggleInspector", swfUrl);
		}

		/*************************************
		 *********private functions***********
		 ************************************/

		private function alert(str : String) : void {
			if(tf == null)
				addChild(tf = new TextField());
			tf.autoSize = 'left';
			tf.text = str;

			Debug.trace('[tInspectorConsoleMonitor][alert]' + str);
		}

		private function onAdded(evt : Event) : void {
			for(var i : int = 0;i < this.stage.numChildren;i++) {
				this.stage.getChildAt(i).visible = false;
			}
		}
	}
}
