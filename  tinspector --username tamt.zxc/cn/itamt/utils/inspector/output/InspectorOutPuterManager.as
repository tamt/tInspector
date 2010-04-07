package cn.itamt.utils.inspector.output {

	/**
	 * 管理各个tInspector信息输出器(Outputer).
	 * 针对某个类指定信息输出器.
	 * @author itamt@qq.com
	 */
	public class InspectorOutPuterManager {
		private var _map : ClassOutputerMap;
		private var _defaultOutputer : DisplayObjectInfoOutPuter;

		public function InspectorOutPuterManager(defaultOutputer : DisplayObjectInfoOutPuter = null) : void {
			_defaultOutputer = defaultOutputer == null ? (new DisplayObjectInfoOutPuter()) : defaultOutputer;
		}

		/**
		 * 设置某个对象类型的信息输出器
		 */
		public function setClassOutputer(clazz : Class, outputer : DisplayObjectInfoOutPuter) : void {
			if(_map == null) {
				_map = new ClassOutputerMap();
			}
			_map.add(outputer, clazz);
		}

		/**
		 * 返回某个对象类型的信息输出器，如果没有设置过该类型的输出器，将返回默认的输出器。
		 */
		public function getOutputerByClass(clazz : Class) : DisplayObjectInfoOutPuter {
			var outputer : DisplayObjectInfoOutPuter;
			if(_map == null) {
				outputer = _defaultOutputer; 
			} else {
				outputer = _map.getOutPuter(clazz);
			}
			if(!outputer) {
				outputer = _defaultOutputer;
			}
			return outputer;
		}

		/**
		 * 返回某个对象的信息输出器，如果没有设置过该类型的输出器，将返回默认的输出器。
		 */
		public function getOutputerByInstance(instance : Object) : DisplayObjectInfoOutPuter {
			return this.getOutputerByClass(instance.constructor as Class);
		}
	}
}