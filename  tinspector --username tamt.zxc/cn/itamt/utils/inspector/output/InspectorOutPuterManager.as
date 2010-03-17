package cn.itamt.utils.inspector.output {
	import flash.utils.Dictionary;																							

	/**
	 * 管理各个tInspector信息输出器(Outputer).
	 * 针对某个类指定信息输出器.
	 * @author itamt@qq.com
	 */
	public class InspectorOutPuterManager {
		private var _map : Dictionary;

		public function InspectorOutPuterManager() : void {
		}

		/**
		 * 设置某个对象类型的信息输出器
		 */
		public function setClassOutputer(viewID : String ,outputer : DisplayObjectInfoOutPuter, clazz : Class) : void {
			if(_map == null)_map = new Dictionary(true);
			
			if(_map[viewID] == null) {
				_map[viewID] = new ClassOutputerMap();
			}
			
			var data : ClassOutputerMap = _map[viewID];
			data.add(outputer, clazz);
		}

		/**
		 * 返回某个对象类型的信息输出器
		 */
		public function getOutputerByClass(viewID : String, clazz : Class) : DisplayObjectInfoOutPuter {
			return (_map[viewID] as ClassOutputerMap).getOutPuter(clazz);
		}

		/**
		 * 返回某个对象的信息输出器
		 */
		public function getOutputerByInstance(viewID : String, instance : Object) : DisplayObjectInfoOutPuter {
			return this.getOutputerByClass(viewID, (instance.constructor as Class));
		}
	}
}