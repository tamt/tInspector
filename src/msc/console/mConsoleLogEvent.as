package msc.console {
	import msc.events.mConsoleEvent;

	/**
	 * @author itamt[at]qq.com
	 */
	public class mConsoleLogEvent extends mConsoleEvent {
		public static const LOG : String = 'mConsole_log';

		public var log : mConsoleLog;

		public function mConsoleLogEvent(log : mConsoleLog, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(LOG, bubbles, cancelable);
			
			this.log = log;
		}
	}
}
