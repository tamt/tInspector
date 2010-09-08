package cn.itamt.utils.inspector.consts {

	/**
	 * @author tamt
	 */
	public class InspectMode {
		public static const DISPLAY_OBJ : String = 'DisplayObject';		public static const INTERACTIVE_OBJ : String = 'InteractiveObject';

		public function InspectMode() {
		}

		public function toString(mode : String) : String {
			switch(mode) {
				case DISPLAY_OBJ:
					return 'DisplayObject Mode';
					break;
				case INTERACTIVE_OBJ:
					return 'InteractiveObject Mode';
					break;
				default:
					return 'undefined mode';
					break;
			}
		}
	}
}