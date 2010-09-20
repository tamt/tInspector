package msc.display {
	import msc.console.mConsole;

	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;

	/**
	 * @author itamt[at]qq.com
	 */
	public class mLoader extends Loader {
		private var _inited : Boolean;
		protected var _w : Number, _h : Number;

		public function mLoader() {
			addEventListener(Event.ADDED_TO_STAGE, onAdded, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved, false, 0, true);
			
			this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}

		//////////////////////////////////////
		//////////private functions///////////
		//////////////////////////////////////
		private function onAdded(evt : Event) : void {
			if(_inited)return;
			this.init();
			this.relayout();
		}

		private function onRemoved(evt : Event) : void {
			this.destroy();
		}

		private function onIOError(evt : IOErrorEvent) : void {
			mConsole.error(this.contentLoaderInfo.url + '\n' + evt.text);
		}

		//////////////////////////////////////
		/////////public functions/////////////
		//////////////////////////////////////

		/**
		 * 设置位置
		 */
		public function setPos(x : Number, y : Number) : void {
			this.x = x;
			this.y = y;
		}

		/**
		 * 重新布局（相当于重绘）
		 */
		public function relayout() : void {
		}

		/**
		 * 设置尺寸。程序会自动调用relayout()
		 */
		public function setSize(w : Number = NaN, h : Number = NaN) : void {
			if(_w == w && _h == h)return;
			_w = isNaN(w) ? _w : w;
			_h = isNaN(h) ? _h : h;
			
			this.relayout();
		}

		protected function init() : void {
			_inited = true;
		}

		protected function destroy() : void {
			_inited = false;
		}
	}
}
