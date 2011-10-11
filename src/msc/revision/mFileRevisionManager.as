package msc.revision
{
	import msc.events.mEventDispatcher;

	import flash.events.AsyncErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	/**
	 * 文本版本管理
	 * @author itamt[at]qq.com
	 */
	public class mFileRevisionManager extends mEventDispatcher
	{
		private static var instance : mFileRevisionManager;

		public static function getInstance() : mFileRevisionManager
		{
			if (instance == null)
			{
				instance = new mFileRevisionManager(new SingletonEnforcer);
				instance.init();
			}

			return instance;
		}

		// 记录当前版本号文件的url
		protected var curFileUrl : String = 'cur.txt';
		// 记录所有版本的文件的url
		protected var revFileUrl : String = 'revision.txt';
		// 当前版本号
		protected var curRev : int;

		// 取得当前版本号
		public function getCurRev() : int
		{
			return curRev;
		}

		protected var cacheSo : SharedObject;
		protected var curFileLoader : URLLoader;
		protected var revFileCacheLoader : URLLoader;
		protected var revFileServerLoader : URLLoader;
		protected var curLoaded : Boolean;
		protected var revCacheLoaded : Boolean;
		protected var revServerLoaded : Boolean;
		protected var revCacheData : mRevisionData;
		protected var revServerData : mRevisionData;
		protected var rootPath : String = '';
		private var _enable : Boolean = false;
		// init方法中指定的版本号
		private var _curRevSettedByInit : Number;
		// 机制启动成功
		protected var success : Boolean = false;

		public function mFileRevisionManager(se : SingletonEnforcer)
		{
			super();
		}

		public function init(cur : Number = NaN) : void
		{
			_curRevSettedByInit = cur;

			cacheSo = SharedObject.getLocal('sc_curRevisionData');
			cacheSo.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onSOAsyncError);

			revFileCacheLoader = new URLLoader();
			revFileCacheLoader.addEventListener(Event.COMPLETE, onRevFileCacheLoaded);
			revFileCacheLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			revFileCacheLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);

			revFileServerLoader = new URLLoader();
			revFileServerLoader.addEventListener(Event.COMPLETE, onRevFileServerLoaded);
			revFileServerLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			revFileServerLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);

			curFileLoader = new URLLoader();
			curFileLoader.addEventListener(Event.COMPLETE, onCurRevLoaded);
			curFileLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			curFileLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);

			revCacheData = new mRevisionData();
			revServerData = new mRevisionData();
		}

		private function onSOAsyncError(evt : Event) : void
		{
			cacheSo = null;
		}

		private function onError(evt : ErrorEvent) : void
		{
			success = false;
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, evt.text));
		}

		private function onRevFileCacheLoaded(evt : Event) : void
		{
			revCacheLoaded = true;
			revCacheData.setRootPath(rootPath);
			revCacheData.setRevCompressedStr(revFileCacheLoader.data);

			if (this.cacheSo != null)
			{
				this.cacheSo.data.cur = revFileCacheLoader.data as String;
				this.cacheSo.flush();
			}

			checkDispatchCompleteEvt();
			loadCurRevision();
		}

		private function onCurRevLoaded(evt : Event) : void
		{
			this.setCurRev(int(curFileLoader.data));
		}

		/**
		 * 设置项目的版本号
		 */
		private function setCurRev(value : int) : void
		{
			this.curLoaded = true;

			this.curRev = int(value);
			if (curRev > revCacheData.getFileRevision(this.rootPath + '/revision.txt'))
			{
				this.loadRevisionFileInServer(revFileUrl);
			}
			else
			{
				revServerLoaded = true;
				revServerData = revCacheData;

				checkDispatchCompleteEvt();
			}
		}

		private function onRevFileServerLoaded(evt : Event) : void
		{
			revServerLoaded = true;
			revServerData.setRootPath(rootPath);
			revServerData.setRevCompressedStr(revFileServerLoader.data);

			if (this.cacheSo != null)
			{
				this.cacheSo.data.cur = revFileServerLoader.data as String;
				this.cacheSo.flush();
			}

			checkDispatchCompleteEvt();
		}

		private function checkDispatchCompleteEvt() : void
		{
			success = (revCacheLoaded && revServerLoaded && curLoaded);
			if (success) dispatchEvent(new Event(Event.COMPLETE));
		}

		/**
		 * 加载浏览器缓中的revision.txt文件
		 */
		protected function loadRevisionFileInCache(url : String = null) : void
		{
			if (url == null) url = revFileUrl;

			if (this.cacheSo == null || this.cacheSo.data == null || this.cacheSo.data.cur == null)
			{
				revFileCacheLoader.load(new URLRequest(url));
			}
			else
			{
				revCacheLoaded = true;
				revCacheData.setRootPath(rootPath);
				revCacheData.setRevCompressedStr(this.cacheSo.data.cur);

				checkDispatchCompleteEvt();
				loadCurRevision();
			}
		}

		/**
		 * 从服务器上加载最新的版本号
		 */
		protected function loadCurRevision(url : String = null) : void
		{
			if (isNaN(_curRevSettedByInit))
			{
				if (url == null) url = curFileUrl;

				var req : URLRequest = new URLRequest(url);

				var variables : URLVariables = new URLVariables();
				variables.t = new Date().getTime();
				req.data = variables;

				curFileLoader.load(req);
			}
			else
			{
				this.setCurRev(this._curRevSettedByInit);
			}
		}

		/**
		 * 加载服务器中的revision.txt文件
		 */
		protected function loadRevisionFileInServer(url : String = null) : void
		{
			if (url == null) url = revFileUrl;
			var req : URLRequest = new URLRequest(url);

			var variables : URLVariables = new URLVariables();
			variables.t = new Date().getTime();
			req.data = variables;

			revFileServerLoader.load(req);
		}

		public function set enable(value : Boolean) : void
		{
			_enable = value;
		}

		public function get enable() : Boolean
		{
			return _enable;
		}

		public function setFileRootPath(path : String = null) : void
		{
			if (path != null)
			{
				rootPath = path;

				if (revCacheLoaded) revCacheData.setRootPath(rootPath);
				if (revServerLoaded) revServerData.setRootPath(rootPath);
			}
		}

		/**
		 * 启动
		 */
		public function start() : void
		{
			this.enable = true;
			this.loadRevisionFileInCache();
		}

		/**
		 * 得到一个文件的URLRequest
		 */
		public function getFileUrlRequest(fileURL : String) : URLRequest
		{
			if (fileURL == null) return null;
			var req : URLRequest = new URLRequest(fileURL);
			if (enable && getFileNeedPreventCache(fileURL))
			{
				req = setRequestPreventCache(req);
			}
			return req;
		}

		/**
		 * 一个文件是否需要“绕浏览器缓存”加载
		 */
		public function getFileNeedPreventCache(fileURL : String) : Boolean
		{
			return true;
			var rCache : int = revCacheData.getFileRevision(fileURL);
			var rServer : int = revServerData.getFileRevision(fileURL);
			var bool : Boolean = enable && success && ( rCache != rServer);
			if (bool)
			{
				trace('[mFileRevisionManager][getFileNeedPreventCache]v:' + rCache + '-' + rServer + '::' + fileURL);
			}
			return bool;
		}

		/**
		 * 给URLRequest加上随机参数
		 */
		public function setRequestPreventCache(req : URLRequest) : URLRequest
		{
			var variables : URLVariables = new URLVariables();
			variables.v = revServerData.getFileRevision(req.url);
			req.data = variables;
			return req;
		}
	}
}
class SingletonEnforcer
{
}
