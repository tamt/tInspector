package cn.itamt.utils.inspector.plugins.swfinfo {
	import cn.itamt.utils.Debug;
	import cn.itamt.utils.inspector.firefox.FlashPlayerEnvironment;
	import cn.itamt.utils.inspector.ui.InspectorStageReference;

	import com.codeazur.as3swf.SWF;
	import com.codeazur.as3swf.data.SWFRectangle;
	import com.codeazur.as3swf.tags.ITag;
	import com.codeazur.as3swf.tags.TagProductInfo;
	import com.codeazur.as3swf.tags.TagSetBackgroundColor;

	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;

	/**
	 * @author itamt[at]qq.com
	 */
	public class SWFInfo {
		private var _swfRoot : DisplayObject;
		private var _stage : Stage;
		// 这个swf的url地址
		private var _url : String;

		public function get url() : String {
			return _url;
		}

		private var _version : uint;

		public function get version() : uint {
			return _version;
		}

		private var _playerVersion : String;

		public function get player() : String {
			return _playerVersion;
		}

		private var _bgcolor : uint;

		public function set bgcolor(color : uint) : void {
			_bgcolor = color;
			FlashPlayerEnvironment.setSwfBgColor(_bgcolor);
		}

		public function get bgcolor() : uint {
			return _bgcolor;
		}

		/**
		 * 画质
		 */
		[tinspector_enum(type="String", value="BEST,HIGH,LOW,MEDIUM")]

		public function set quality(val : String) : void {
			_stage.quality = val;
		}

		public function get quality() : String {
			return _stage.quality;
		}

		/**
		 * 帧速
		 */
		public function get frameRate() : uint {
			return _stage.frameRate;
		}

		public function set frameRate(num : uint) : void {
			this._stage.frameRate = num;
		}

		/**
		 * 缩放模式
		 */
		[tinspector_enum(type="String", value="exactFit,noBorder,noScale,showAll")]
		public function set scaleMode(mode : String) : void {
			this._stage.scaleMode = mode;
		}

		public function get scaleMode() : String {
			return this._stage.scaleMode;
		}

		public function set contextMenu(bool : Boolean) : void {
			this._stage.showDefaultContextMenu = bool;
		}

		public function get contextMenu() : Boolean {
			return this._stage.showDefaultContextMenu;
		}

		/**
		 * 对齐
		 */
		[tinspector_enum(type="String", value="B,BL,BR,L,R,T,TL,TR")]

		public function set align(val : String) : void {
			_stage.align = val;
		}

		public function get align() : String {
			return _stage.align;
		}

		protected var _size : SWFSize;

		public function get size() : SWFSize {
			return _size;
		}

		// public function set size(val : SWFSize) : void {
		// _size = val;
		// }

		protected var _compileDate : Date;

		public function get compileDate() : Date {
			return _compileDate;
		}

		public function get playerSize() : SWFSize {
			var rect : Rectangle = FlashPlayerEnvironment.getSwfSize();
			if(rect == null)
				return null;
			var size : SWFSize = new SWFSize(rect.width, rect.height);
			return size;
		}

		public function set playerSize(size : SWFSize) : void {
			Debug.trace('[SWFInfo][playerSize]' + size.toString());
			FlashPlayerEnvironment.setSwfSize(size.width, size.height);
		}

		public function SWFInfo(swfRoot : DisplayObject) : void {
			_swfRoot = swfRoot;
			_stage = InspectorStageReference.entity;

			_url = _swfRoot.loaderInfo.url;
			_version = _swfRoot.loaderInfo.swfVersion;
			_playerVersion = Capabilities.version;

			var swf : SWF = new SWF(swfRoot.loaderInfo.bytes);
			var rect : SWFRectangle = swf.frameSize;
			_size = new SWFSize((Number(rect.xmax) / 20 - Number(rect.xmin) / 20), (Number(rect.ymax) / 20 - Number(rect.ymin) / 20));

			for each(var tag:ITag in swf.tags) {
				if(tag is TagSetBackgroundColor) {
					_bgcolor = (tag as TagSetBackgroundColor).color;
				} else if(tag is TagProductInfo) {
					_compileDate = (tag as TagProductInfo).compileDate;
				}
			}

			var t : int = FlashPlayerEnvironment.getSwfBgColor();
			if(t >= 0)
				_bgcolor = t;
		}
	}
}

class SWFSize {
	protected var _width : Number;
	protected var _height : Number;

	public function SWFSize(width : Number, height : Number) : void {
		_width = width;
		_height = height;
	}

	public function toString() : String {
		return _width + ", " + _height;
	}

	public function get width() : Number {
		return _width;
	}

	public function set width(width : Number) : void {
		_width = width;
	}

	public function get height() : Number {
		return _height;
	}

	public function set height(height : Number) : void {
		_height = height;
	}
}