package cn.itamt.utils.inspector.interfaces {
	import cn.itamt.utils.Inspector;
	import cn.itamt.utils.inspector.data.InspectTarget;

	import flash.display.DisplayObject;	

	/**
	 * @author itamt@qq.com
	 */
	public interface IInspectorView {

		function contains(child : DisplayObject) : Boolean;

		/**
		 * 注册到Inspector时.
		 */
		function onRegister(inspector : Inspector) : void;

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
		 * 当取消在Inspector的注册时.
		 */
		function onUnRegister(inspector : Inspector) : void;

		/**
		 * 当设置Inspect的查看模式时.
		 */
		function onInspectMode(clazz : Class) : void;

		/**
		 * 
		 */
		function onRegisterView(viewClassId : String) : void;

		/**
		 * 
		 */
		function onUnregisterView(viewClassId : String) : void;

		/**
		 * 返回这个InspectorView的id, 在tInspector中, 通过id来管理各个InspectorView.
		 */
		function getInspectorViewClassID() : String;
	}
}
