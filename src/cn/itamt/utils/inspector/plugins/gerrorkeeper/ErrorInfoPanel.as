package cn.itamt.utils.inspector.plugins.gerrorkeeper {
	import cn.itamt.utils.TimeFormat;
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.ui.InspectorLabelButton;
	import cn.itamt.utils.inspector.ui.InspectorTextField;
	import cn.itamt.utils.inspector.ui.InspectorViewPanel;
	import cn.itamt.utils.inspector.ui.Padding;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author itamt[at]qq.com
	 */
	public class ErrorInfoPanel extends InspectorViewPanel {

		public var info : TextField;
		public var errorLog : ErrorLog;
		public var alertBtn : InspectorLabelButton;

		public function ErrorInfoPanel(errorLog : ErrorLog, title : String = '错误', w : Number = 200, h : Number = 200, autoDisposeWhenRemove : Boolean = true, resizeable : Boolean = true, closeable : Boolean = true) {

			this.errorLog = errorLog;

			info = InspectorTextField.create(errorLog.toString(), 0xff0000, 12, 0, 0);
			info.multiline = info.wordWrap = true;
			info.htmlText = getErrorLogStr();
			info.width = 250;
			info.height = info.textHeight > 180 ? 180 : (info.textHeight + 4);

			w = info.width + 20;
			h = info.height + 33;

			super(title, w, h, autoDisposeWhenRemove, resizeable, closeable);

			this._padding = new	Padding(33, 10, 40, 10);

			// 刷新按钮
			alertBtn = new InspectorLabelButton(InspectorLanguageManager.getStr("GEK_ENABLE_POPUP"));
			alertBtn.addEventListener(MouseEvent.CLICK, onToggleAlert);
			addChild(alertBtn);

			this.setContent(info);
		}

		private function onToggleAlert(event : MouseEvent) : void {
			this.dispatchEvent(new Event("change"));
		}

		override public function relayout() : void {
			info.width = _width - _padding.left - _padding.right;
			info.height = info.textHeight + 4;

			if(this.needHScroller()) {
				info.width = _width - _padding.left - _padding.right - 16;
				info.height = info.textHeight + 4;
			}

			super.relayout();

			alertBtn.x = _width - _padding.right - alertBtn.width;
			alertBtn.y = _height - alertBtn.height - 10;
		}

		public function getErrorLogStr() : String {
			var str : String = '';

			str += "<font color='#CC5200'>[" + this.errorLog.date.toLocaleTimeString() + "]</font>" + "<font color='#CC5200'>[" + TimeFormat.toTimeString(this.errorLog.time / 1000, TimeFormat.ENGLISH_FULL_TIME) + "," + this.errorLog.time % 1000 + "]" + "</font><br>";
			str += "<font color='#ffcc00'>";
			if(this.errorLog.type == ErrorLogType.ERROR) {
				var err : Error = this.errorLog.error as Error;
				str += err.getStackTrace() + "<br>";
			} else if(this.errorLog.type == ErrorLogType.ERROR_EVENT) {
				var evt : ErrorEvent = this.errorLog.error as ErrorEvent;
				str += evt.toString();
			} else {
				str += String(this.errorLog.error);
			}
			str += "</font>";
			return str;
		}

		/**
		 * 销毁
		 */
		override public function dispose() : void {
			errorLog = null;
			alertBtn.removeEventListener(MouseEvent.CLICK, onToggleAlert);
			super.dispose();
		}

		override public function open():void {
			super.open();
			this.alertBtn.visible = true;
		}

		override public function hide():void {
			super.hide();
			this.alertBtn.visible = false;
		}
	}
}
