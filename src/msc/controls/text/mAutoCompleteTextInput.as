package msc.controls.text {
	import msc.events.mTextEvent;
	import msc.input.KeyCode;

	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextFormat;

	/**
	 * 拥有自动完成特性的mTextInput
	 * @author itamt@qq.com
	 */
	public class mAutoCompleteTextInput extends mTextInput {
		//////////////////////////////////////
		//////////private variables///////////
		//////////////////////////////////////
		//字典
		protected var _dictionary : String = '';
		//存放与输入词匹配的词语
		protected var _matchArr : Array;
		//显示匹配词语的文本框
		protected var _matchText : mTextField;
		//当前正在输入的词
		protected var _curWordStr : String;
		//当前选中匹配词（通过TAB键选中）
		protected var _curSelectMatchIndex : int;
		//是否在建入时清除值
		public var clearWhenEnter : Boolean = false;

		//////////////////////////////////////
		////////////constructor///////////////
		//////////////////////////////////////		
		public function mAutoCompleteTextInput() {
		}

		//////////////////////////////////////
		////////////override funcions/////////
		//////////////////////////////////////
		override protected function init() : void {
			super.init();
			
			_matchText = new mTextField();
			_matchText.selectable = _matchText.mouseEnabled = _matchText.mouseWheelEnabled = false;
			_matchText.textColor = 0x999999;
			_matchText.autoSize = 'left';
			
			this._tf.addEventListener(Event.CHANGE, onTextChange);
			this._tf.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, onKeyFocusChange);
		}

		override protected function destroy() : void {
			this._tf.removeEventListener(Event.CHANGE, onTextChange);
			this._tf.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, onKeyFocusChange);
			
			_matchArr = null;
			_matchText = null;
			
			super.destroy();
		}

		override public function relayout() : void {
			super.relayout();
			
			if(_matchText)_matchText.y = -_matchText.height - 2;
		}

		override protected function onKeyUp(evt : KeyboardEvent) : void {
			if(evt.keyCode == KeyCode.ENTER) {
				if(_curSelectMatchIndex != -1) {
					var str : String = this._tf.text.slice(0, this._tf.text.lastIndexOf(' ') + 1);
					this._tf.text = str + _matchArr[_curSelectMatchIndex];
					this._tf.setSelection(this._tf.text.length, this._tf.text.length);
					this._tf.dispatchEvent(new Event(Event.CHANGE));
				} else {
					dispatchEvent(new mTextEvent(mTextEvent.ENTER, _tf.text, true, true));
					if(clearWhenEnter)clear();
				}
			}
		}

		//////////////////////////////////////
		//////////private functions///////////
		//////////////////////////////////////

		protected function onTextChange(evt : Event) : void {
			var t : int = this.text.lastIndexOf(' ');
			_curSelectMatchIndex = -1;
			_curWordStr = t >= 0 ? (this.text.slice(t + 1)) : this.text;
			
			if(!_curWordStr.length) {
				if(_matchText.parent)_matchText.parent.removeChild(_matchText);
				return;
			}
			
			_matchArr = getMatchStrArray(_curWordStr);
			if(_matchArr == null) {
				if(_matchText.parent)_matchText.parent.removeChild(_matchText);
			} else {
				setMatchText(_matchArr);
				addChildAt(_matchText, 0);
				relayout();
			}
		}

		/**
		 * 可以重写这个方法：调整matchText的表现形式。
		 */
		protected function setMatchText(matchArr : Array = null) : void {
			_matchText.text = '';
			if(matchArr) {
				_matchText.text = matchArr.toString();
			}
		}

		protected function onKeyFocusChange(evt : FocusEvent) : void {
			if(evt.keyCode == KeyCode.TAB) {
				if(_matchArr && _matchArr.length) {
					_curSelectMatchIndex = (_curSelectMatchIndex + 1 >= _matchArr.length) ? 0 : _curSelectMatchIndex + 1;
					selectMatchWord(_curSelectMatchIndex);
					evt.preventDefault();
				}
			}
		}

		protected function selectMatchWord(index : int) : void {
			var word : String = _matchArr[index];
			var beginIndex : int = _matchText.text.search(new RegExp('\\b' + word + '\\b'));
			_matchText.setTextFormat(new TextFormat(null, null, null, false, null, false));
			_matchText.setTextFormat(new TextFormat(null, null, null, true, null, true), beginIndex, beginIndex + word.length);
			
			dispatchEvent(new mTextEvent(mTextEvent.SELECT, word));
		}

		protected function getMatchStrArray(str : String) : Array {
			var reg : RegExp = new RegExp('\\b' + str + '[^\\s]*', "gi");
			return _dictionary.match(reg);
		}

		//////////////////////////////////////
		/////////public functions/////////////
		//////////////////////////////////////
		/**
		 * 把某个词语加入到字典中
		 */
		public function addToDictionary(value : String) : void {
			//判断词语已经在字典中
			var reg : RegExp = new RegExp('\\b' + value + '\\b', '');
			if(reg.test(_dictionary))return;

			_dictionary += _dictionary.length ? (' ' + value) : value;
		}
	}
}
