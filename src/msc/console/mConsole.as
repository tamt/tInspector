package msc.console {
	import cn.itamt.utils.Debug;

	import flash.display.Shape;
	import flash.events.AsyncErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.utils.describeType;

	/**
	 * 控制台，方便开发、调试的工具。
	 * <code>
	 * 	mConsole.init();
	 * 	mConsole.addDelegate(new CustomConsoleCmdDelegate());
	 * </code>
	 * @author itamt@qq.com
	 */
	public class mConsole extends Shape {
		// ////////////////////////////////////
		// ////////static variables////////////
		// ////////////////////////////////////
		public static const VERSION : String = 'mConsole 1.0 beta';

		private static var _instance : mConsole;

		// ////////////////////////////////////
		// ////////static functions////////////
		// ////////////////////////////////////
		public static function init(connectMonitor : Boolean = true) : void {
			if(_instance == null) {
				_instance = new mConsole(new SingletonEnforcer());
			}
			_instance.init(connectMonitor);
		}

		/**
		 * 连接到Monitor
		 */
		public static function connectMonitor() : void {
			if(_instance)
				_instance.connectMonitor();
		}

		/**
		 * 断开该Console与Monitor的连接
		 */
		public static function disconnectMonitor() : void {
			if(_instance)
				_instance.disconnectMonitor();
		}

		/**
		 * 调用Monitor之Proxy的方法
		 */
		public static function callMonitorProxyFun(fun : String, ...paras) : void {
			if(_instance)
				_instance.callMonitorProxyFun(fun, paras);
		}

		/**
		 * 添加一个'命令库'
		 */
		public static function addDelegate(delegate : mIConsoleDelegate) : void {
			_instance.addDelegate(delegate);
		}

		/**
		 * 代替系统trace的方法
		 */
		public static function trace(...args) : void {
			_instance.dispatchEvent(new mConsoleLogEvent(new mConsoleLog(args.toString(), mConsoleLogType.TRACE)));
		}

		/**
		 * 提供给程序调用的，输出错误信息的接口。
		 */
		public static function error(...args) : void {
			_instance.dispatchEvent(new mConsoleLogEvent(new mConsoleLog(args.toString(), mConsoleLogType.ERROR)));
		}

		// ////////////////////////////////////
		// ////////private variables///////////
		// ////////////////////////////////////
		// 控制台通道，供客户端调用
		private var _conn : LocalConnection;
		private var _inited : Boolean;
		private var _delegates : Array;
		// 是否已经连接了客户端
		private var _clientConnected : Boolean;
		// 该console的id
		private var _id : String;

		public function get id() : String {
			return _id;
		}

		// ////////////////////////////////////
		// //////////constructor///////////////
		// ////////////////////////////////////
		public function mConsole(se : SingletonEnforcer) {
			if(se == null) {
				throw new Error('Singleton!!');
			}

			_id = new Date().getTime().toString();
		}

		// ////////////////////////////////////
		// ////////private functions///////////
		// ////////////////////////////////////
		private function onLogEvent(evt : mConsoleLogEvent) : void {
			_conn.send(mConsoleConnName.CLIENT, 'addLogMessage', evt.log.msg, evt.log.type, id);
		}

		private function onSecurityError(evt : SecurityErrorEvent) : void {
			dispatchEvent(new mConsoleLogEvent(new mConsoleLog(evt.text, mConsoleLogType.ERROR)));
		}

		private function onAsyncError(evt : AsyncErrorEvent) : void {
			dispatchEvent(new mConsoleLogEvent(new mConsoleLog(evt.text, mConsoleLogType.ERROR)));
		}

		private function onStatus(event : StatusEvent) : void {
			switch (event.level) {
				case "status":
					break;
				case "error":
					// dispatchEvent(new mConsoleLogEvent(new mConsoleLog('error: ' + event.code, mConsoleLogType.ERROR)));
					break;
				case "warning":
					// dispatchEvent(new mConsoleLogEvent(new mConsoleLog('warning: ' + event.code, mConsoleLogType.ERROR)));
					break;
				default:
					// dispatchEvent(new mConsoleLogEvent(new mConsoleLog(event.code, mConsoleLogType.ERROR)));
					break;
			}
		}

		// ////////////////////////////////////
		// ////////public functions////////////
		// ////////////////////////////////////
		public function init(connect2Monitor : Boolean = true) : void {
			if(_inited)
				return;
			_inited = true;

			if(connect2Monitor) {
				this.connectMonitor();
			}

			// 侦听log事件
			this.addEventListener(mConsoleLogEvent.LOG, onLogEvent);

			// 添加内置的一些命令
			var defaultDelegate : mDefaultConsoleCmdDelegate = new mDefaultConsoleCmdDelegate();
			defaultDelegate.setConsole(this);
			this.addDelegate(defaultDelegate);
		}

		/**
		 * 连接到Monitor
		 */
		public function connectMonitor() : void {
			if(_clientConnected)
				return;
			_clientConnected = true;
			// 控制台通道，供客户端调用
			_conn = new LocalConnection();
			_conn.allowInsecureDomain("*");
			_conn.allowDomain("*");
			_conn.client = this;
			_conn.connect(mConsoleConnName.getConsoleConnName(id));
			Debug.trace('[mConsole][connectMonitor]' + mConsoleConnName.getConsoleConnName(id));
			try {
				// _conn.connect(mConsoleConnName.CONSOLE);
			} catch(e : Error) {
				return;
			}

			_conn.addEventListener(StatusEvent.STATUS, onStatus);
			_conn.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_conn.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			_conn.send(mConsoleConnName.CLIENT, 'buildConnection', id);
		}

		public function disconnectMonitor() : void {
			if(!_clientConnected)
				return;
			Debug.trace('[mConsole][disconnectMonitor]' + mConsoleConnName.getConsoleConnName(id));
			_conn.send(mConsoleConnName.CLIENT, 'deconstructConnection', id);
		}

		public function callMonitorProxyFun(fun : String, ...paras) : void {
			if(!_clientConnected)
				return;
			Debug.trace('[mConsole][callMonitorProxyFun]');
			_conn.send(mConsoleConnName.CLIENT, 'callProxyFun', fun, paras);
		}

		/**
		 * 供测试连接连接的API
		 */
		public function onBuildConnection() : void {
			Debug.trace('[mConsole][onBuildConnection]' + mConsoleConnName.getConsoleConnName(id));
			_clientConnected = true;

			dispatchEvent(new mConsoleLogEvent(new mConsoleLog(VERSION, mConsoleLogType.CONSOLE)));

			// 设置客户端词语字典
			for each(var delegate:mIConsoleDelegate in _delegates) {
				var xml : XML = describeType(delegate);
				for each(var method:XML in xml.method) {
					_conn.send(mConsoleConnName.CLIENT, 'addToCmdDictionary', String(method.@name), id);
				}
			}
		}

		public function onDeconstructConnection() : void {
			_clientConnected = false;
			dispatchEvent(new mConsoleLogEvent(new mConsoleLog('deconstructConnection: ' + id, mConsoleLogType.CONSOLE)));

			Debug.trace('[mConsole][onDeconstructConnection]' + mConsoleConnName.getConsoleConnName(id));

			_conn.close();
			_conn.removeEventListener(StatusEvent.STATUS, onStatus);
			_conn.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_conn.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
		}

		/**
		 * 添加一个新的Delegate
		 */
		public function addDelegate(delegate : mIConsoleDelegate) : void {
			if(_delegates == null)
				_delegates = [];
			if(_delegates.indexOf(delegate) < 0) {
				_delegates.push(delegate);

				if(_clientConnected) {
					// 设置客户端词语字典
					var xml : XML = describeType(delegate);
					for each(var method:XML in xml.method) {
						_conn.send(mConsoleConnName.CLIENT, 'addToCmdDictionary', String(method.@name), id);
					}
				}
			}
		}

		/**
		 * 这是供Monitor调用的接口：执行一条命令行
		 */
		public function executeCmdLine(cmdLineStr : String) : Boolean {
			Debug.trace('[mConsole][executeCmdLine]' + cmdLineStr);

			var params : Array = cmdLineStr.split(" ");
			var funName : String = params.shift();

			for each(var delegate:mIConsoleDelegate in _delegates) {
				if(!delegate['hasOwnProperty'](funName))
					continue;
				try {
					(delegate[funName] as Function).apply(this, params);
				} catch(e : Error) {
					dispatchEvent(new mConsoleLogEvent(new mConsoleLog(e.message, mConsoleLogType.ERROR)));
					return false;
				}
				return true;
			}

			dispatchEvent(new mConsoleLogEvent(new mConsoleLog('不存在' + funName + '的方法', mConsoleLogType.ERROR)));
			return false;
		}

		public function getAllMethodsName() : Array {
			if(_delegates == null)
				return null;

			var arr : Array = [];
			for each(var delegate:mIConsoleDelegate in _delegates) {
				var xml : XML = describeType(delegate);
				for each (var method : XML in xml.method) {
					arr.push(String(method.@name));
				}
			}
			return arr;
		}

		public function destroy() : void {
			if(!_inited)
				return;
			_inited = false;

			_conn.close();
			_conn = null;
		}
	}
}

class SingletonEnforcer {
}