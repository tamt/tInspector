package cn.itamt.utils.inspector.ui {
import cn.itamt.utils.ClassTool;
import cn.itamt.utils.ClassTool;

	import flash.display.AVM1Movie;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MorphShape;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.text.StaticText;
	import flash.text.TextField;

	/**
	 * @author itamt@qq.com
	 */
	public class InspectorSymbolIcon {
		// ['sprite', 'movie clip', 'bitmap', 'shape', 'textfield', 'loader', 'video', 'avm1movie', 'static text', 'morphshape', '+', '-'];
		public static const UNKNOWN : String = 'UNKNOWN';
		public static const SPRITE : String = 'Sprite';
		public static const MOVIE_CLIP : String = 'MovieClip';
		public static const BITMAP : String = 'Bitmap';
		public static const SHAPE : String = 'Shape';
		public static const TEXT_FIELD : String = 'TextField';
		public static const LOADER : String = 'Loader';
		public static const VIDEO : String = 'Video';
		public static const AVM1_MOVIE : String = 'AVM1Movie';
		public static const SWF : String = 'AVM1Movie';
		public static const STATIC_TEXT : String = 'StaticText';
		public static const MORPH_SHAPE : String = 'MorphShape';
		public static const SIMPLE_BUTTON : String = 'SimpleButton';
		public static const STAGE : String = 'Stage';
		public static const EXPAND : String = '+';
		public static const CLLOAPSE : String = '-';
		// 提交bug的图标
		public static const BUG : String = 'bug';
		// 收藏
		public static const FAVORITE : String = 'favorite';
		// 删除
		public static const DELETE : String = 'delete';
		// inspector logo
		public static const LOGO : String = 'inspector_logo';
		public static const INSPECT : String = 'inspector_inspect';
		public static const FOLDER : String = "folder";
		public static const HELP : String = "help";
		//鼠标样式图片
		public static const CURSOR_REG:String = "cursor_reg";
		public static const CURSOR_X:String = "cursor_x";
		public static const CURSOR_Y:String = "cursor_y";
		public static const CURSOR_Z:String = "cursor_z";
		public static const CURSOR_R:String = "cursor_rotation";
		public static const CURSOR_GT:String = "cursor_global_translation";
		public static const CURSOR_S:String = "cursor_scale";
		//transform 3d tool:
		public static const TOOL3D_R:String = "3dtool_rotation";
		public static const TOOL3D_S:String = "3dtool_scale";
		public static const TOOL3D_T:String = "3dtool_translation";
		public static const TOOL3D_M:String = "3dtool_mode";
		public static const TOOL3D_REMOVE_TRANSFORM:String = "3dtool_remove_transform";
		//flash fire bug
		public static const FIREBUG:String = "flash_firebug";
		//flash console
		public static const CONSOLE:String = "flash_console";
		//
		private static var assetBmd : InspectorSymbolBmd;
		private static var iconBmds : Array;
		private static var icons : Array = [InspectorSymbolIcon.UNKNOWN, InspectorSymbolIcon.SPRITE, InspectorSymbolIcon.MOVIE_CLIP, InspectorSymbolIcon.BITMAP, InspectorSymbolIcon.SHAPE, InspectorSymbolIcon.TEXT_FIELD, InspectorSymbolIcon.LOADER, InspectorSymbolIcon.VIDEO, InspectorSymbolIcon.AVM1_MOVIE, InspectorSymbolIcon.STATIC_TEXT, InspectorSymbolIcon.MORPH_SHAPE, InspectorSymbolIcon.SIMPLE_BUTTON, InspectorSymbolIcon.STAGE, InspectorSymbolIcon.EXPAND, InspectorSymbolIcon.CLLOAPSE, InspectorSymbolIcon.BUG, InspectorSymbolIcon.FAVORITE, InspectorSymbolIcon.DELETE, InspectorSymbolIcon.LOGO, InspectorSymbolIcon.INSPECT, InspectorSymbolIcon.FOLDER, InspectorSymbolIcon.HELP, CURSOR_REG, CURSOR_X, CURSOR_Z, CURSOR_Y, CURSOR_R, CURSOR_GT, CURSOR_S, TOOL3D_R, TOOL3D_S, TOOL3D_T, TOOL3D_M, TOOL3D_REMOVE_TRANSFORM, FIREBUG, InspectorSymbolIcon.CONSOLE];
		// ['sprite', 'movie clip', 'bitmap', 'shape', 'textfield', 'loader', 'video', 'avm1movie', 'static text', 'morphshape', '+', '-'];
		private static var types : Array;

		public static function getIconByClass(clazz : *) : BitmapData {
			if(types == null) {
				types = [Sprite, MovieClip, Bitmap, Shape, TextField, Loader, Video, AVM1Movie, StaticText, MorphShape, SimpleButton, Stage, DisplayObject];
				types.sort(ClassTool.comapreClass);
			}

			var bmd : BitmapData;
			var className : String = ClassTool.getShortClassName(DisplayObject);
			for(var i : int = 0;i < types.length;i++) {
				if(clazz is types[i]) {
					className = ClassTool.getShortClassName(types[i]);
					break;
				}
			}

			// if(icons.indexOf(className) < 0 && className != 'Object') {
			//				//  bmd = getIconByClass(Inspector.APP_DOMAIN.getDefinition(getQualifiedSuperclassName(clazz)));
			// bmd = getIconByClass(getDefinitionByName(getQualifiedSuperclassName(clazz)));
			// } else {
			bmd = getIcon(className);
			// }
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
				// throw new Error('没有这种类型的图标, 用Sprite图标代替.');
				t = 0;
			}

			if(!iconBmds[t]) {
				var bmd : BitmapData = new BitmapData(16, 16, true, 0x00000000);
				bmd.copyPixels(assetBmd, new Rectangle(t * 16, 0, 16, 16), new Point(0, 0));
				iconBmds[t] = bmd;
			}
			return iconBmds[t];
		}

		public static function getIconNameByContentType(contentType : String) : String {
			switch(contentType) {
				case "application/x-shockwave-flash":
					contentType = InspectorSymbolIcon.SWF;
					break;
				case "image/png":
				case "image/jpeg":
				case "image/bmp":
				case "image/gif":
					contentType = InspectorSymbolIcon.BITMAP;
					break;
				case null:
					contentType = InspectorSymbolIcon.FOLDER;
					break;
				default:
					contentType = InspectorSymbolIcon.UNKNOWN;
					break;
			}
			return contentType;
		}
	}
}
