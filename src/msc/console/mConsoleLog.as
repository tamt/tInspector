package msc.console {

	/**
	 * @author itamt[at]qq.com
	 */
	public class mConsoleLog {

		public var msg : String;
		public var type : uint;

		private var _time : Date;

		public function get time() : Date {
			return _time;
		}

		public function mConsoleLog(msg : String, type : uint = 1) : void {
			this.msg = msg;
			this.type = type;
			
			_time = new Date();
		}

		public function toString() : String {
			return msg;
		}
	}
}
