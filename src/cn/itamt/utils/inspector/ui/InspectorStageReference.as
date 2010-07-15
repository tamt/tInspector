package cn.itamt.utils.inspector.ui {
	import flash.geom.Matrix;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;

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

		public static function addEventListener(type : String,  listener : Function, useCapture : Boolean = false, priority : uint = 0, useWeakReference : Boolean = false) : void {
			_stage.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public static function removeEventListener(type : String,  listener : Function) : void {
			_stage.removeEventListener(type, listener);
		}

		public static function getStageBounds() : Rectangle {
			var rect : Rectangle;
			if(_stage.scaleMode == StageScaleMode.NO_SCALE) {
				switch(_stage.align) {
					case StageAlign.TOP:
						rect = new Rectangle(-offsetStageWidth, 0, stageWidth, stageHeight);
						break;
					case StageAlign.BOTTOM:
						rect = new Rectangle(-offsetStageWidth, -(stageHeight - originalStageHeight), stageWidth, stageHeight);
						break;
					case StageAlign.LEFT:
						rect = new Rectangle(0, -offsetStageHeight, stageWidth, stageHeight);
						break;
					case StageAlign.RIGHT:
						rect = new Rectangle(-(stageWidth - originalStageWidth), -offsetStageHeight, stageWidth, stageHeight);
						break;
					case StageAlign.TOP_LEFT:
						rect = new Rectangle(0, 0, stageWidth, stageHeight);
						break;
					case StageAlign.TOP_RIGHT:
						rect = new Rectangle(-(stageWidth - originalStageWidth), 0, stageWidth, stageHeight);
						break;
					case StageAlign.BOTTOM_LEFT:
						rect = new Rectangle(0, -(stageHeight - originalStageHeight), stageWidth, stageHeight);
						break;
					case StageAlign.BOTTOM_RIGHT:
						rect = new Rectangle(-(stageWidth - originalStageWidth), -(stageHeight - originalStageHeight), stageWidth, stageHeight);
						break;
					case "":
						rect = new Rectangle(offsetStageWidth, offsetStageHeight, stageWidth, stageHeight);
						break;
				}
			}
			return rect;
		}

		/**
		 * 把一个显示对象在舞台上居中
		 */
		public static function centerOnStage(obj : DisplayObject) : void {
			if(obj.stage) {
				var rect : Rectangle = obj.getRect(obj);
				obj.x = stageWidth / 2 - obj.width / 2 - offsetStageWidth - rect.x;
				obj.y = stageHeight / 2 - obj.height / 2 - offsetStageHeight - rect.y;
			}
		}

		public static function getConcatenatedMatrix() : Matrix {
			var rect : Rectangle = getStageBounds();
			var matrix : Matrix = new Matrix(1, 0, 0, 1, rect.left, rect.top);
			return matrix;
		}
	}
}
