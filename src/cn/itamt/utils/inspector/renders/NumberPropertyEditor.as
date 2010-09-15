package cn.itamt.utils.inspector.renders {
	import flash.system.IME;
	import flash.system.Capabilities;
	import flash.events.FocusEvent;

	/**
	 * @author itamt@qq.com
	 */
	public class NumberPropertyEditor extends StringPropertyEditor {

		public function NumberPropertyEditor() {
			super();
			
			this.value_tf.restrict = '.0-9\\-';
		}

		override protected function onFocusIn(evt : FocusEvent) : void {
			super.onFocusIn(evt);
			
			if(Capabilities.hasIME) {
				IME.enabled = false;
			}
		}

		override protected function onFocusOut(evt : FocusEvent) : void {
			super.onFocusOut(evt);
			
			if(Capabilities.hasIME) {
				IME.enabled = true;
			}
		}

		override public function getValue() : * {
			return Number(value_tf.text);
		}
	}
}
