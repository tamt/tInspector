package cn.itamt.utils.inspector.ui {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	class StructureElement {
		private var _target : DisplayObject;

		public function get target() : DisplayObject {
			return _target;
		}

		private var _isTargetFather : Boolean;

		public function get isTargetFather() : Boolean {
			return _isTargetFather;
		}

		private var _level : uint;

		public function get level() : uint {
			return _level;
		}

		private var _childs : Array = [];

		public function StructureElement(target : DisplayObject, level : uint, isTargetFather : Boolean = false) : void {
			_target = target;
			_level = level;
			_isTargetFather = isTargetFather;
		}

		public function toString() : String {
			return _target.toString() + ' ' + _level + ' ';
		}

		public function getChilds() : Array {
			var _arr : Array = [];
			if(_target is DisplayObjectContainer) {
				for(var i : int = 0;i < (_target as DisplayObjectContainer).numChildren; i++) {
					_arr.push((_target as DisplayObjectContainer).getChildAt(i));
				}
			}
			return _arr;
		}

		public function set structChildElements(val : Array) : void {
			_childs = val;
		}

		public function get structChildElements() : Array {
			return _childs;
		}

		/**
		 * 销毁对象
		 */
		public function dispose() : void {
		}
	}
}
