package msc.util {

	/**
	 * 编码识别器，用于识别字符串或文件的编码
	 * @author itamt@qq.com
	 */
	public class EncodingIdentifier {

		public function getEncoding(str : String) : String {
			var encoding : String = 'utf-8';
			
			return encoding;
		}

		/**
		 * 是否GB2312编码
		 */
		public static function isGBCode(str : String) : Boolean {
			var ch1 : uint;
			var ch2 : uint;
			if(str.length >= 2) {
				ch1 = str.charCodeAt(0);
				ch2 = str.charCodeAt(1);
				if (ch1 >= 176 && ch1 <= 247 && ch2 >= 160 && ch2 <= 254) {
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		}

		/**
		 * 是否GBK编码
		 */
		public static function isGBKCode(str : String) : Boolean {
			var ch1 : uint;
			var ch2 : uint;
			if(str.length >= 2) {
				ch1 = str.charCodeAt(0);
				ch2 = str.charCodeAt(1);
				if (ch1 >= 129 && ch1 <= 254 && ch2 >= 64 && ch2 <= 254) {
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		}
	}
}
