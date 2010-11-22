package cn.itamt.utils.inspector.core {
	import flash.display.DisplayObject;

	/**
	 * @author itamt@qq.com
	 */
	public interface IInspectorPlugin {

		/**
		 * get this plugin's id, every InspectorPlugin has an id.
		 */
		function getPluginId() : String;

		/**
		 * the icon will be display on tInspectorControlBar. if your plugin doesn't have an icon, just return null.
		 */
		function getPluginIcon() : DisplayObject;

		/**
		 * get this plugin's version
		 */
		function getPluginVersion() : String;

		/**
		 * get plugin's name in spectified language. cn or en.
		 * @param lang		cn, en.
		 */
		function getPluginName(lang : String) : String;

		/**
		 * use for check whether an DisplayObject is contained by the plugin, most used to check invalid inspect target, when use mouse inspect(live inspect).
		 * @param	child
		 * @return
		 */
		function contains(child : DisplayObject) : Boolean;

		/**
		 * called when this plugin is register to an Inspector
		 */
		function onRegister(inspector : IInspector) : void;

		/**
		 * called when this plugin is unregister from an Inspector.
		 */
		function onUnRegister(inspector : IInspector) : void;
		
		/**
		 * called when an plugin is register to owner Inspector.
		 * @param	pluginId
		 */
		function onRegisterPlugin(pluginId : String) : void;

		/**
		 * called when an plugin is unregister from owner Inspector.
		 * @param	pluginId
		 */
		function onUnRegisterPlugin(pluginId : String) : void;

		/**
		 * called when active (start use) this plugin.
		 */
		function onActive() : void;

		/**
		 * called when unactive (stop use) this plugin.
		 */
		function onUnActive() : void;

		/**
		 * called when owner Inspector turn on.
		 */
		function onTurnOn() : void;

		/**
		 * called when owner Inspector turn off.
		 */
		function onTurnOff() : void;

		/**
		 * called when owner Inspector inspect an target.
		 */
		function onInspect(target : InspectTarget) : void;

		/**
		 * called when owner Inspector live inspect(mouse inspect) an target.
		 */
		function onLiveInspect(target : InspectTarget) : void;

		/**
		 * called when owner Inspector stop live inspect(mouse inpsect)
		 */
		function onStopLiveInspect() : void;

		/**
		 * called when owner Inspector start live inspect(mouse inspect)
		 */
		function onStartLiveInspect() : void;

		/**
		 * called when taret update.
		 */
		function onUpdate(target : InspectTarget = null) : void;

		/**
		 * called when Inspect filter changed.
		 */
		function onInspectMode(clazz : Class) : void;

		/**
		 * called when active(start use) an plugin.
		 */
		function onActivePlugin(pluginId : String) : void;

		/**
		 * called when unactive(stop use) an plugin.
		 */
		function onUnActivePlugin(pluginId : String) : void;
		
		/**
		 * is this plugin actve(being used)?
		 */
		function get isActive() : Boolean;
	}
}
