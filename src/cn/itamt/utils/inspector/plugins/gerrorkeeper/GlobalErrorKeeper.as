package cn.itamt.utils.inspector.plugins.gerrorkeeper {
	import cn.itamt.utils.Debug;
	import cn.itamt.utils.inspector.core.BaseInspectorPlugin;
	import cn.itamt.utils.inspector.core.IInspector;
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.plugins.InspectorPluginId;
	import cn.itamt.utils.inspector.popup.InspectorPopupManager;
	import cn.itamt.utils.inspector.popup.PopupAlignMode;

	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;

	/**	 * 在Flash Player 10.1(+)中全局处理错误. 确保Flash Player稳定性.	 * @author itamt[at]qq.com	 */
	public class GlobalErrorKeeper extends BaseInspectorPlugin {
		protected var enabled : Boolean = false;
		protected var historyPanel : ErrorListPanel;
		protected var errorPanels : Array;
		protected var errorList : Array;
		protected var iconBtnContainer : Sprite;
		protected var historyBtn : GlobalErrorsHistoryButton;
		protected var watchTargets : Array;
		protected var useAlert : Boolean = true;

		public function GlobalErrorKeeper() {
			super();
		}

		override public function getPluginId() : String {
			return InspectorPluginId.GLOBAL_ERROR_KEEPER;
		}

		override public function onRegister(inspector : IInspector) : void {
			super.onRegister(inspector);
			_icon = new GlobalErrorKeeperButton();
			historyBtn = new GlobalErrorsHistoryButton();
			iconBtnContainer = new Sprite();
			iconBtnContainer.mouseEnabled = false;
			iconBtnContainer.addChild(_icon);
			historyBtn.x = _icon.width;
			iconBtnContainer.addChild(historyBtn);
		}

		override public function contains(child : DisplayObject) : Boolean {
			if(errorPanels) {
				for each(var ep:ErrorInfoPanel in errorPanels) {
					if(ep == child || ep.contains(child))
						return true;
				}
			}
			if(historyPanel) {
				return historyPanel == child || historyPanel.contains(child);
			}
			return false;
		}

		/**		 * 当Inspector开启时		 */
		override public function onTurnOn() : void {
			super.onTurnOn();
			if(this.enabled) {
				_inspector.pluginManager.activePlugin(InspectorPluginId.GLOBAL_ERROR_KEEPER);
			}
			historyBtn.addEventListener(MouseEvent.CLICK, onClickHistoryBtn);
		}

		/**		 * 当Inspector开启时		 */
		override public function onTurnOff() : void {
			_isOn = false;
			historyBtn.removeEventListener(MouseEvent.CLICK, onClickHistoryBtn);
		}

		override public function onActive() : void {
			super.onActive();
			if(this._inspector.stage.loaderInfo.hasOwnProperty("uncaughtErrorEvents")) {
				enabled = true;
				for(var i : int = 0;i < this._inspector.stage.numChildren;i++) {
					this.watch(this._inspector.stage.getChildAt(i).loaderInfo);
				}
			} else {
				enabled = false;
				// 提示用户该Flash Player不支持"错误全局处理".
				this.popupErrorDetail(new ErrorLog(InspectorLanguageManager.getStr("GEK_Unsupported")));
			}
		}

		override public function onUnActive() : void {
			// this.panel.removeEventListener(Event.CLOSE, onClickClose);
			if(this.historyPanel) {
				if(this.historyPanel.stage)
					this.historyPanel.parent.removeChild(this.historyPanel);
				this.historyPanel.removeEventListener(Event.CLOSE, onClickClose);
				this.historyPanel.removeEventListener(MouseEvent.CLICK, onClickErrorItem);
				this.historyPanel.removeEventListener("clear", onClickClear);
				this.historyPanel.removeEventListener("change", this.onToggleAlert);
				this.historyPanel = null;
			}
			if(enabled) {
				// for(var i : int = 0;i < this._inspector.stage.numChildren;i++) {
				// unwatch(this._inspector.stage.getChildAt(i).loaderInfo);
				// }
				if(watchTargets) {
					for each (var target : LoaderInfo in watchTargets) {
						this.unwatch(target);
					}
				}
			}
			enabled = false;
			super.onUnActive();
		}

		public function watch(loaderInfo : LoaderInfo) : void {
			if(loaderInfo == null)
				return;
			if(loaderInfo.hasOwnProperty("uncaughtErrorEvents")) {
				if(watchTargets == null)
					watchTargets = [];
				if(watchTargets.indexOf(loaderInfo) < 0) {
					watchTargets.push(loaderInfo);
				}
				IEventDispatcher(loaderInfo["uncaughtErrorEvents"]).addEventListener("uncaughtError", uncaughtErrorHandler);
			}
		}

		public function unwatch(loaderInfo : LoaderInfo) : void {
			if(loaderInfo == null) {
				Debug.trace('[GlobalErrorKeeper][unwatch]' + "find an null LoaderInfo");
				return;
			}
			if(loaderInfo.hasOwnProperty("uncaughtErrorEvents")) {
				if(watchTargets) {
					var i : int = watchTargets.indexOf(loaderInfo);
					if(i >= 0) {
						watchTargets.splice(i, 1);
					}
				}
				IEventDispatcher(loaderInfo["uncaughtErrorEvents"]).removeEventListener("uncaughtError", uncaughtErrorHandler);
			}
		}

		/**		 * 弹出"错误历史"面板		 */
		public function popupHistoryPanel() : void {
			this.historyPanel = new ErrorListPanel();
			this.historyPanel.setData(this.errorList);
			this.setErrorPanel(this.historyPanel);
			this.historyPanel.addEventListener(Event.CLOSE, onClickClose);
			this.historyPanel.addEventListener("clear", onClickClear);
			this.historyPanel.addEventListener(MouseEvent.CLICK, onClickErrorItem);
			this.historyPanel.addEventListener("change", this.onToggleAlert);
			InspectorPopupManager.popup(this.historyPanel, PopupAlignMode.CENTER);
		}

		/**		 * 移除"错误历史"面板		 */
		public function hideHistoryPanel() : void {
			if(this.historyPanel) {
				InspectorPopupManager.remove(this.historyPanel);
				this.historyPanel.removeEventListener(Event.CLOSE, onClickClose);
				this.historyPanel.removeEventListener(MouseEvent.CLICK, onClickErrorItem);
				this.historyPanel.removeEventListener("clear", onClickClear);
				this.historyPanel.removeEventListener("change", this.onToggleAlert);
				this.historyPanel = null;
			}
		}

		public function toggleHistoryPanel() : void {
			Debug.trace('[GlobalErrorKeeper][toggleHistoryPanel]' + InspectorPopupManager.contains(this.historyPanel));
			if(InspectorPopupManager.contains(this.historyPanel)) {
				this.hideHistoryPanel();
			} else {
				this.popupHistoryPanel();
			}
		}

		public function clearAllErrors() : void {
			if(errorList) {
				while(errorList.length) {
					removeErrorLog(errorList[0]);
				}
			}
			Debug.trace('[GlobalErrorKeeper][clearAllErrors]' + errorList.length);
		}

		public function removeErrorLog(errorLog : ErrorLog) : void {
			if(errorList == null)
				return;
			var t : int = errorList.indexOf(errorLog);
			if(t < 0) {
				Debug.trace('[GlobalErrorKeeper][removeErrorLog]nono, i can not find it.');
				return;
			}
			errorList.splice(t, 1);
			Debug.trace('[GlobalErrorKeeper][removeErrorLog]' + errorList.length);
			this.removePopupErrorDetail(errorLog);
			if(this.historyPanel)
				this.historyPanel.update();
		}

		public function addErrorLog(errorLog : ErrorLog) : void {
			if(errorList == null)
				errorList = [];
			if(errorList.indexOf(errorLog) < 0) {
				errorList.push(errorLog);
				if(this.historyPanel)
					this.historyPanel.update();
			}
			Debug.trace('[GlobalErrorKeeper][addErrorLog]');
			if(this.useAlert) {
				this.popupErrorDetail(errorLog);
			} else if(this.historyPanel == null) {
				if(this.historyBtn.stage)
					this.historyBtn.showTempTip(errorList.length.toString());
			}
		}

		override public function getPluginIcon() : DisplayObject {
			return iconBtnContainer;
		}

		// // // // // // // // // // // // // // // // // // //                   
		// // // // //     private    functions///////////
		// // // // // // // // // // // // // // // // // // //                   
		/**		 * 玩家单击关闭按钮时		 */
		private function onClickClose(evt : Event) : void {
			if(evt.target is ErrorInfoPanel) {
				InspectorPopupManager.remove(evt.target as ErrorInfoPanel);
				if(errorPanels) {
					var i : int = errorPanels.indexOf(evt.target);
					errorPanels.splice(i, 1);
				}
				(evt.target as ErrorInfoPanel).removeEventListener(Event.CLOSE, onClickClose);
				(evt.target as ErrorInfoPanel).removeEventListener("change", onToggleAlert);
			} else if(evt.target == this.historyPanel) {
				this.hideHistoryPanel();
			}
		}

		private function uncaughtErrorHandler(evt : ErrorEvent) : void {
			evt.preventDefault();
			var evtError : * = evt['error'];
			var errorLog : ErrorLog = new ErrorLog(evtError);
			this.addErrorLog(errorLog);
		}

		private function onClickErrorItem(event : MouseEvent) : void {
			if(event.target is ErrorLogItemRenderer) {
				var item : ErrorLogItemRenderer = event.target as ErrorLogItemRenderer;
				this.popupErrorDetail(item.data as ErrorLog);
			}
		}

		/**		 * 在界面上弹出错误的具体信息		 */
		private function popupErrorDetail(errorLog : ErrorLog) : void {
			if(errorPanels == null)
				errorPanels = [];
			var panel : ErrorInfoPanel;
			var hasExist : Boolean;
			for each(panel in errorPanels) {
				if(panel.errorLog == errorLog) {
					hasExist = true;
					break;
				}
			}
			if(!hasExist) {
				panel = new ErrorInfoPanel(errorLog, '错误');
				this.setErrorPanel(panel);
				errorPanels.push(panel);
				panel.addEventListener(Event.CLOSE, onClickClose);
				panel.addEventListener("change", onToggleAlert);
			}
			InspectorPopupManager.popup(panel, PopupAlignMode.CENTER);
		}

		/**
		 * 切换是否启用
		 */
		private function onToggleAlert(evt : Event) : void {
			useAlert = !useAlert;
			for each (var panel : ErrorInfoPanel in errorPanels) {
				this.setErrorPanel(panel);
			}

			if(this.historyPanel)
				this.setErrorPanel(this.historyPanel);
		}

		private function setErrorPanel(panel : *):void {
			panel.alertBtn.active = useAlert;
			if(useAlert) {
				panel.alertBtn.label = InspectorLanguageManager.getStr("GEK_ENABLE_POPUP");
				panel.alertBtn.tip = InspectorLanguageManager.getStr("GEK_ENABLE_POPUP_TIP");
			} else {
				panel.alertBtn.label = InspectorLanguageManager.getStr("GEK_DISABLE_POPUP");
				panel.alertBtn.tip = InspectorLanguageManager.getStr("GEK_DISABLE_POPUP_TIP");
			}
		}

		private function removePopupErrorDetail(errorLog : ErrorLog) : void {
			if(errorPanels == null)
				return;
			var panel : ErrorInfoPanel;
			for(var i : int = 0;i < errorPanels.length;i++) {
				panel = errorPanels[i];
				if(panel.errorLog == errorLog) {
					this.errorPanels.splice(i, 1);
					panel.removeEventListener(Event.CLOSE, onClickClose);
					InspectorPopupManager.remove(panel);
					break;
				}
			}
		}

		private function onClickHistoryBtn(evt : MouseEvent):void {
			this.toggleHistoryPanel();
		}

		private function onClickClear(event : Event) : void {
			this.clearAllErrors();
		}
	}
}