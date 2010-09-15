package cn.itamt.utils.inspector.core.propertyview.accessors {
	import flash.display.Sprite;

	/**
	 * @author itamt@qq.com
	 */
	public class BasePropertyEditor extends Sprite {
		protected var _width : Number = 30;
		protected var _height : Number = 20;
		protected var _readable : Boolean = true;
		protected var _value : *;

		public var autoSize : Boolean = true;

		
		public function BasePropertyEditor() {
		}

		public function setSize(w : Number, h : Number) : void {
			_width = w;
			_height = h;
			
			this.relayOut();
		}

		public function relayOut() : void {
			this.graphics.clear();
			this.graphics.lineStyle(2, 0x333333);
			this.graphics.drawRoundRect(0, 0, _width, _height, 5, 5);
		}

		protected function onWriteOnly() : void {
		}

		protected function onReadOnly() : void {
		}

		protected function onReadWrite() : void {
		}

		public function get readable() : Boolean {
			return _readable;
		}

		public function setValue(value : *) : void {
			_value = value;
		}

		/**
		 * @param access	"writeonly", "readonly", "readwrite".
		 */
		public function setAccessType(access : String, exclude : Boolean = false) : void {
			if(access == 'writeonly') {
				_readable = false;
				this.onWriteOnly();
			}else if(access == 'readonly') {
				_readable = true;
				this.onReadOnly();
			}else if(access == 'readwrite') {
				_readable = true;
				if(!exclude) {
					this.onReadWrite();
				} else {
					this.onReadOnly();
				}
			}
		}

		
		
		public function getValue() : * {
			return _value;
		}
	}
}
