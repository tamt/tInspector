package cn.itamt.utils.inspector.firefox {
	import cn.itamt.utils.Debug;

	import msc.console.mConsoleConnName;
	import msc.console.mConsoleMonitor;

	/**
	 * @author itamt@qq.com
	 */
	public class finspectorController extends mConsoleMonitor {
		public var enable : Boolean = false;

		public function finspectorController() {
			super();
		}

		/**
		 * build connection to tInspectorPreloader.
		 */
		override public function buildConnection(id : String, name : String = null) : void {
			super.buildConnection(id, name);

			if(enable) {
				Debug.trace('[finspectorController][buildConnection: ' + id + ']try call startInspector()');
				_conn.send(mConsoleConnName.getClientName(id), 'executeCmdLine', "startInspector");
			} else {
				Debug.trace('[finspectorController][buildConnection: ' + id + ']try call stopInspector()');
				_conn.send(mConsoleConnName.getClientName(id), 'executeCmdLine', "stopInspector");
			}
		}

		public function callInspectorFunBySwfUrl(fun : String, name : String = null):void {
			var i : int = _names.indexOf(name);
			if(i >= 0) {
				_conn.send(mConsoleConnName.getClientName(_ids[i]), 'executeCmdLine', fun);
			}
		}
	}
}
