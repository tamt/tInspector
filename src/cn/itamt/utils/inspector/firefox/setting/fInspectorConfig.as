package cn.itamt.utils.inspector.firefox.setting {
	import flash.net.SharedObject;

	/**
	 * @author itamt[at]qq.com
	 */
	public class fInspectorConfig {
		private static var _so : SharedObject;

		private static function init() : void {
			_so = SharedObject.getLocal("FlashInspectorSetting", "/");
			_so.data.buildAt = new Date().getMilliseconds();
			_so.flush();
		}

		private static function get so() : SharedObject {
			if(_so == null) {
				init();
			}
			return _so;
		}

		/*************************************
		 *********public functions************
		 ************************************/
		public static function setEnablePlugin(pluginName : String) : void {
			if(so.data.enablePlugins == null) {
				so.data.enablePlugins = [];
			}

			if(so.data.enablePlugins.indexOf(pluginName) < 0) {
				so.data.enablePlugins.push(pluginName);
			}
		}

		public static function setDisablePlugin(pluginName : String) : void {
			if(so.data.enablePlugins == null) {
				return;
			}

			var i : int = so.data.enablePlugins.indexOf(pluginName);
			if(i >= 0) {
				so.data.enablePlugins.splice(i, 1);
			}
		}

		public static function getPluginEnable(pluginName : String) : Boolean {
			return so.data.enablePlugins && (so.data.enablePlugins.indexOf(pluginName) >= 0);
		}

		public static function getEnablePlugins() : Array {
			return so.data.enablePlugins;
		}

		public static function getPlugins() : Array {
			return so.data.plugins;
		}

		public static function getEnable() : Boolean {
			if(so.data.enable == null) {
				so.data.enable = true;
				save();
			}
			return so.data.enable;
		}

		public static function setEnable(bool : Boolean) : void {
			so.data.enable = bool;	
		}

		/**
		 * @param plugins	以plugin name为元素的数组
		 */
		public static function setPlugins(plugins : Array) : void {
			so.data.plugins = plugins;
		}

		public static function save() : void {
			so.flush();
		}

		/**
		 * 重设为默认
		 */
		public static function restore() : void {
		}
	}
}
