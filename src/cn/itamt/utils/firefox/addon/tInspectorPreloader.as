package cn.itamt.utils.firefox.addon {
	import flash.external.ExternalInterface;

	import cn.itamt.utils.Debug;
	import cn.itamt.utils.Inspector;

	import msc.console.mConsole;
	import msc.console.mIConsoleDelegate;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.system.Security;
	import flash.text.TextField;

	/**
	 * @author itamt[at]qq.com
	 */
	public class tInspectorPreloader extends Sprite implements mIConsoleDelegate {
		public static var mainStage : Stage;
		public static var mainRoot : DisplayObject;

		private var controlBar : tInspectorControlBar;
		public var tf : TextField;
		private var tInspector : Inspector;

		
		public function tInspectorPreloader() {
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");

			controlBar = new tInspectorControlBar();
			addChild(controlBar);
			
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
			//			mainRoot = this.root;
			mainStage = stage;
			
			this.root.addEventListener("allComplete", this.allCompleteHandler);
			mainStage.addEventListener(Event.ADDED_TO_STAGE, onSthAdded, true);
			
			if(ExternalInterface.available && FlashPlayerEnvironment.isInFirefox()) {
				Debug.trace('[tInspectorPreloader][init] add ConnectConroller to ExternalInterface');
				ExternalInterface.addCallback("connectController", connectController);				ExternalInterface.addCallback("disconnectController", disconnectController);
			} else {
//				Debug.trace('[tInspectorPreloader][init]' + ExternalInterface.available);//				Debug.trace('[tInspectorPreloader][init]' + FlashPlayerEnvironment.isInFirefox());
			}
		}

		private function onSthAdded(evt : Event) : void {
			mainStage.removeEventListener(Event.ADDED_TO_STAGE, onSthAdded, true);

			log('[tInspectorPreloader][onSthAdded]' + evt.target);
			if(mainRoot != (evt.target as DisplayObject).root) {
				mainRoot = (evt.target as DisplayObject).root;
			}
			showControlBar();
		}

		private function allCompleteHandler(evt : Event) : void {
			//			mainRoot.removeEventListener("allComplete", this.allCompleteHandler);

			log('[tInspectorPreloader][allCompleteHandler]');

			showControlBar();
			
			//			callLater(initInspector, null, 5);			initInspector();
		}

		private function initInspector() : void {
			log('[tInspectorPreloader][initInspector]');

			mConsole.init(false);
			mConsole.addDelegate(this);
			if(!ExternalInterface.available) {
				connectController();
			}

			tInspector = Inspector.getInstance();
			tInspector.init(this.controlBar.stage.getChildAt(0) as DisplayObjectContainer, false);
			tInspector.registerView(this.controlBar, this.controlBar.id);
		}

		private function showControlBar() : void {
			if(this.controlBar.stage == null) {
				mainStage.addChild(this.controlBar);
			} else {
				this.controlBar.stage.addChild(this.controlBar);
			}
		}

		//////////////////////////////////////
		/////////public functions/////////////
		//////////////////////////////////////

		public function connectController() : void {
			Debug.trace('[tInspectorPreloader][connectController]');
			mConsole.connectMonitor();
		}

		public function disconnectController() : void {
			Debug.trace('[tInspectorPreloader][disconnectController]');
			mConsole.disconnectMonitor();
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
			if(ExternalInterface.available) {
				ExternalInterface.call("dump", "\n" + str);
			}
		}

		/////////////////////////////////////////		/////////////////////////////////////////		/////////////////////////////////////////		/////////////////////////////////////////
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