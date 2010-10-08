package cn.itamt.utils.inspector.firefox.download {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.ui.InspectorIconButton;
	import cn.itamt.utils.inspector.ui.InspectorSymbolIcon;
	import cn.itamt.utils.inspector.ui.InspectorTextField;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;

	/**
	 * @author itamt@qq.com
	 */
	public class LoadedStuffItemRenderer extends Sprite {
		protected var name_tf : TextField;
		protected var _width : Number;
		protected var _height : Number;
		protected var _iconSave : InspectorIconButton;
		// protected var _iconCopyUrl : InspectorIconButton;
		// protected var _iconOpenUrl : InspectorIconButton;
		protected var _loadedLog : LoadedStuffInfo;
		protected var _paddingLeft : Number = 0;

		public function LoadedStuffItemRenderer(w : Number = 200, h : Number = 20) : void {
			this._width = w;
			this._height = h;

			this.mouseEnabled = false;
			this.buttonMode = true;

			name_tf = InspectorTextField.create('property name', 0xcccccc, 12, 0, 0, 'left', 'left');
			name_tf.height = _height - 2;
			addChild(name_tf);

			this.name_tf.addEventListener(MouseEvent.ROLL_OVER, onMouseAct);
			this.name_tf.addEventListener(MouseEvent.ROLL_OUT, onMouseAct);
			this.name_tf.addEventListener(MouseEvent.CLICK, onMouseAct);

			this.relayout();
		}

		protected function drawBg(bgColor : uint = 0x282828) : void {
			this.graphics.clear();
			this.graphics.beginFill(bgColor);
			// this.graphics.drawRoundRect(0, 0, Math.max(name_tf.x + name_tf.textWidth + 16, _width), _height, 5, 5);
			this.graphics.drawRoundRect(20 + _paddingLeft, 0, name_tf.textWidth + 4, _height, 5, 5);
			this.graphics.endFill();
		}

		protected function onMouseAct(evt : MouseEvent) : void {
			if(evt.type == MouseEvent.ROLL_OUT) {
				this.drawBg(0x282828);
			} else if(evt.type == MouseEvent.ROLL_OVER) {
				this.drawBg(0x444444);
			} else if(evt.type == MouseEvent.CLICK) {
				evt.stopImmediatePropagation();
				this.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}

		protected function relayout() : void {
			if(_iconSave) {
				_iconSave.x = _paddingLeft;
				_iconSave.y = 2;
			}
			name_tf.x = 20 + _paddingLeft;
			// name_tf.width = _width - 20;
			drawBg();
		}

		protected function getBriefUrl(url : String):String {
			var ret : String;
			if(url.indexOf("?") > 0)
				url = url.slice(0, url.indexOf("?"));
			var pStart : int = url.indexOf("//") + 2;
			var pEnd : int = url.indexOf("/", pStart) + 1;
			var eStart : int = url.lastIndexOf("/") + 1;
			var eEnd : int = url.length;
			ret = url.slice(pStart, pEnd) + ".../" + url.slice(eStart, eEnd);
			// ret = ".../" + url.slice(eStart, eEnd);
			return ret;
		}

		private function getBriefContentType(contentType : String) : String {
			return "";
		}

		private function onClickSave(event : MouseEvent) : void {
			navigateToURL(new URLRequest(this._loadedLog.url), "_blank");
		}

		/***************************/
		/***************************/
		/***************************/
		/***************************/
		public function set data(value : Object) : void {
			_loadedLog = value as LoadedStuffInfo;

			if(this._iconSave && this.contains(this._iconSave)) {
				this.removeChild(this._iconSave);
				this._iconSave.dispose();
				this._iconSave.removeEventListener(MouseEvent.CLICK, onClickSave);
			}

			this._iconSave = new InspectorIconButton(InspectorSymbolIcon.getIconNameByContentType(_loadedLog.contentType));
			this._iconSave.tip = InspectorLanguageManager.getStr("SaveAs");
			this._iconSave.addEventListener(MouseEvent.CLICK, onClickSave);
			addChild(this._iconSave);

			// this.label = this.getBriefUrl(_loadedLog.url);
		}

		public function set label(val : String) : void {
			name_tf.htmlText = "<a href='#'><font color='#ffffff'>" + (val == null ? '' : val) + "</font></a>";

			this.relayout();
		}

		public function get label() : String {
			return name_tf.text;
		}

		public function get data() : * {
			return _loadedLog;
		}

		public function set color(value : uint) : void {
			name_tf.textColor = value;
		}

		public function get color() : uint {
			return name_tf.textColor;
		}

		public function dispose():void {
			_loadedLog = null;
			_iconSave = null;

			this.name_tf.removeEventListener(MouseEvent.ROLL_OVER, onMouseAct);
			this.name_tf.removeEventListener(MouseEvent.ROLL_OUT, onMouseAct);
			this.name_tf.removeEventListener(MouseEvent.CLICK, onMouseAct);
		}

		public function set paddingLeft(paddingLeft : uint):void {
			_paddingLeft = paddingLeft;
			this.relayout();
		}
	}
}
