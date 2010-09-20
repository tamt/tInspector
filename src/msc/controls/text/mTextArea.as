package msc.controls.text {
	import msc.display.mSprite;

	import flash.text.TextFormat;

	/**
	 * @author itamt[at]qq.com
	 */
	public class mTextArea extends mSprite {
		//////////////////////////////////////
		//////////private variables///////////
		//////////////////////////////////////
		protected var _tf : mTextField;
		protected var _defaultTextFormat : TextFormat;

		//////////////////////////////////////
		////////////setter, getter////////////
		//////////////////////////////////////
		public function set text(value : String) : void {
			_tf.text = value;
		}

		public function get text() : String {
			return _tf.text;
		}

		public function get htmlText() : String {
			return _tf.htmlText;
		}

		public function set htmlText(value : String) : void {
			_tf.htmlText = value;
		}

		public function setTextFormat(format : TextFormat, beginIndex : int = -1, endIndex : int = -1) : void {
			_tf.setTextFormat(format, beginIndex, endIndex);
		}

		public function set defaultTextFormat(format : TextFormat) : void {
			_defaultTextFormat = format;
			_tf.defaultTextFormat = _defaultTextFormat;
		}

		//////////////////////////////////////
		////////////constructor///////////////
		//////////////////////////////////////
		/**
		 * @param w		高度
		 * @param h		宽度
		 * @param text	
		 */
		public function mTextArea(w : Number = 200, h : Number = 100, text : String = null) {
			_w = 200;
			_h = 100;
			
			_tf = new mTextField();
			_tf.multiline = true;
			_tf.wordWrap = true;
			_tf.border = true;
			_tf.borderColor = 0x000000;
		}

		//////////////////////////////////////
		////////////override funcions/////////
		//////////////////////////////////////
		override protected function init() : void {
			super.init();
			
			addChild(_tf);
		}

		override public function relayout() : void {
			_tf.width = _w;
			_tf.height = _h;
		}

		override protected function destroy() : void {
			_tf = null;
			
			super.destroy();
		}

		//////////////////////////////////////
		/////////public functions/////////////
		//////////////////////////////////////
		public function appendText(text : String) : void {
			_tf.appendText(text);
		}

		public function appendHtmlText(text : String) : void {
			if(_tf.htmlText == null)_tf.htmlText = '';
			_tf.htmlText += text;
		}

		/**
		 * 到最底一行
		 */
		public function scrollVBottom() : void {
			_tf.scrollV = _tf.maxScrollV;
		}

		/**
		 * 修复设置htmlText之后的textFormat失效问题。
		 */
		public function fixDefaultTextFormat() : void {
			var tfm : TextFormat = _defaultTextFormat/* == null ? _tf.getTextFormat() : _defaultTextFormat*/;
			if(tfm == null)return;
			_tf.defaultTextFormat = _defaultTextFormat;
		}

		/**
		 * 清空内容
		 */
		public function clear() : void {
			_tf.text = '';
		}
	}
}
