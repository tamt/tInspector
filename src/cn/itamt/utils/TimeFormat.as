package cn.itamt.utils {

	/**时间格式的转化
	 * @author pethan
	 */
	public class TimeFormat {

		/*
		 * 西方格式的时间：00:00:00
		 */
		public static const ENGLISH_FULL_TIME : String = "English_Full_Time";
		/*
		 * 缩写的西方格式时间
		 */
		public static const ENGILSH_SHORT_TIME : String = "English_Short_Time";
		/*
		 * 中方格式(完整）时间：00小时00分钟00秒
		 */
		public static const CHINESE_FULL_TIME : String = "Chinese_Time";
		/*
		 * 中方格式时间（不完整)时间:1小时1分钟1秒（前面如果为0的话，就会去掉如:1分钟10秒)
		 */
		public static const CHINESE_SHORT_TIME : String = "Chinese_Short_Time";

		/*
		 * 简单的中方时间：00时00分00秒
		 */
		public static const CHINESE_SIMPLE_FULL_TIME : String = "Chinese_Simple_Time";
		/*
		 * 简单缩写的中方时间1时1分1秒（前面如果为0的话，就会去掉如:1分10秒)
		 */
		public static const CHINESE_SIMPLE_SHORT_TIME : String = "Chinese_Simple_Short_Time";

		/*
		 * 转换成时间(请按你须要的6种进行格式化
		 */
		public static function toTimeString(time : int,type : String) : String {
			var hour : int = time / 3600;
			//分钟
			time = time % 3600;
			var minitue : int = time / 60;
			//秒
			var second : int = time % 60;
			return TimeFormat.toTimeFormat(hour, minitue, second, type);
		}

		/**
		 * 得到时间格式的字符串
		 * @param h				小时
		 * @param m				分钟
		 * @param s				秒
		 * @param withUnitStr	是否带单位字符串, [01:02:36]还是[01小时02分钟36秒]
		 */
		public static function toTimeFormat(h : int,m : int,s : int,type : String = ENGLISH_FULL_TIME) : String {
			var ret : String = "";
			switch(type) {
				case ENGLISH_FULL_TIME:
					ret = getFull(h) + ":" + getFull(m) + ":" + getFull(s);
					break;
				case ENGILSH_SHORT_TIME:
					ret += TimeFormat.getSimple(h, ":");
					ret += TimeFormat.getSimple(m, ":");
					ret += s;
					break;
				case CHINESE_SIMPLE_FULL_TIME:
					ret = getFull(h) + "时" + getFull(m) + "分" + getFull(s) + "秒";
					break;
				case CHINESE_SIMPLE_SHORT_TIME:
					ret += TimeFormat.getSimple(h, "时");
					ret += TimeFormat.getSimple(m, "分");
					ret += s + "秒";
					break;
				case CHINESE_FULL_TIME:
					ret = getFull(h) + "小时" + getFull(m) + "分钟" + getFull(s) + "秒";
					break;
				case CHINESE_SHORT_TIME:
					ret += getSimple(h, "小时");
					ret += getSimple(m, "分钟");
					ret += s + "秒";
					break;
			}
			return ret;
		}

		//得到完整的时间
		private static function getFull(num : int) : String {
			var ret : String = "";
			if(num < 10) {
				ret = "0";
			}
			ret += num.toString();
			return ret;
		}

		//获取非0的字符
		private static function getSimple(num : int,format : String) : String {
			if(num != 0) {
				return num + format;
			}
			return "";
		}
	}
}
