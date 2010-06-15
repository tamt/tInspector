package cn.itamt.utils.inspector.ui {
	import flash.display.Stage;

	/**
	 * 对Stage的引用
	 * @author itamt@qq.com
	 */
	public class InspectorStageReference {
		private static var _stage : Stage;
		private static var _originalStageWidth : Number;
		private static var _originalStageHeight : Number;

		public static function referenceTo(stage : Stage) : void {
			_stage = stage;
			_originalStageWidth = stage.stageWidth;
			_originalStageHeight = stage.stageHeight;
		}

		public static function get originalStageWidth() : Number {
			return _originalStageWidth;
		}

		public static function get originalStageHeight() : Number {
			return _originalStageHeight;
		}

		public static function get stageWidth() : Number {
			return _stage.stageWidth;
		}

		public static function get stageHeight() : Number {
			return _stage.stageHeight;
		}

		public static function get offsetStageWidth() : Number {
			return (_stage.stageWidth - _originalStageWidth) / 2;
		}

		public static function get offsetStageHeight() : Number {
			return (_stage.stageHeight - _originalStageHeight) / 2;
		}
	}
}
