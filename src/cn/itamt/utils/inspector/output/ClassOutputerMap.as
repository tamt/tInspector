package cn.itamt.utils.inspector.output {
	import flash.utils.Dictionary;

	/**
	 * @author itamt@qq.com
	 */
	public class ClassOutputerMap {

		private var _map : Dictionary;

		public function ClassOutputerMap() : void {
		}

		public function add(outputer : DisplayObjectInfoOutPuter, clazz : Class) : void {
			if(_map == null)_map = new Dictionary(true);
			_map[clazz] = outputer;
		}

		public function getOutPuter(clazz : Class) : DisplayObjectInfoOutPuter {
			return _map[clazz];
		}
	}
}
