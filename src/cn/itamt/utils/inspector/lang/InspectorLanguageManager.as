package cn.itamt.utils.inspector.lang {
	import flash.system.Capabilities;

	/**
	 * <code>
	 * 		LanguageManager.setLanguage(InspectorLang_CN);
	 * 		LanguageManager.getStr('rotate');
	 * </code>
	 * @author itamt@qq.com
	 */
	public class InspectorLanguageManager {

		private static var lang : Lang;

		public static function setLanguage(n : Lang) : void {
			lang = n;
		}

		public static function getStr(str : String) : String {
			if(lang == null) {
				switch(Capabilities.language) {
					case 'zh-CN':
					case 'zh-TW':
						lang = new CN();
						break;
					default:
						lang = new EN();
						break;
				}
			}
			
			return lang.getTipValueString(str);
		}

		public static function getLanguage() : String {
			var ret : String = "en";
			switch(Capabilities.language) {
				case 'zh-CN':
				case 'zh-TW':
					ret = "cn";
					break;
				default:
					ret = "en";
					break;
			}
			
			return ret;
		}
	}
}
