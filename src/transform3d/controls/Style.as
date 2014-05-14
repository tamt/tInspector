package transform3d.controls 
{
	/**
	 * control style
	 * @author tamt
	 */
	public class Style
	{
		public var fillColor:uint;
		public var fillAlpha:Number;
		
		public var borderColor:uint;
		public var borderAlpha:Number;
		
		public var borderThickness:Number;
		
		public function Style(fillColor:uint = 0x0000ff, fillAlpha:Number = NaN, borderColor:uint = 0x000000, borderAlpha:Number = NaN, borderThickness:Number = 1) 
		{
			this.fillColor = fillColor;
			this.fillAlpha = fillAlpha;
			this.borderColor = borderColor;
			this.borderAlpha = borderAlpha;
			this.borderThickness = borderThickness;
		}
		
		/**
		 * clone this Style
		 * @return copied of this Style
		 */
		public function clone():Style {
			return new Style(this.fillColor, this.fillAlpha, this.borderColor, this.borderAlpha, this.borderThickness);
		}
		
	}

}
