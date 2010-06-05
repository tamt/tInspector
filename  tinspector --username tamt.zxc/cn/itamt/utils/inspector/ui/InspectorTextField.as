package cn.itamt.utils.inspector.ui {
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;	

	/**
	 * @author itamt@qq.com
	 */
	public class InspectorTextField extends TextField {

		private static var fontName : String;
		public static var fonts : Array = ['Verdana', 'Lucida Console', 'Monaco', 'Comic Sans MS'];

		private var defaultTfmHtmlStr : String;

		public function InspectorTextField(text : String = 'tInspector', color : uint = 0xffffff, size : uint = 14, x : Number = 0, y : Number = 0, autoSize : String = 'none', align : String = 'left') {
			
			var tfm:TextFormat = new TextFormat();
			tfm.size = size;
			tfm.align = align;
			
			if(fontName == null) {
				fontName = getNameOfFirstAvaliableFont(fonts);
				if(fontName == null)fontName = 'none';
			}
			if(fontName != 'none')tfm.font = fontName;
			
			this.setTextFormat(tfm);
			this.defaultTextFormat = tfm;
			
			this.text = text;
			
			this.textColor = color;
			this.autoSize = autoSize;
			this.x = x;
			this.y = y;
		}
		
		override public function set defaultTextFormat(tfm:TextFormat):void{
			super.defaultTextFormat = tfm;
			
			super.htmlText = '-';
			var t:int = this.htmlText.indexOf('-</');
			this.defaultTfmHtmlStr = this.htmlText.slice(0, t) + this.htmlText.slice(t+1);
			super.htmlText = '';
		}

		/**
		 * 重写htmlText setter主要是为了解决defaultTextFormat的bug，该bug可详细参见：http://www.itamt.org/blog/index.php/htmltext-in-textfiel/
		 */
		override public function set htmlText(value:String):void{
			if(this.defaultTextFormat){
				var t:int = this.defaultTfmHtmlStr.indexOf('</');
				super.htmlText = this.defaultTfmHtmlStr.substring(0, t) + value + this.defaultTfmHtmlStr.substring(t);
			} else{
				super.htmlText = value;
			}
		}

		/**
		 * 創建文本框的工廠模式.
		 */
		public static function create(text : String = 'tInspector', color : uint = 0xffffff, size : uint = 14, x : Number = 0, y : Number = 0, autoSize : String = 'none', align : String = 'left') : InspectorTextField {
			return new InspectorTextField(text, color, size, x, y, autoSize, align);
		}

		public static function getNameOfFirstAvaliableFont(arr : Array) : String {
			var allFonts : Array = Font.enumerateFonts(true);
			for(var i : int = 0;i < arr.length;i++) {
				for(var a : int = 0;a < allFonts.length;a++) {
					if((allFonts[a] as Font).fontName == arr[i])return arr[i];
				}
			}
			return null;
		}
	}
}
