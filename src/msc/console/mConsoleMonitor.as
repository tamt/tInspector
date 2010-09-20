package msc.console {
	import cn.itamt.utils.Debug;

	import msc.display.mSprite;
	import msc.events.mTextEvent;
	import msc.input.KeyCode;

	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.text.TextFormat;

	/**
	 * 控制台界面。
	 * @author itamt[at]qq.com
	 */
	public class mConsoleMonitor extends mSprite {
		public static const VERSION : String = 'mConsoleMonitor 1.0 beta';
		//////////////////////////////////////
		//////////private functions///////////
		//////////////////////////////////////
		protected var _conn : LocalConnection;

		//信息、命令历史文本区
		protected var _log : mConsoleHistoryView;
		//命令输入文本框
		protected var _cmd : mCmdTextInput;
		//初始的舞台长宽
		private var _initStageW : Number, _initStageH : Number;
		private var _ids : Array;

		//
		public var proxy : *;

		//////////////////////////////////////
		////////////constructor///////////////
		//////////////////////////////////////
		public function mConsoleMonitor() {
			_ids = [];
		}

		//////////////////////////////////////
		////////////override funcions/////////
		//////////////////////////////////////
		override protected function init() : void {
			super.init();
			
			_initStageW = this.stage.stageWidth;
			_initStageH = this.stage.stageHeight;
			
			//界面初始化
			_log = new mConsoleHistoryView();
			_log.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			addChild(_log);
			_cmd = new mCmdTextInput();
			_cmd.addEventListener(mTextEvent.ENTER, onCmdEnter);
			addChild(_cmd);
			
			var tfm : TextFormat = new TextFormat('Verdana', null, 0xffffff);
			tfm.leftMargin = tfm.rightMargin = 4;
			tfm.leading = 4;
			_log.defaultTextFormat = _cmd.defaultTextFormat = tfm;
			
			//舞台大小事件
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.addEventListener(Event.RESIZE, onStageResize);
			
			//本地连接初始化
			_conn = new LocalConnection();
			_conn.allowInsecureDomain("*");
			_conn.allowDomain("*");
			_conn.client = this;

			try {
				_conn.connect(mConsoleConnName.CLIENT);
			}catch(e : Error) {
				return;
			}
			
			Debug.trace('[mConsoleMonitor][init]');
			
			_conn.addEventListener(StatusEvent.STATUS, onStatus);			_conn.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);			_conn.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			//			_conn.send(mConsoleConnName.CONSOLE, 'buildConnection');
			
			//显示版本信息
			addLog(new mConsoleLog(VERSION, mConsoleLogType.CONSOLE));
			
			this.stage.focus = this._cmd.textField;
		}

		override public function relayout() : void {
			_log.setPos(5, 5);
			_cmd.setPos(5, this.stage.stageHeight - _cmd.height - 5);
			
			_log.setSize(this.stage.stageWidth - 10, this.stage.stageHeight - _cmd.height - 16);
			_cmd.setSize(this.stage.stageWidth - 10);
		}

		override protected function destroy() : void {
			_log = null;
			_cmd = null;
			_conn = null;
			
			super.destroy();
		}

		//////////////////////////////////////
		//////////private functions///////////
		//////////////////////////////////////
		private function onStatus(event : StatusEvent) : void {
			switch (event.level) {
				case "status":
					break;
				case "error":
					//					addLog(new mConsoleLog(event.code, mConsoleLogType.ERROR));
					break;
			}
		}

		private function onSecurityError(evt : SecurityErrorEvent) : void {
			addLog(new mConsoleLog(evt.text, mConsoleLogType.ERROR));
		}

		private function onAsyncError(evt : AsyncErrorEvent) : void {
			addLog(new mConsoleLog(evt.text, mConsoleLogType.ERROR));
		}

		private function onStageResize(evt : Event) : void {
			this.relayout();
		}

		private function onCmdEnter(evt : mTextEvent) : void {
			if(evt.text == '' || evt.text == null)return;
			
			this.callFun(evt.text);
		}

		private function onKeyUp(evt : KeyboardEvent) : void {
			if(evt.keyCode == KeyCode.DELETE) {
				_log.clear();
			}
		}

		//////////////////////////////////////
		/////////public functions/////////////
		//////////////////////////////////////
		/**
		 * 连接某个Console
		 */
		public function buildConnection(id : String) : void {
			if(_ids.indexOf(id) < 0) {
				_ids.push(id);
				Debug.trace('[mConsoleMonitor][buildConnection]' + mConsoleConnName.getConsoleConnName(id));
				_conn.send(mConsoleConnName.getConsoleConnName(id), 'onBuildConnection');
			}
		}

		/**
		 * 解除跟某个Console的连接
		 */
		public function deconstructConnection(id : String) : void {
			var t : int = _ids.indexOf(id);
			if(t >= 0) {
				_ids.splice(t, 1);
				Debug.trace('[mConsoleMonitor][deconstructConnection]' + mConsoleConnName.getConsoleConnName(id));
				_conn.send(mConsoleConnName.getConsoleConnName(id), 'onDeconstructConnection');
			}
		}

		/**
		 * 解除所有到Console的连接
		 */
		public function deconstructAllConnections() : void {
			for each(var id:String in _ids) {
				deconstructConnection(id);
			}
		}

		/**
		 * 把一个(cmd)单词加入input字典中
		 */
		public function addToCmdDictionary(word : String, id : String) : void {
			_cmd.addToDictionary(word);
		}

		/**
		 * 往控制台文本里增加一条
		 */
		public function addLog(log : mConsoleLog) : void {
			_log.appendHtmlText(mConsoleLogStyle.buildLogStyleStr(log));
			_log.fixDefaultTextFormat();
			_log.scrollVBottom();
		}

		public function addLogMessage(msg : String, type : uint = 1, id : String = null) : void {
			addLog(new mConsoleLog(msg, type));
		}

		/**
		 * 调用mConsole的方法
		 */
		public function callFun(fun : String, id : String = null) : void {
			addLog(new mConsoleLog(fun));
			//			_conn.send(mConsoleConnName.CONSOLE, 'executeCmdLine', fun);

			for(var i : int = 0;i < _ids.length;i++) {
				Debug.trace('[mConsoleMonitor][callFun]' + mConsoleConnName.getConsoleConnName(_ids[i]) + ', ' + fun);				_conn.send(mConsoleConnName.getConsoleConnName(_ids[i]), 'executeCmdLine', fun);
			}
		}

		public function callProxyFun(fun : String, ...paras) : void {
			Debug.trace('[mConsoleMonitor][callProxyFun]' + fun);
			if(proxy) {
				if(!proxy['hasOwnProperty'](fun))return;
				try {
					(proxy[fun] as Function).apply(proxy, paras);
				}catch(e : Error) {
				}
			}
		}
	}
}