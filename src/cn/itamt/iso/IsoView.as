package cn.itamt.iso
{
	import cn.itamt.display.tSprite;
	/**
	 * 
	 * @author tamt
	 */
	public class IsoView extends tSprite
	{
		
		protected var _w:Number;
		protected var _h:Number;
		
		public function IsoView(width:Number, height:Number) {
			_w = width;
			_h = height;
		}
		
		/**
		 * 把视窗移动到某一点上.
		 */
		public function panTo(screenX:Number, screenY:Number):void{
			
		}
		
		/**
		 * 把视察移动到Iso的某一位置
		 */
		public function panToPos(posX:Number, posY:Number):void{
			
		}
		
		/**
		 * 渲染
		 */
		public function render():void{
			
		}
	}
}
