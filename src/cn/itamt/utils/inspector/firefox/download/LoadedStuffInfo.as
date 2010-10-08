package cn.itamt.utils.inspector.firefox.download {
	import flash.utils.getTimer;

	/**
	 * @author itamt[at]qq.com
	 */
	public class LoadedStuffInfo {
		private var _url : String;
		private var _mime : String;
		private var _date : Date;
		private var _time : int;
		private var _name : String;
		private var _path : String;

		public function LoadedStuffInfo(url : String, mime : String = null):void {
			this._url = url;
			this._mime = mime;
			this._name = this.getFileNameFromUrl();
			this._path = this.getFilePathFromUrl();

			_date = new Date();
			_time = getTimer();
		}

		/*************************************
		 *********public functions************
		 ************************************/
		public function toString() : String {
			return this._url + ", " + this._mime;
		}

		public function get url():String {
			return _url;
		}

		public function get contentType():String {
			return _mime;
		}

		public function get name():String {
			return _name;
		}

		public function get path():String {
			return _path;
		}

		public function get time():int {
			return _time;
		}

		/*************************************
		 *********private functions***********
		 ************************************/
		private function getFileNameFromUrl():String {
			var ret : String;
			var t : String = (_url.indexOf("?") >= 0) ? _url.substring(0, _url.indexOf("?")) : _url;
			var start : int = (t.lastIndexOf("/") >= 0) ? (t.lastIndexOf("/") + 1) : 0;
			var end : int = (t.indexOf("?", start) >= 0) ? t.indexOf("?", start) : t.length;
			ret = t.substring(start, end);
			return ret;
		}

		private function getFilePathFromUrl():String {
			var ret : String;
			var t : String = (_url.indexOf("?") >= 0) ? _url.substring(0, _url.indexOf("?")) : _url;
			ret = t.substring(0, t.lastIndexOf("/") + 1);
			return ret;
		}
	}
}
