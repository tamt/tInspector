package cn.itamt.utils.inspector.consts {
	import cn.itamt.utils.ClassTool;
	import cn.itamt.utils.inspector.ui.InspectorSymbolBmd;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedSuperclassName;	

	/**
	 * @author itamt@qq.com
	 */
	public class InspectorSymbolIcon {
		//['sprite', 'movie clip', 'bitmap', 'shape', 'textfield', 'loader', 'video', 'avm1movie', 'static text', 'morphshape', '+', '-'];
		public static const UNKNOWN : String = 'UNKNOWN';		public static const SPRITE : String = 'Sprite';
		public static const MOVIE_CLIP : String = 'MovieClip';
		public static const BITMAP : String = 'Bitmap';
		public static const SHAPE : String = 'Shape';
		public static const TEXT_FIELD : String = 'TextField';
		public static const LOADER : String = 'Loader';
		public static const VIDEO : String = 'Video';
		public static const AVM1_MOVIE : String = 'AVM1Movie';
		public static const STATIC_TEXT : String = 'StaticText';
		public static const MORPH_SHAPE : String = 'MorphShape';
		public static const SIMPLE_BUTTON : String = 'SimpleButton';		public static const STAGE : String = 'Stage';
		public static const EXPAND : String = '+';
		public static const CLLOAPSE : String = '-';
		//提交bug的图标
		public static const BUG : String = 'bug';
		//收藏
		public static const FAVORITE : String = 'favorite';
		//
		public static const DELETE : String = 'delete';

		private static var assetBmd : InspectorSymbolBmd;
		private static var iconBmds : Array;

		private static var icons : Array = [InspectorSymbolIcon.UNKNOWN,
									InspectorSymbolIcon.SPRITE, 
									InspectorSymbolIcon.MOVIE_CLIP, 
									InspectorSymbolIcon.BITMAP, 
									InspectorSymbolIcon.SHAPE, 
									InspectorSymbolIcon.TEXT_FIELD, 
									InspectorSymbolIcon.LOADER, 
									InspectorSymbolIcon.VIDEO, 
									InspectorSymbolIcon.AVM1_MOVIE, 
									InspectorSymbolIcon.STATIC_TEXT, 
									InspectorSymbolIcon.MORPH_SHAPE, 
									InspectorSymbolIcon.SIMPLE_BUTTON,
									InspectorSymbolIcon.STAGE, 
									InspectorSymbolIcon.EXPAND, 
									InspectorSymbolIcon.CLLOAPSE,
									InspectorSymbolIcon.BUG,
									InspectorSymbolIcon.FAVORITE,
									InspectorSymbolIcon.DELETE];

		
		public static function getIconByClass(clazz : *) : BitmapData {
			var bmd : BitmapData;
			var className : String = ClassTool.getShortClassName(clazz);
			if(icons.indexOf(className) < 0 && className != 'Object') {
				bmd = getIconByClass(getDefinitionByName(getQualifiedSuperclassName(clazz)));
			} else {
				bmd = getIcon(className);
			}
			return bmd;
		}

		/**
		 * 得到一个图标的位图数据.
		 */
		public static function getIcon(iconName : String) : BitmapData {
			if(assetBmd == null) {
				assetBmd = new InspectorSymbolBmd();
				iconBmds = [];
			}
			
			
			var t : int = icons.indexOf(iconName);
			if(t < 0) {
				//				throw new Error('没有这种类型的图标, 用Sprite图标代替.');
				t = 0;
			}
			
			if(!iconBmds[t]) {
				var bmd : BitmapData = new BitmapData(16, 16, true, 0x00000000); 
				bmd.copyPixels(assetBmd, new Rectangle(t * 16, 0, 16, 16), new Point(0, 0));
				iconBmds[t] = bmd;
			}
			return iconBmds[t];
		}
	}
}
