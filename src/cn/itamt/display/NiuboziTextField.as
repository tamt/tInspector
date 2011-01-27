package cn.itamt.display {
	import flash.display.Sprite;
	import flash.text.engine.TextLine;

	/**
	 * 扭脖子文本框
	 * @playerversion 10.0
	 * @author tamt
	 */
	public class NiuboziTextField extends Sprite {
		
		private var _text:String;
		
		public function NiuboziTextField() {
		}
		
		public function set text(val:String):void {
			_text = val;
		}
		
		public function get text():String {
			return _text;
		}
		
	}
}