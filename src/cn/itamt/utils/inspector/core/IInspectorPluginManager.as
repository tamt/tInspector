package cn.itamt.utils.inspector.core {
	import flash.net.URLRequest;

	/**
	 * @author itamt[at]qq.com
	 */
	public interface IInspectorPluginManager {

		function getPluginById(pluginId : String) : IInspectorPlugin;

		/**
		 * get all the plugins registered to Inspector.
		 */
		function getPlugins() : Array;

		/**
		 * get all the plugin's id registered to Inspector.
		 */
		function getPluginIds() : Array;

		/**
		 * 开启/关闭某一个功能
		 */
		function togglePluginById(pluginId : String) : void;

		function registerPlugin(plugin : IInspectorPlugin) : void;

		function unregisterPlugin(pluginId : String) : void;

		function activePlugin(pluginId : String) : void;

		function unactivePlugin(pluginId : String) : void;

		/**
		 * load an plugin, register it to tInspector after load.
		 */
		function loadPlugin(req : URLRequest) : void;

		/**
		 * 加载组件列表文件.
		 */
		function loadPluginList(req : URLRequest) : void;
	}
}
