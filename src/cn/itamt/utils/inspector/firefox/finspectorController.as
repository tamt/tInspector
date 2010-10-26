package cn.itamt.utils.inspector.firefox {
	import cn.itamt.utils.Debug;

	import msc.console.mConsoleConnName;
	import msc.console.mConsoleMonitor;

	/**
	 * @author http://activeden.net/user/Flash2Load
	 */
	public class finspectorController extends mConsoleMonitor {
		public var enable : Boolean = false;

		public function finspectorController() {
			super();
		}

		/**
		 * 连接某个Console
		 */
		override public function buildConnection(id : String) : void {
			super.buildConnection(id);

			if(enable) {
				Debug.trace('[finspectorController][buildConnection]try call startInspector()');
				_conn.send(mConsoleConnName.getConsoleConnName(id), 'executeCmdLine', "startInspector");
			} else {
				Debug.trace('[finspectorController][buildConnection]try call stopInspector()');
				_conn.send(mConsoleConnName.getConsoleConnName(id), 'executeCmdLine', "stopInspector");
			}
		}
	}
}
