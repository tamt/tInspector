package cn.itamt.utils.inspector.plugins.gerrorkeeper {
	import flash.events.ErrorEvent;
	import flash.utils.getTimer;

	/**
	 * @author itamt[at]qq.com
	 */
	public class ErrorLog {
		protected var _type : String = ErrorLogType.UNKNOWN;
		protected var _date : Date;
		protected var _time : int;

		protected var _error : *;

		public function get type() : String {
			return _type;
		}

		public function get date() : Date {
			return _date;
		}

		public function get time() : int {
			return _time;
		}

		public function get error() : * {
			return _error;
		}

		public function get message() : String {
			if(_type == ErrorLogType.ERROR) {
				return (_error as Error).message;
			}else if(_type == ErrorLogType.ERROR_EVENT) {
				return (_error as ErrorEvent).text;
			}
			
			return String(_error);
		}

		public function get name() : String {
			if(_type == ErrorLogType.ERROR) {
				return (_error as Error).name;
			}else if(_type == ErrorLogType.ERROR_EVENT) {
				return (_error as ErrorEvent).type;
			}
			
			return ErrorLogType.UNKNOWN;
		}

		public function ErrorLog(evtError : *) : void {
			if(evtError) {
				if(evtError is Error) {
					_type = ErrorLogType.ERROR;
				}else if(evtError is ErrorEvent) {
					_type = ErrorLogType.ERROR_EVENT;
				} else {
					_type = ErrorLogType.UNKNOWN;
				}
			} else {
				_type = ErrorLogType.UNKNOWN;
			}
			
			_date = new Date();
			_time = getTimer();
			
			_error = evtError;
		}

		public function toString() : String {
			var t : String = "[" + _date.toLocaleTimeString() + "]" + "[" + _time / 100 + "]";
			if(_type == ErrorLogType.ERROR) {
				var err : Error = _error as Error;
				t += err.toString();
			}else if(_type == ErrorLogType.ERROR_EVENT) {
				var evt : ErrorEvent = _error as ErrorEvent;
				t += evt.toString();
			} else {
				t += String(_error);
			}
			
			return t;
		}
	}
}
