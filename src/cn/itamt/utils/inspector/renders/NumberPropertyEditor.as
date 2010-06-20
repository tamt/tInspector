package cn.itamt.utils.inspector.renders {

	/**
	 * @author itamt@qq.com
	 */
	public class NumberPropertyEditor extends StringPropertyEditor {

		public function NumberPropertyEditor() {
			super();
			
			this.value_tf.restrict = '.0-9\\-';
		}

		override public function getValue() : * {
			return Number(value_tf.text);
		}
	}
}
