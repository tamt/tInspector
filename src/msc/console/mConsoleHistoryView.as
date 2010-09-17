package msc.console {
	import msc.controls.mSimpleSlider;
	import msc.controls.text.mTextArea;

	import flash.events.Event;

	/**
	 * 显示Log的历史记录
	 * @author itamt[at]qq.com
	 */
	public class mConsoleHistoryView extends mTextArea {
		private var _scroller : mSimpleSlider;

		public function mConsoleHistoryView(w : Number = 200, h : Number = 100, text : String = null) {
			super(w, h, text);
			
			_scroller = new mSimpleSlider(10, _h, 0, 1);
		}

		//////////////////////////////////////
		////////////override funcions/////////
		//////////////////////////////////////
		override protected function init() : void {
			super.init();
			
			_scroller.alpha = .5;
			addChild(_scroller);
			
			_scroller.addEventListener(Event.CHANGE, onSliderScroll)
			_tf.addEventListener(Event.SCROLL, onTextScroll);
		}

		override public function relayout() : void {
			super.relayout();
			
			//			if(_tf.textHeight > _tf.height) {
			//				_scroller.visible = true;
			//			} else {
			//				_scroller.visible = false;
			//			}
			_scroller.resize(10, _h);
			_scroller.x = _w - _scroller.width;
		}

		//////////////////////////////////////
		//////////private functions///////////
		//////////////////////////////////////
		private function onSliderScroll(evt : Event) : void {
			_tf.scrollV = _scroller.value * _tf.maxScrollV;
		}

		private function onTextScroll(evt : Event) : void {
			_scroller.value = (_tf.scrollV / _tf.maxScrollV);
		}
	}
}
