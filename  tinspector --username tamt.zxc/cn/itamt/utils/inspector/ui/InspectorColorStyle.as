package cn.itamt.utils.inspector.ui {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.utils.getQualifiedClassName;	

	/**
	 * TODO:增加TextField, Loader, Video, AVM1Movie, StaticText, MorphShape(完整AS3显示对象类)类型.
	 * @author tamt
	 */
	public class InspectorColorStyle {
		public static const MOVIE_CLIP:uint = 0x0098FF;
		public static const SPRITE:uint = 0xff3300;
		public static const SHAPE:uint = 0xff65ff;
		public static const BITMAP:uint = 0x99cc00;
		public static const STAGE:uint = 0x000000;
		public static const DISPLAY_OBJECT:uint = 0xcccccc;
		
		public static const DEFAULT_BG:uint = 0x393939;
		
		public static const TYPE_ARR:Array = ['sprite', 'movie clip', 'bitmap', 'shape', 'textfield', 'loader', 'video', 'avm1movie', 'static text', 'morphshape'];
		
		public static function getObjectColor(src:DisplayObject):uint{
			var mc:Array = [];
			
			var str : String = getQualifiedClassName(src);
			var classNameStr:String = str.slice((str.lastIndexOf('::') >= 0) ? (str.lastIndexOf('::') + 2) : 0);
			
			var lineColor:uint;
			switch(classNameStr) {
				case 'Shape':
					lineColor = InspectorColorStyle.SHAPE;
					break;
				case 'Stage':
					lineColor = InspectorColorStyle.STAGE;
					break;
				case 'Bitmap':
					lineColor = InspectorColorStyle.BITMAP;
					break;
				case 'MovieClip':
					lineColor = InspectorColorStyle.MOVIE_CLIP;
					break;
				case 'Sprite':
					lineColor = InspectorColorStyle.SPRITE;
					break;
				default:
					if(src is Shape) {
						lineColor = InspectorColorStyle.SHAPE;
					}else if(src is Bitmap) {
						lineColor = InspectorColorStyle.BITMAP;
					}else if(src is MovieClip) {
						lineColor = InspectorColorStyle.MOVIE_CLIP;
					}else if(src is Stage) {
						lineColor = InspectorColorStyle.STAGE;
					}else if(src is Sprite) {
						lineColor = InspectorColorStyle.SPRITE;
					}else if(src is DisplayObject) {
						lineColor = InspectorColorStyle.DISPLAY_OBJECT; 
					}
			}
			
			return lineColor;
		}
	}
}
