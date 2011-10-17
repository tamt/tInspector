package cn.itamt.utils.inspector.firefox
{
	import flash.utils.getTimer;

	import cn.itamt.utils.Debug;
	import cn.itamt.utils.inspector.firefox.setting.fInspectorConfig;
	import cn.itamt.utils.inspector.plugins.InspectorPluginId;

	import msc.console.mConsoleConnName;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	import flash.system.Security;
	import flash.text.TextField;

	/**
	 * @author itamt[at]qq.com
	 */
	public class tInspectorConsoleMonitor extends Sprite
	{
		private var controller : finspectorController;
		public var tf : TextField;

		public function tInspectorConsoleMonitor()
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");

			this.visible = false;

			try
			{
				if (ExternalInterface.available)
				{
					if (!Capabilities.isDebugger)
					{
						Debug.trace('[tInspectorConsoleMonitor]fInspector.setEnable', 3);
						ExternalInterface.call("fInspector.setEnable", false);
						return;
					}

					var controllerId : String = ExternalInterface.call("fInspector.getControllerId")
					setupController(controllerId);
					// Debug.trace("Controller Id: " + controllerId);
					// Debug.trace('[tInspectorConsoleMonitor]addCallback', 3);
					// if(FlashPlayerEnvironment.isInFirefox()) {
					// ExternalInterface.addCallback('setupController', setupController);
					ExternalInterface.addCallback('startInspector', startInspector);
					ExternalInterface.addCallback('stopInspector', stopInspector);
					ExternalInterface.addCallback('toggleInspector', toggleInspector);
					ExternalInterface.addCallback('toggleInspectorByUrl', toggleInspectorByUrl);
					ExternalInterface.addCallback('clearAllConnections', clearAllConnections);
					ExternalInterface.addCallback('selectPlugin', selectPlugin);
					ExternalInterface.addCallback('rejectPlugin', rejectPlugin);
					ExternalInterface.addCallback('trace', debugTrace);
					// }

					Debug.trace('[tInspectorConsoleMonitor]add call back success!');
				}
				else
				{
					throw new Error("[InspectorController]add call back failure");
				}

				var arr : Array;
				if (fInspectorConfig.getPlugins() == null)
				{
					arr = [InspectorPluginId.APPSTATS_VIEW, InspectorPluginId.FULL_SCREEN, InspectorPluginId.GLOBAL_ERROR_KEEPER, InspectorPluginId.RELOAD_APP, InspectorPluginId.DOWNLOAD_ALL, InspectorPluginId.SWFINFO_VIEW];
					if (arr)
					{
						for (var i : int = 0; i < arr.length; i++)
						{
							ExternalInterface.call("fInspector.showCheckInspectorPlugin", arr[i], true);
						}
					}
				}
				else
				{
					arr = fInspectorConfig.getEnablePlugins();
					if (arr)
					{
						for (var i : int = 0; i < arr.length; i++)
						{
							ExternalInterface.call("fInspector.showCheckInspectorPlugin", arr[i], true);
						}
					}
				}
			}
			catch (e : Error)
			{
				Debug.trace(e.message);
			}

			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		/**
		 * called by FI in firefox
		 * @param	controllerId	FI id, this id will be used as the LocalConnection id builded to communicate between tInspectorPreloader and tInspectorConsoleMonitor.swf
		 */
		private function setupController(controllerId : String) : void
		{
			mConsoleConnName.CONSOLE += controllerId;

			Debug.trace("[tInspectorConsoleMonitor]setupController: " + mConsoleConnName.CONSOLE);

			controller = new finspectorController();
			controller.visible = false;
			controller.proxy = this;
			controller.enable = fInspectorConfig.getEnable();
			addChild(controller);

			if (controller.enable)
			{
				this.startInspector();
			}
			else
			{
				this.stopInspector();
			}
		}

		private function rejectPlugin(pluginId : String) : void
		{
			fInspectorConfig.setDisablePlugin(pluginId);
			fInspectorConfig.save();
		}

		private function selectPlugin(pluginId : String) : void
		{
			fInspectorConfig.setEnablePlugin(pluginId);
			fInspectorConfig.save();
		}

		/*************************************
		 *********public functions************
		 ************************************/
		public function debugTrace(msg : *) : void
		{
			Debug.trace('[tInspectorConsoleMonitor.debugTrace]' + getTimer() + ':' + msg);
		}

		/**
		 * called by FI in Firefox.
		 */
		public function startInspector() : void
		{
			//
			controller.enable = true;
			controller.callFun('startInspector');

			//
			fInspectorConfig.setEnable(true);
			fInspectorConfig.save();

			//
			ExternalInterface.call("fInspector.onInspectorState", "on");
		}

		/**
		 * called by FI in Firefox.
		 */
		public function stopInspector() : void
		{
			controller.enable = false;
			controller.callFun('stopInspector');

			fInspectorConfig.setEnable(false);
			fInspectorConfig.save();

			//
			ExternalInterface.call("fInspector.onInspectorState", "off");
		}

		/**
		 * called by FI in Firefox.
		 */
		public function toggleInspector() : void
		{
			Debug.trace('[tInspectorConsoleMonitor.toggleInspector]');
			if (controller.enable)
			{
				this.stopInspector();
			}
			else
			{
				this.startInspector();
			}
		}

		/**
		 * disconnect all connections from tInspectorConsoleMonitor.swf to all tInspectorPreloader.swf, this may be used when Firefox close.
		 */
		public function clearAllConnections() : void
		{
			controller.deconstructAllConnections();
		}

		/**
		 * called by tInspectorPreloader.swf through LocalConnection when fail to fullscreen.
		 * @param	swfId		target swf's id. sometimes they doesn't have id.
		 */
		public function showFullScreenGuide(swfId : String) : void
		{
			Debug.trace('[tInspectorConsoleMonitor][showFullScreenGuide]');
			ExternalInterface.call("fInspector.showFullScreenGuide", swfId);
		}

		/**
		 * called by tInspectorPreloader.swf through LocalConnection when fail to fullscreen.
		 * @param	swfUrl		target swf's url. sometimes they doesn't have id, but they must have url.
		 */
		public function showFullScreenGuideByUrl(swfUrl : String) : void
		{
			ExternalInterface.call("fInspector.showFullScreenGuideByUrl", swfUrl);
		}

		/**
		 * called by tInspectorPreloader.swf through LocalConnection to reload target swf.
		 * @param			target swf's id
		 */
		public function reloadSwf(swfId : String) : void
		{
			ExternalInterface.call("fInspector.reloadSwf", swfId);
		}

		/**
		 * called by tInspectorPreloader.swf through LocalConnection to reload target swf.
		 * @param			target swf's url. sometimes they doesn't have id, but they must have url
		 */
		public function reloadSwfByUrl(swfUrl : String) : void
		{
			ExternalInterface.call("fInspector.reloadSwfByUrl", swfUrl);
		}

		/**
		 * called by tInspectorPreloader.swf through LocalConnection to toggle Inspector on target swf.
		 * @param	swfUrl		target swf's url. sometimes they doesn't have id, but they must have url
		 */
		public function toggleInspectorByUrl(swfUrl : String) : void
		{
			Debug.trace('[tInspectorConsoleMonitor][startInspectorByUrl]' + swfUrl);
			controller.callInspectorFunBySwfUrl("toggleInspector", swfUrl);
		}

		/*************************************
		 *********private functions***********
		 ************************************/
		private function onAdded(evt : Event) : void
		{
			for (var i : int = 0;i < this.stage.numChildren;i++)
			{
				this.stage.getChildAt(i).visible = false;
			}
		}
	}
}
