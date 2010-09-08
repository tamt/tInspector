package cn.itamt.utils {
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
	}
}
