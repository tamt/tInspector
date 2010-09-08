package cn.itamt.utils {

	/**
	 * @author itamt@qq.com
	 */
	public class XMLTool {

		/**
		 * 排序XMLList
		 */
		public static function sortXMLList(list : XMLList, attribute : String, options : Object = null) : XMLList {
			var arr : Array = [];
			for each(var item:XML in list) {
				arr.push({order:item.@[attribute], data:item});
			}
			arr.sortOn('order', options);
			
			var sortedList : XMLList = new XMLList();
			for each(var obj:Object in arr) {
				sortedList += obj.data;
			}
			return sortedList;
		}
	}
}
