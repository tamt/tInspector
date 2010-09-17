package msc.controls.text {
	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * @author itamt[at]qq.com
	 */
	public class mTextField extends TextField {
		public function mTextField() {
			addEventListener(Event.ADDED_TO_STAGE, onAdded, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved, false, 0, true);
		}

		private var inited : Boolean;

		protected function init() : void {
		}

		protected function destroy() : void {
		}

		private function onAdded(evt : Event) : void {
			if(inited)return;
			inited = true;
			init();
		}

		private function onRemoved(evt : Event) : void {
			inited = false;			
			destroy();
		}
	}
}
