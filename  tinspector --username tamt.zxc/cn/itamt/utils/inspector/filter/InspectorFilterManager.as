package cn.itamt.utils.inspector.filter {
	import cn.itamt.utils.Inspector;
	import cn.itamt.utils.inspector.data.InspectTarget;
	import cn.itamt.utils.inspector.events.InspectorFilterEvent;
	import cn.itamt.utils.inspector.interfaces.IInspectorView;

	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;	

	/**
	 * 管理tInspector的查看過濾器
	 * @author itamt@qq.com
	 */
	public class InspectorFilterManager extends EventDispatcher implements IInspectorView {
		public static const ID : String = 'InspectorFilterManager';

		private var _history : Array;
		private var _defaultFilter : Class;
		private var _curFilter : Class;
		private var _inspector : Inspector;

		public function InspectorFilterManager() {
		}

		/**
		 * 設置默認的查看過濾器
		 */
		public function setDefaultFilter(clazz : Class) : void {
			_defaultFilter = clazz;
		}

		/**
		 * 應用某個過濾器
		 */
		public function applyFilter(filter : Class) : void {
			if(_curFilter != filter) {
				if(_curFilter != null){
					//TODO:清理工作
				}
				
				_curFilter = filter;
				this._inspector.setInspectFilter(_curFilter);

				if(_history == null)_history = [];
				if(_history.indexOf(_curFilter) < 0) {
					_history.push(_curFilter);
				}
			}
		}

		/**
		 * 重設回默認的過濾器
		 */
		public function resotreFilter() : void {
			if(this._defaultFilter == null) {
				this._defaultFilter = DisplayObject;
			}
			this.applyFilter(this._defaultFilter);
		}

		/**
		 * 獲取當前的查看過濾器
		 */
		public function getCurFilter() : Class {
			return _curFilter == null ? _defaultFilter : _curFilter;
		}

		private function toChangeFilter(evt : InspectorFilterEvent) : void {
			this.applyFilter(evt.filter);
		}

		/////////////////////////
		///////////实现接口/////////
		/////////////////////////

		public function contains(child : DisplayObject) : Boolean {
			return false;
		}

		public function onRegister(inspector : Inspector) : void {
			_inspector = inspector;
		}

		public function onTurnOn() : void {	
			_inspector.stage.addEventListener(InspectorFilterEvent.CHANGE, toChangeFilter, false, 0, true);
		}

		public function onTurnOff() : void {
			_inspector.stage.removeEventListener(InspectorFilterEvent.CHANGE, toChangeFilter);
		}

		public function onInspect(target : InspectTarget) : void {
		}

		public function onLiveInspect(target : InspectTarget) : void {
		}

		public function onStopLiveInspect() : void {
		}

		public function onStartLiveInspect() : void {
		}

		public function onUpdate(target : InspectTarget = null) : void {
		}

		public function onUnRegister(inspector : Inspector) : void {
			if(inspector == this._inspector)_inspector.stage.removeEventListener(InspectorFilterEvent.CHANGE, toChangeFilter);
		}

		public function onInspectMode(clazz : Class) : void {
		}

		public function onRegisterView(viewClassId : String) : void {
		}

		public function onUnregisterView(viewClassId : String) : void {
		}

		/**
		 * 返回这个InspectorView的id, 在tInspector中, 通过id来管理各个InspectorView.
		 */
		public function getInspectorViewClassID() : String {
			return InspectorFilterManager.ID;
		}
	}
}
