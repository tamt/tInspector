package msc.console {
	import msc.controls.text.mAutoCompleteTextInput;
	import msc.events.mTextEvent;
	import msc.input.KeyCode;

	import flash.events.KeyboardEvent;
	import flash.text.TextFormat;

	/**
	 * @author itamt[at]qq.com
	 */
	public class mCmdTextInput extends mAutoCompleteTextInput {
		//////////////////////////////////////
		//////////private functions///////////
		//////////////////////////////////////
		//存储键入的命令记录
		private var _history : Array;
		private var _selectHistoryIndex : int = -1;

		//////////////////////////////////////
		////////////override funcions/////////
		//////////////////////////////////////
		override public function get height() : Number {
			return this._tf.height;
		}

		override protected function init() : void {
			super.init();
			
			clearWhenEnter = true;
			
			this._matchText.textColor = 0xffffff;
			this._matchText.multiline = true;
			this._matchText.border = true;
			this._matchText.borderColor = 0;
			this._matchText.background = true;
			this._matchText.backgroundColor = 0x666666;
			this._matchText.alpha = .5;
			var tfm : TextFormat = new TextFormat();
			tfm.font = 'Verdana';
			tfm.leftMargin = tfm.rightMargin = 3;
			this._matchText.defaultTextFormat = tfm;
			
			this.addEventListener(mTextEvent.ENTER, onEnterText);
		}

		override protected function destroy() : void {
			this.removeEventListener(mTextEvent.ENTER, onEnterText);
			
			super.destroy();
		}

		override protected function setMatchText(matchArr : Array = null) : void {
			_matchText.text = '';
			if(matchArr) {
				for each(var match:String in matchArr) {
					_matchText.appendText(match + '\n');
				}
			}
			this.relayout();
		}

		override protected function onKeyUp(evt : KeyboardEvent) : void {
			super.onKeyUp(evt);
			
			if(evt.keyCode == KeyCode.UP) {
				if(_history && _history.length) {
					evt.preventDefault();
					
					this.text = _history[_selectHistoryIndex <= 0 ? 0 : --_selectHistoryIndex];
					this._tf.setSelection(this.text.length, this.text.length);
				}
			}else if(evt.keyCode == KeyCode.DOWN) {
				if(_history && _history.length) {
					evt.preventDefault();
					
					this.text = _history[_selectHistoryIndex >= (_history.length - 1) ? (_history.length - 1) : ++_selectHistoryIndex];
					this._tf.setSelection(this.text.length, this.text.length);
				}
			}
		}

		//////////////////////////////////////
		//////////private functions///////////
		//////////////////////////////////////

		private function onEnterText(evt : mTextEvent) : void {
			if(evt.text == '')return;
			
			if(_history == null)_history = [];
			var t : int = _history.indexOf(evt.text);
			if(t >= 0) {
				_history.slice(t, 1);
			}
			_history.push(evt.text);
			
			_selectHistoryIndex = _history.length;
		}
	}
}
