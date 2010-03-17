package cn.itamt.utils.inspector.renders {
	import flash.display.Sprite;				

	/**
	 * @author itamt@qq.com
	 */
	public class BasePropertyEditor extends Sprite {
		protected var _width : Number = 30;
		protected var _height : Number = 20;

		protected var _xml : XML;

		public function BasePropertyEditor() {
		}

		public function setSize(w : Number, h : Number) : void {
			_width = w;
			_height = h;
			
			this.relayOut();
		}

		public function relayOut() : void {
			this.graphics.lineStyle(2, 0x333333);
			this.graphics.drawRoundRect(0, 0, _width, _height, 5, 5);
		}

		public function setXML(target : *, xml : XML) : void {
			_xml = xml;
		}

		public function getValue() : * {
			return null;
		}

		public function getPropName() : String {
			return _xml.@name;
		}
	}
}
