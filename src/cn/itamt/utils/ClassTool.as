package cn.itamt.utils {
import cn.itamt.utils.ClassTool;

import flash.display.AVM1Movie;
import flash.display.Bitmap;
import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
import flash.display.Loader;
import flash.display.MorphShape;
import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.display.Stage;
import flash.media.Video;
import flash.text.StaticText;
import flash.text.TextField;
import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

	/**
	 * 操作类的一些方法.
	 * @author tamt
	 */
	public class ClassTool {

		private static var class_constant_cache : Dictionary;
		private static var class_name_cache : Dictionary;
		private static var class_desc_cache : Dictionary;

		/**
		 * 以数组形式返回一个类的所有常量名称.
		 */
		public static function getClassConstantsName(clazz : Class, cache : Boolean = true) : Array {
			var arr : Array;
			var xml : XML;
			var list : XMLList;
			var constant : XML;
			if(cache) {
				if(class_constant_cache == null)class_constant_cache = new Dictionary();
				arr = class_constant_cache[clazz];
				if(arr == null) {
					arr = [];
					xml = describeType(clazz);
					list = xml.constant;
					for each(constant in list) {
						arr.push(constant.@name);
					}

					class_constant_cache[clazz] = arr;
				}
			} else {
				arr = [];
				xml = describeType(clazz);
				list = xml.constant;
				for each(constant in list) {
					arr.push(constant.@name);
				}
			}
			return arr;
		}


		public static function getShortClassName(value : *, cache : Boolean = true) : String {
			var str : String = getClassName(value, cache);
			return str.slice((str.lastIndexOf('::') >= 0) ? str.lastIndexOf('::') + 2 : 0);
		}

		public static function getClassName(value : *, cache : Boolean = true) : String {
			if(cache) {
				if(class_name_cache == null)class_name_cache = new Dictionary();
				if(class_name_cache[value] == undefined) {
					class_name_cache[value] = getQualifiedClassName(value);
				}
				return class_name_cache[value];
			} else {
				return getQualifiedClassName(value);
			}
		}

		public static function getParentClassOf(clazz : Class) : Class {
			//			trace(getQualifiedSuperclassName(clazz));
			return getDefinitionByName(getQualifiedSuperclassName(clazz)) as Class;
		}

		public static function getDescribe(value : *, cache : Boolean = true) : XML {
			if(cache) {
				if(class_desc_cache == null)class_desc_cache = new Dictionary();
				if(class_desc_cache[value] == undefined) {
					class_desc_cache[value] = describeType(value);
				}
				return class_desc_cache[value];
			} else {
				return describeType(value);
			}
		}

		/**
		 * 指定一个class的名称, 找到container这个class的实例.
		 * @param	container
		 * @param	className
		 * @return
		 */
		public static function findDisplayObjectInstaceByClassName(container:DisplayObjectContainer, shortClassName:String):DisplayObject{
			var num : int = container.numChildren;
			for (var i : int = 0; i < num; i++) {
				if (ClassTool.getShortClassName(container.getChildAt(i)) == shortClassName) {
					return container.getChildAt(i);
				}else if (container.getChildAt(i) is DisplayObjectContainer) {
					var instance:DisplayObject = findDisplayObjectInstaceByClassName(container.getChildAt(i) as DisplayObjectContainer, shortClassName);
					if (instance)return instance;
				}
			}
			return null;
		}

		/**
		 * 指定一个class, 找到container这个class的实例.
		 * @param	container
		 * @param	className
		 * @return
		 */
		public static function findDisplayObjectInstaceByClass(container:DisplayObjectContainer, clazz:*):DisplayObject {
			if (clazz == null) return null;

			var num : int = container.numChildren;
			for (var i : int = 0; i < num; i++) {
				if (container.getChildAt(i) is (clazz as Class)) {
					return container.getChildAt(i);
				}else if (container.getChildAt(i) is DisplayObjectContainer) {
					var instance:DisplayObject = findDisplayObjectInstaceByClass(container.getChildAt(i) as DisplayObjectContainer, clazz);
					if (instance)return instance;
				}
			}
			return null;
		}

        public static function comapreClass(a : Class, b : Class) : int {
            if(a == b)
                return 0;

            // 判断a是否是b的基类
            var c : Class = b;
            while(c = ClassTool.getParentClassOf(c)) {
                if(c == Object) {
                    // 判断b是否是a的基类
                    c = a;
                    while(c = ClassTool.getParentClassOf(c)) {
                        if(c == Object) {
                            return 0;
                        } else if(b == c) {
                            return -1;
                        }
                    }
                } else if(a == c) {
                    return 1;
                }
            }

            return 0;
        }

        private static var types : Array;

        /**
         * 计算一个对象最接近Flash原生显示对象类的类名. 比如: 自定义一个SimpleButton的子类Test, 那么
         * getNativeDisplayObjectClassName(new Test())
         * 应该返回"SimpleButton"
         * @param instance
         * @param fullName      true:完整类名, false:短类名
         * @return      类名或短类名
         */
        public static function getNativeDisplayObjectClassName(instance : *, fullName:Boolean = false) : String {
            if(types == null) {
                types = [Sprite, MovieClip, Bitmap, Shape, TextField, Loader, Video, AVM1Movie, StaticText, MorphShape, SimpleButton, Stage, DisplayObject];
                types.sort(ClassTool.comapreClass);
            }

            var className : String =
                    fullName?ClassTool.getClassName(DisplayObject):ClassTool.getShortClassName(DisplayObject);
            for(var i : int = 0;i < types.length;i++) {
                if(instance is types[i]) {
                    className = fullName?ClassTool.getClassName(types[i]):ClassTool.getShortClassName(types[i]);
                    break;
                }
            }

            // if(icons.indexOf(className) < 0 && className != 'Object') {
            //				//  bmd = getIconByClass(Inspector.APP_DOMAIN.getDefinition(getQualifiedSuperclassName(clazz)));
            // bmd = getIconByClass(getDefinitionByName(getQualifiedSuperclassName(clazz)));
            // } else {
            // bmd = getIcon(className);
            // }
            return className;
        }

        /**
         * <p>判断一个类是另一个类的子类.</p>
         * <a>http://jacksondunstan.com/articles/1440</a>
         * <p>判断类继承关系的思路有两种:</p>
         * <ol>
         * <li>通过getDefinitionByName与getQualifiedSuperclassName来循环判断.</li>
         * <li>通过子类prototype是否instanceof父类.</li>
         * </ol>
         */
        public static function isSubclassOf(a : Class, b : Class) : Boolean
        {
            if (int(!a) | int(!b)) return false;
            return (a == b || a.prototype instanceof b);
        }

        /**
         * 返回函数的路径, 只在Debug版本中能用.
         * http://destroytoday.com/blog/as3-function-path/
         */
        public static function getFunctionPath() : String
        {
            return (new Error().getStackTrace().match(/at [^)]+\)/g)[1] as String).substr(3);
        }
	}
}
