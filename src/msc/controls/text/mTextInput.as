package msc.controls.text {
	import msc.display.mSprite;
	import msc.events.mTextEvent;
	import msc.input.KeyCode;

	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	/**
	 * @author itamt@qq.com
	 */
	public class mTextInput extends mSprite {
		//////////////////////////////////////
		//////////public variables////////////
		//////////////////////////////////////
		
		//////////////////////////////////////
		//////////private variables///////////
		//////////////////////////////////////
		protected var _tf : mTextField;

		//////////////////////////////////////
		////////////setter, getter////////////
		//////////////////////////////////////
		public function set text(value : String) : void {
			_tf.text = value;
		}

		public function get text() : String {
			return _tf.text;
		}

		public function get textField() : TextField {
			return _tf;
		}

		public function setTextFormat(format : TextFormat, beginIndex : int = -1, endIndex : int = -1) : void {
			_tf.setTextFormat(format, beginIndex, endIndex);
		}

		public function set defaultTextFormat(format : TextFormat) : void {
			_tf.defaultTextFormat = format;
		}

		//////////////////////////////////////
		////////////constructor///////////////
		//////////////////////////////////////
		public function mTextInput() {
			_w = 200;
			_h = 18;
		}

		//////////////////////////////////////
		////////////override funcions/////////
		//////////////////////////////////////
		override protected function init() : void {
			super.init();
			
			_tf = new mTextField();
			_tf.text = '';
			_tf.type = TextFieldType.INPUT;
			_tf.border = true;
			_tf.borderColor = 0;
			_tf.height = _h;
			_tf.width = _w;
			_tf.multiline = false;
			this.addChild(_tf);
			
			_tf.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);			_tf.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		}

		override public function relayout() : void {
			_tf.width = _w;
			_tf.height = _h;
		}

		override protected function destroy() : void {
			_tf.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_tf.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);			_tf.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			_tf = null;
			
			super.destroy();
		}

		//////////////////////////////////////
		//////////private functions///////////
		//////////////////////////////////////
		protected function onKeyUp(evt : KeyboardEvent) : void {
			if(evt.keyCode == KeyCode.ENTER) {
				dispatchEvent(new mTextEvent(mTextEvent.ENTER, _tf.text, true, true));
			}
		}

		private function onFocusIn(evt : FocusEvent) : void {
			_tf.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		private function onFocusOut(evt : FocusEvent) : void {
			_tf.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		//////////////////////////////////////
		/////////public functions/////////////
		//////////////////////////////////////
		/**
		 * 清除值
		 */
		public function clear() : void {
			_tf.text = '';
			_tf.dispatchEvent(new Event(Event.CHANGE));
		}
	}
}
