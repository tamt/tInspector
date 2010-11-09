package msc.console {

	/**
	 * @author itamt[at]qq.com
	 */
	public class mConsoleConnName {
		//注意名称需要以下划线“_”开头，详细原因请见帮助文档中“连接到其它 Flash Player 和 AIR 实例”一章。
		public static const CONSOLE : String = '_mConsole_LocalConnection';		public static var CLIENT : String = '_mConsole_Client_LocalConnection';

		public static function getConsoleConnName(id : String) : String {
			return CONSOLE + '_' + id;
		}
	}
}
