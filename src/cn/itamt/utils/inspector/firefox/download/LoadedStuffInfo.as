package cn.itamt.utils.inspector.firefox.download {
	import flash.utils.getTimer;
	/**
	 * @author itamt[at]qq.com
	 */
	public class LoadedStuffInfo {
		private var _url : String;
		private var _mime : String;
		private var _date:Date;
		private var _time : int;

		public function LoadedStuffInfo(url : String, mime : String):void {
			this._url = url;
			this._mime = mime;
			
			_date = new Date();
			_time = getTimer();
		}

		public function toString() : String {
			return this._url + ", " + this._mime;
		}
		
		public function get url():String{
			return _url;
		}
		
		public function get mime():String {
			return _mime;
		}
		
		public function get contentType():String {
			return _mime;
		}
	}
}
