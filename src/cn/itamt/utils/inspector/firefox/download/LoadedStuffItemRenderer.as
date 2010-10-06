package cn.itamt.utils.inspector.firefox.download {
	import cn.itamt.utils.inspector.ui.InspectorSymbolIcon;
	import cn.itamt.utils.inspector.ui.InspectorTextField;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author itamt@qq.com
	 */
	public class LoadedStuffItemRenderer extends Sprite {
		protected var name_tf : TextField;
		protected var _width : Number;
		protected var _height : Number;
		protected var _icon : Bitmap;
		protected var _loadedLog : LoadedStuffInfo;

		public function LoadedStuffItemRenderer(w : Number = 200, h : Number = 20) : void {
			this._width = w;
			this._height = h;

			this.mouseChildren = false;
			this.buttonMode = true;

			name_tf = InspectorTextField.create('property name', 0xcccccc, 12, 0, 0, 'left', 'left');
			name_tf.height = _height - 2;
			addChild(name_tf);

			_icon = new Bitmap(InspectorSymbolIcon.getIcon(InspectorSymbolIcon.UNKNOWN));
			addChild(_icon);

			this.addEventListener(MouseEvent.ROLL_OVER, onMouseAct);
			this.addEventListener(MouseEvent.ROLL_OUT, onMouseAct);
			this.addEventListener(MouseEvent.CLICK, onMouseAct);

			this.relayout();
		}

		protected function drawBg(bgColor : uint = 0x282828) : void {
			this.graphics.clear();
			this.graphics.beginFill(bgColor);
			// this.graphics.drawRoundRect(0, 0, Math.max(name_tf.x + name_tf.textWidth + 16, _width), _height, 5, 5);
			this.graphics.drawRoundRect(20, 0, name_tf.textWidth + 4, _height, 5, 5);
			this.graphics.endFill();
		}

		protected function onMouseAct(evt : MouseEvent) : void {
			if(evt.type == MouseEvent.ROLL_OUT) {
				this.drawBg(0x282828);
			} else if(evt.type == MouseEvent.ROLL_OVER) {
				this.drawBg(0x444444);
			} else if(evt.type == MouseEvent.CLICK) {
			}
		}

		protected function relayout() : void {
			_icon.x = 0;
			_icon.y = 2;
			name_tf.x = 20;
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

		/***************************/
		/***************************/
		/***************************/
		/***************************/
		public function set data(value : Object) : void {
			_loadedLog = value as LoadedStuffInfo;

			this._icon.bitmapData = InspectorSymbolIcon.getFileIcon(_loadedLog.contentType);
			this.label = this.getBriefUrl(_loadedLog.url);
		}

		public function set label(val : String) : void {
			name_tf.text = (val == null ? '' : val);

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
	}
}
