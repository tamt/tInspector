package cn.itamt.utils.inspector.plugins.swfinfo {
	import cn.itamt.utils.Debug;
	import cn.itamt.utils.inspector.firefox.FlashPlayerEnvironment;
	import cn.itamt.utils.inspector.ui.InspectorStageReference;
	import flash.utils.ByteArray;

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

		protected var _size : Rectangle;

		public function get size() : Rectangle {
			return _size;
		}

		// public function set size(val : SWFSize) : void {
		// _size = val;
		// }

		protected var _compileDate : Date;

		public function get compileDate() : Date {
			return _compileDate;
		}

		public function get playerSize():Rectangle {
			var rect : Rectangle = FlashPlayerEnvironment.getSwfSize();
			if(rect == null)
				return null;
			return rect.clone();
		}

		public function set playerSize(size:Rectangle) : void {
			Debug.trace('[SWFInfo][playerSize]' + size.toString());
			FlashPlayerEnvironment.setSwfSize(size.width, size.height);
		}

		public function SWFInfo(swfRoot : DisplayObject) : void {
			_swfRoot = swfRoot;
			_stage = InspectorStageReference.entity;

			_url = _swfRoot.loaderInfo.url;
			_version = _swfRoot.loaderInfo.swfVersion;
			_playerVersion = Capabilities.version;
			
			var ba:ByteArray = _swfRoot.loaderInfo.bytes;
			var sd:SWFData2 = new SWFData2();
			sd.writeBytes(ba);
			sd.position = 0;
			
			//分析swf数据
			this.parseSWF(sd);
			
			//
			var t : int = FlashPlayerEnvironment.getSwfBgColor();
			if(t >= 0)
				_bgcolor = t;
		}
		
		private function parseSWF(swf:SWFData2):void {
			var header:SWFHeader = new SWFHeader();
			header.sign1 = swf.readUI8();
			header.sign2 = swf.readUI8();
			header.sign3 = swf.readUI8();
			header.version = swf.readUI8();
			header.fileLength = swf.readUI32();
			header.frameSize = swf.readRECT();
			header.frameRate = swf.readFIXED8();
			header.frameCount = swf.readUI16();
			
			_size = new Rectangle(0, 0, header.frameSize.width / 20, header.frameSize.height / 20);
			
			//读取tag信息
			var bgTagFinded:Boolean;
			var productTagFinded:Boolean;
			var hasMetaData:Boolean = false;
			while (true) {
				var tagTypeAndLength:uint = swf.readUI16();
				var tagLength:uint = tagTypeAndLength & 0x003f;
				var tagType:uint = tagTypeAndLength >> 6;
				if (tagLength == 0x3f) {
					// The SWF10 spec sez that this is a signed int.
					// Shouldn't it be an unsigned int?
					tagLength = swf.readSI32();
				}
				
				var pos:uint = swf.position;
				if (tagType == 0) {
					break;
				}else if (tagType == 69) {
					//文件属性读取
					var flags:uint = swf.readUI8();
					hasMetadata = ((flags & 0x10) != 0);
					trace("[SWFInfo-parseSWF]has metadata: " + hasMetaData);
				}else if (tagType == 9) {
					//背景颜色读取
					_bgcolor = swf.readRGB();
					bgTagFinded = true;
				}else if (tagType == 41) {
					//产品信息读取
					swf.readUI32();		//product id,
					swf.readUI32();		//product edition
					swf.readUI8();		//major version
					swf.readUI8();		//minor version
					swf.readUI32();		//minor build number
					swf.readUI32();		//major build number
					//编译日期读取
					var sec:Number = swf.readUI32();
					sec += swf.readUI32() * 4294967296;
					this._compileDate = new Date(sec);
					
					productTagFinded = true;
				}else if (!productTagFinded && hasMetaData && tagType == 77) {
					var xml:XML = new XML(swf.readString());
					productTagFinded = true;
				}
				
				if (bgTagFinded && productTagFinded) {
					break;
				}
				swf.position += tagLength;
			}
		}
	}
}