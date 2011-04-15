package cn.itamt.utils.inspector.ui.style {
	/**
	 * @author tamt
	 */
	public class Style {
		
		//background color
		public var bgColor : uint;
		//background alpha
		public var bgAlpha:Number;
		//border color
		public var bColor:uint;
		//border alpha
		public var bAlpha:Number;
		
		public function Style(borderColor:uint = 0, borderAlpha:Number = 1, backgroundColor:uint = 0, backgroundAlpha:Number = 1){
			this.bgColor = backgroundColor;
			this.bgAlpha = backgroundAlpha;
			this.bAlpha = borderAlpha;
			this.bColor = borderColor;
		}
	}
}
