package cn.itamt.utils.inspector.ui {
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Matrix;
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

			_stage.addEventListener(Event.RESIZE, onStageResize);
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

		public static function get concatenatedStageWidth() : Number {
			var scale : Number = 1.0;
			switch(_stage.scaleMode) {
				case StageScaleMode.NO_BORDER:
					scale = Math.max(stageHeight / originalStageHeight, stageWidth / originalStageWidth);
					break;
				case StageScaleMode.SHOW_ALL:
					scale = Math.min(stageHeight / originalStageHeight, stageWidth / originalStageWidth);
					break;
				case StageScaleMode.EXACT_FIT:
					scale = stageWidth / originalStageWidth;
			}
			return _stage.stageWidth / scale;
		}

		public static function get concatenatedStageHeight() : Number {
			var scale : Number = 1.0;
			switch(_stage.scaleMode) {
				case StageScaleMode.NO_BORDER:
					scale = Math.max(stageHeight / originalStageHeight, stageWidth / originalStageWidth);
					break;
				case StageScaleMode.SHOW_ALL:
					scale = Math.min(stageHeight / originalStageHeight, stageWidth / originalStageWidth);
					break;
				case StageScaleMode.EXACT_FIT:
					scale = stageHeight / originalStageHeight;
			}
			return _stage.stageHeight / scale;
		}

		public static function get offsetStageWidth() : Number {
			return (concatenatedStageWidth - _originalStageWidth) / 2;
		}

		public static function get offsetStageHeight() : Number {
			return (concatenatedStageHeight - _originalStageHeight) / 2;
		}

		public static function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : uint = 0, useWeakReference : Boolean = false) : void {
			_stage.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public static function removeEventListener(type : String, listener : Function) : void {
			_stage.removeEventListener(type, listener);
		}

		public static function getStageBounds() : Rectangle {
			var rect : Rectangle;
			switch(_stage.align) {
				case StageAlign.TOP:
					rect = new Rectangle(-offsetStageWidth, 0, concatenatedStageWidth, concatenatedStageHeight);
					break;
				case StageAlign.BOTTOM:
					rect = new Rectangle(-offsetStageWidth, -(concatenatedStageHeight - originalStageHeight), concatenatedStageWidth, concatenatedStageHeight);
					break;
				case StageAlign.LEFT:
					rect = new Rectangle(0, -offsetStageHeight, concatenatedStageWidth, concatenatedStageHeight);
					break;
				case StageAlign.RIGHT:
					rect = new Rectangle(-(concatenatedStageWidth - originalStageWidth), -offsetStageHeight, concatenatedStageWidth, concatenatedStageHeight);
					break;
				case StageAlign.TOP_LEFT:
					rect = new Rectangle(0, 0, concatenatedStageWidth, concatenatedStageHeight);
					break;
				case StageAlign.TOP_RIGHT:
					rect = new Rectangle(-(concatenatedStageWidth - originalStageWidth), 0, concatenatedStageWidth, concatenatedStageHeight);
					break;
				case StageAlign.BOTTOM_LEFT:
					rect = new Rectangle(0, -(concatenatedStageHeight - originalStageHeight), concatenatedStageWidth, concatenatedStageHeight);
					break;
				case StageAlign.BOTTOM_RIGHT:
					rect = new Rectangle(-(concatenatedStageWidth - originalStageWidth), -(concatenatedStageHeight - originalStageHeight), concatenatedStageWidth, concatenatedStageHeight);
					break;
				default:
					rect = new Rectangle(-offsetStageWidth, -offsetStageHeight, concatenatedStageWidth, concatenatedStageHeight);
					break;
			}
			return rect;
		}

		public static function getBounds(dp : DisplayObject) : Rectangle {
			return dp.getBounds(_stage);
		}

		/**
		 * 把一个显示对象在舞台上居中
		 */
		public static function centerOnStage(obj : DisplayObject) : void {
			// if(obj.stage) {
			var rect : Rectangle = obj.getRect(obj);
			var stageBounds : Rectangle = getStageBounds();
			obj.x = stageBounds.left + concatenatedStageWidth / 2 - obj.width / 2 - rect.x;
			obj.y = stageBounds.top + concatenatedStageHeight / 2 - obj.height / 2 - rect.y;
			// }
		}

		public static function getTransformMatrix() : Matrix {
			var shape : Shape = new Shape();
			_stage.addChild(shape);
			var matrix : Matrix;
			matrix = shape.transform.concatenatedMatrix;
			_stage.removeChild(shape);
			return matrix;
		}

		private static function onStageResize(evt : Event) : void {
			// trace(_stage.stageWidth, _stage.stageHeight);
		}

		public static function addChild(dp : DisplayObject) : DisplayObject {
			return _stage.addChild(dp);
		}

		public static function get entity():Stage {
			return _stage;
		}
	}
}
