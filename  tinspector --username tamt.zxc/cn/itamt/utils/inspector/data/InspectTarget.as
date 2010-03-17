package cn.itamt.utils.inspector.data {
	import flash.display.DisplayObject;			

	/**
	 * 查看目标
	 * @author tamt
	 */
	public class InspectTarget {

		private var _dp : DisplayObject;

		public function get displayObject() : DisplayObject {
			return _dp;
		}

		private var ox : Number;
		private var oy : Number;

		public function InspectTarget(dp : DisplayObject) : void {
			this._dp = dp;
			
			ox = this._dp.x;
			oy = this._dp.y;
		}

		/**
		 * 判断两个InspectTarget是否相等
		 */
		public function isEqual(inspectTarget : InspectTarget) : Boolean {
			return this._dp == inspectTarget.displayObject;
		}

		/**
		 * 重置
		 */
		public function resetTarget() : void {
			if(_dp) {
				_dp.x = ox;
				_dp.y = oy;
			}
		}

		public function dispose() : void {
			_dp = null;
		}
	}
}
