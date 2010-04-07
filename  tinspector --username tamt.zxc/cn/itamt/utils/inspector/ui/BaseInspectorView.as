package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.Inspector;
	import cn.itamt.utils.inspector.data.InspectTarget;
	import cn.itamt.utils.inspector.interfaces.IInspectorView;
	import cn.itamt.utils.inspector.output.InspectorOutPuterManager;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * tInspector所有plugin的基类，该类不应该被直接实例化，请扩展后使用。
	 * @author itamt@qq.com
	 */
	public class BaseInspectorView implements IInspectorView {
		protected var viewContainer : Sprite;
		protected var _inspector : Inspector;
		//查看对对象
		protected var target : InspectTarget;
		//信息输出器管理
		protected var _outputerManager : InspectorOutPuterManager;

		public function set outputerManager(value : InspectorOutPuterManager) : void {
			this._outputerManager = value;
		}

		public function get outputerManager() : InspectorOutPuterManager {
			return _outputerManager;
		}

		public function BaseInspectorView() {
		}

		public function contains(child : DisplayObject) : Boolean {
			if(viewContainer) {
				return viewContainer == child || viewContainer.contains(child);
			} else {
				return false;
			}
		}

		public function onRegister(inspector : Inspector) : void {
			this._inspector = inspector;
			
			if(this._inspector.isOn) {
				onTurnOn();
				var tg : InspectTarget = _inspector.getCurInspectTarget();
				if(tg) {
					if(_inspector.isLiveInspecting) {
						this.onLiveInspect(tg);
					} else {
						this.onInspect(tg);
					}
				}
			}
		}

		/**
		 * 当Inspector开启时
		 */
		public function onTurnOn() : void {
		}

		/**
		 * 当Inspector关闭时
		 */
		public function onTurnOff() : void {
		}

		/**
		 * 当Inspector查看某个目标显示对象时.
		 */
		public function onInspect(target : InspectTarget) : void {
		}

		/**
		 * 当Inspector实时查看某个目标显示对象时
		 */
		public function onLiveInspect(target : InspectTarget) : void {
		}

		/**
		 * 但需要更新某个显示对象时.
		 */
		public function onUpdate(target : InspectTarget = null) : void {
		}

		/**
		 * 当取消在Inspector的注册时.
		 */
		public function onUnRegister(inspector : Inspector) : void {
		}

		/**
		 * 当设置Inspect的查看模式时.
		 */
		public function onInspectMode(clazz : Class) : void {
		}

		/**
		 * 当该InspectorView注册到Inspector时.
		 */
		public function onRegisterView(viewClassId : String) : void {
		}

		/**
		 * 当该InspectorView从Inspector删除注册时
		 */
		public function onUnregisterView(viewClassId : String) : void {
		}

		/**
		 * 当停止实时查看
		 */
		public function onStopLiveInspect() : void {
		}

		/**
		 * 当开始实时查看
		 */
		public function onStartLiveInspect() : void {
		}

		/**
		 * 返回这个InspectorView的id, 在tInspector中, 通过id来管理各个InspectorView.
		 */
		public function getInspectorViewClassID() : String {
			return 'BaseInspectorView';
		}
	}
}
