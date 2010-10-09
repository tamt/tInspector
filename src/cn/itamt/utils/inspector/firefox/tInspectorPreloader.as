package cn.itamt.utils.inspector.firefox {
	import cn.itamt.utils.Debug;
	import cn.itamt.utils.Inspector;
	import cn.itamt.utils.inspector.events.InspectEvent;
	import cn.itamt.utils.inspector.firefox.download.DownloadAll;
	import cn.itamt.utils.inspector.firefox.reloadapp.ReloadApp;
	import cn.itamt.utils.inspector.plugins.InspectorPluginId;
	import cn.itamt.utils.inspector.plugins.controlbar.ControlBar;
	import cn.itamt.utils.inspector.plugins.fullscreen.FullScreen;
	import cn.itamt.utils.inspector.plugins.gerrorkeeper.GlobalErrorKeeper;
	import cn.itamt.utils.inspector.plugins.stats.AppStats;
	import cn.itamt.utils.inspector.plugins.swfinfo.SwfInfoView;

	import msc.console.mConsole;
	import msc.console.mIConsoleDelegate;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.text.TextField;

	/**
	 * @author itamt[at]qq.com
	 */
	public class tInspectorPreloader extends Sprite implements mIConsoleDelegate {
		public static var mainStage : Stage;
		public static var mainRoot : DisplayObject;
		private var controlBar : ControlBar;
		public var tf : TextField;
		private var tInspector : Inspector;
		private var statsView : AppStats;

		private var swfInfoView : SwfInfoView;
		private var gErrorKeeper : GlobalErrorKeeper;

		// 由finspector.js分配给的id, 用于与fInspector通信.
		// private var swfId : String = '';
		public function tInspectorPreloader() {
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");

			controlBar = new ControlBar();
			controlBar.addEventListener(InspectEvent.RELOAD, onClickReload);

			statsView = new AppStats();
			swfInfoView = new SwfInfoView();
			gErrorKeeper = new GlobalErrorKeeper();
			gErrorKeeper.watch(this.loaderInfo);

			if(ExternalInterface.available) {
				ExternalInterface.addCallback("connectController", connectController);
				ExternalInterface.addCallback("disconnectController", disconnectController);
				ExternalInterface.addCallback("setSwfId", setSwfId);
				ExternalInterface.addCallback("startInspector", this.startInspector);
				ExternalInterface.addCallback("stopInspector", this.stopInspector);
			} else {
			}

			if(stage) {
				init();
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			}
		}

		private function onAdded(evt : Event) : void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			init();
		}

		private function init() : void {
			// mainRoot = this.root;
			mainStage = stage;

			this.root.addEventListener("allComplete", this.allCompleteHandler);
			this.root.addEventListener("allComplete", this.watchGlobalError);
			mainStage.addEventListener(Event.ADDED_TO_STAGE, onSthAdded, true);
		}

		private function watchGlobalError(evt : Event) : void {
			var loaderInfo : LoaderInfo = evt.target as LoaderInfo;
			if(loaderInfo) {
				if(loaderInfo.url) {
					if(loaderInfo.contentType == "application/x-shockwave-flash") {
						gErrorKeeper.watch(loaderInfo);
					}
				}
			}
		}

		private function onSthAdded(evt : Event) : void {
			mainStage.removeEventListener(Event.ADDED_TO_STAGE, onSthAdded, true);

			log('[tInspectorPreloader][onSthAdded]' + evt.target);
			if(mainRoot != (evt.target as DisplayObject).root) {
				mainRoot = (evt.target as DisplayObject).root;
			}
			setupControlBar();
		}

		private function allCompleteHandler(evt : Event) : void {
			log('[tInspectorPreloader][allCompleteHandler]');

			var loaderInfo : LoaderInfo = evt.target as LoaderInfo;
			if(loaderInfo) {
				if(loaderInfo.url) {
					if((loaderInfo.url.indexOf("tInspectorPreloader.swf") == -1) && (loaderInfo.url.indexOf("fInspectorSetting.swf") == -1) && (loaderInfo.url.indexOf("tInspectorConsoleMonitor.swf") == -1) && (loaderInfo.contentType == "application/x-shockwave-flash") ) {
						log(loaderInfo.url);
						setupControlBar();
						initInspector();
						mainRoot.removeEventListener("allComplete", this.allCompleteHandler);
					}
				}
			}
		}

		private function initInspector() : void {
			log('[tInspectorPreloader][initInspector]');

			mConsole.init(false);
			mConsole.addDelegate(this);
			if(!ExternalInterface.available) {
				connectController();
			}

			tInspector = Inspector.getInstance();
			tInspector.init(this.controlBar.stage.getChildAt(0) as DisplayObjectContainer);
			tInspector.pluginManager.registerPlugin(statsView);
			tInspector.pluginManager.registerPlugin(new ReloadApp());
			tInspector.pluginManager.registerPlugin(new DownloadAll());
			tInspector.pluginManager.registerPlugin(new FullScreen());
			tInspector.pluginManager.registerPlugin(swfInfoView);
			tInspector.pluginManager.registerPlugin(gErrorKeeper);
			// tInspector.pluginManager.loadPlugin(new URLRequest("http://www.itamt.cn/tinspector_plugins/DownloadAll.swf"));
			if(this.loaderInfo.hasOwnProperty("uncaughtErrorEvents"))
				tInspector.pluginManager.activePlugin(InspectorPluginId.GLOBAL_ERROR_KEEPER);
		}

		private function setupControlBar() : void {
			if(this.controlBar.stage == null) {
				mainStage.addChild(this.controlBar);
			} else {
				this.controlBar.stage.addChild(this.controlBar);
			}
		}

		private function onClickReload(event : InspectEvent) : void {
			Debug.trace('[tInspectorPreloader][onClickReload]ExternalInterface.available: ' + ExternalInterface.available + ", " + FlashPlayerEnvironment.swfId);
			if(ExternalInterface.available) {
				ExternalInterface.call("fInspectorReloadSwf", FlashPlayerEnvironment.swfId);
			}
		}

		// // // // // // // // // // // // // ////////////
		// // // //    /public   functions/////////////
		// // // // // // // // // // // // // ////////////
		public function connectController() : void {
			Debug.trace('[tInspectorPreloader][connectController]');
			mConsole.connectMonitor();
		}

		public function disconnectController() : void {
			Debug.trace('[tInspectorPreloader][disconnectController]');
			mConsole.disconnectMonitor();
		}

		public function setSwfId(swfId : String) : void {
			Debug.trace('[tInspectorPreloader][setSwfId]' + swfId);
			FlashPlayerEnvironment.swfId = swfId;
		}

		/**
		 * 开启tInspector
		 */
		public function startInspector() : void {
			log('[tInspectorPreloader][startInspector]');
			this.controlBar.visible = true;
		}

		/**
		 * 关闭tInspector
		 */
		public function stopInspector() : void {
			log('[tInspectorPreloader][stopInspector]');
			this.controlBar.visible = false;
		}

		public function log(str : String) : void {
			Debug.trace(str, 1);
		}

		public function dump(str : String) : void {
			log("[client-->monitor]" + str);
			if(ExternalInterface.available) {
				ExternalInterface.call("alert", "\n" + str);
			}
		}

		// // // // // // // // // // // // // ///////////////
		// // // // // // // // // // // // // ///////////////
		// // // // // // // // // // // // // ///////////////
		// // // // // // // // // // // // // ///////////////
		private static var engine : MovieClip = new MovieClip();

		public static function callLater(func : Function, args : Array = null, frame : int = 1) : void {
			engine.addEventListener(Event.ENTER_FRAME, function(event : Event):void {
				if (--frame <= 0) {
					engine.removeEventListener(Event.ENTER_FRAME, arguments.callee);
					func.apply(null, args);
				}
			});
		}
	}
}