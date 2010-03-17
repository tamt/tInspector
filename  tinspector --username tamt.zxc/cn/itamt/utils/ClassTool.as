package cn.itamt.utils {
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;	

	/**
	 * 操作类的一些方法.
	 * @author tamt
	 */
	public class ClassTool {

		private static var class_constant_cache : Dictionary;

		/**
		 * 以数组形式返回一个类的所有常量名称.
		 */
		public static function getClassConstantsName(clazz : Class, cache : Boolean = true) : Array {
			var arr : Array;
			if(cache) {
				if(class_constant_cache == null)class_constant_cache = new Dictionary();
				arr = class_constant_cache[clazz];
				if(arr == null) {
					arr = [];
					var xml : XML = describeType(clazz);
					var list : XMLList = xml.constant;
					var constant : XML;
					for each(constant in list) {
						arr.push(constant.@name);
					}
					
					class_constant_cache[clazz] = arr;
				}
			} else {
				arr = [];
				var xml : XML = describeType(clazz);
				var list : XMLList = xml.constant;
				var constant : XML;
				for each(constant in list) {
					arr.push(constant.@name);
				}
			}
			return arr;
		}

		
		public static function getShortClassName(value : *) : String {
			var str : String = getQualifiedClassName(value);
			return str.slice((str.lastIndexOf('::') >= 0) ? str.lastIndexOf('::') + 2 : 0);
		}

		public static function getClassName(value : *) : String {
			return getQualifiedClassName(value);
		}
	}
}
