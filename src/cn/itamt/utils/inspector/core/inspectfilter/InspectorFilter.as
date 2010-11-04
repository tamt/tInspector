package cn.itamt.utils.inspector.core.inspectfilter {
	import cn.itamt.utils.ClassTool;

	/**
	 * 查看過濾器數據
	 * @author itamt@qq.com
	 */
	public class InspectorFilter {
		private var _class : Class;

		public function InspectorFilter(clazz : Class) {
			this._class = clazz;
		}

		public function toString() : String {
			//			return getQualifiedClassName(_class);
			return 'filter: ' + ClassTool.getShortClassName(_class);
		}
	}
}
