package cn.itamt.utils.inspector.core {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;

	/**
	 * @author itamt@qq.com
	 */
	public interface IInspector {
		/**
		 * is Inspector on?
		 */
		function get isOn() : Boolean;

		function get root() : DisplayObjectContainer;

		function get stage() : Stage;

		/**
		 * turn on tInspector, with plugin(s) want to use
		 * @param	...paras  plugin IDs
		 */
		function turnOn(...paras) : void;
		
		/**
		 * turn off tInspector
		 */
		function turnOff() : void;

		/**
		 * get curr inspect taret.
		 */
		function getCurInspectTarget() : InspectTarget;

		/**
		 * is in live inspecting mode ?
		 */
		function get isLiveInspecting() : Boolean;

		/**
		 * toggle turn on/off
		 */
		function toggleTurn() : void;

		function startLiveInspect() : void;

		function stopLiveInspect() : void;
		
		/**
		 * inspect a DisplayObject.
		 * @param	ele
		 */
		function inspect(ele : DisplayObject) : void;
		
		/**
		 * live inspect(mouse inspect) a DisplayObject
		 * @param	ele
		 * @param	checkIsInspectorView
		 */
		function liveInspect(ele : DisplayObject, checkIsInspectorView : Boolean = true) : void;
		
		/**
		 * 
		 */
		function updateInsectorView() : void;

		function isInspectView(target : DisplayObject) : Boolean;

		function get pluginManager() : IInspectorPluginManager;
	}
}
