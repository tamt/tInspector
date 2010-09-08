package cn.itamt.utils.inspector.interfaces {
	import cn.itamt.utils.inspector.data.InspectTarget;

	import flash.display.DisplayObject;

	/**
	 * @author itamt@qq.com
	 */
	public interface IInspectorView {

		/**
		 * 一個顯示對象是不是該view的子對象
		 */
		function contains(child : DisplayObject) : Boolean;

		/**
		 * 註冊到Inspector時
		 */
		function onRegister(inspector : IInspector) : void;

		/**
		 * 刪除在Inspector註冊時
		 */
		function onUnRegister(inspector : IInspector) : void;

		function onRegisterView(viewClassId : String) : void;

		function onUnRegisterView(viewClassId : String) : void;

		/**
		 * 注册到Inspector时.
		 */
		function onActive() : void;

		/**
		 * 当取消在Inspector的注册时.
		 */
		function onUnActive() : void;

		/**
		 * 当Inspector开启时
		 */
		function onTurnOn() : void;

		/**
		 * 当Inspector关闭时
		 */
		function onTurnOff() : void;

		/**
		 * 当Inspector查看某个目标显示对象时.
		 */
		function onInspect(target : InspectTarget) : void;

		/**
		 * 当Inspector实时查看某个目标显示对象时
		 */
		function onLiveInspect(target : InspectTarget) : void;

		/**
		 * 当停止实时查看
		 */
		function onStopLiveInspect() : void;

		/**
		 * 当开始实时查看
		 */
		function onStartLiveInspect() : void;

		/**
		 * 但需要更新某个显示对象时.
		 */
		function onUpdate(target : InspectTarget = null) : void;

		/**
		 * 当设置Inspect的查看模式时.
		 */
		function onInspectMode(clazz : Class) : void;

		/**
		 * 当激活时
		 */
		function onActiveView(viewClassId : String) : void;

		/**
		 * 当不激活时
		 */
		function onUnActiveView(viewClassId : String) : void;

		function get isActive() : Boolean;
	}
}
