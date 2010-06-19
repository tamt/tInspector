package cn.itamt.utils.inspector.filter {
	import flash.display.SimpleButton;

	import cn.itamt.utils.ClassTool;
	import cn.itamt.utils.Inspector;
	import cn.itamt.utils.inspector.events.InspectorFilterEvent;
	import cn.itamt.utils.inspector.interfaces.IInspectorView;
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.ui.BaseInspectorView;

	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * 管理tInspector的查看過濾器
	 * @author itamt@qq.com
	 */
	public class InspectorFilterManager extends BaseInspectorView implements IInspectorView {
		public static const ID : String = 'InspectorFilterManager';

		private var _history : Array = [DisplayObject, Sprite, Shape, SimpleButton];
		//处于启用状态的过滤器
		private var _activeFilters : Array;
		//清除設置前，進行保存設置的
		private var _savedFilters : Array;
		//默认的查看类型
		private var _defaultFilter : Class = DisplayObject;

		private var _view : InspectorFileterManagerPanel;

		public function InspectorFilterManager() {			
			this.applyFilter(_defaultFilter);
		}

		/**
		 * 應用某個過濾器
		 */
		public function applyFilter(filter : Class) : void {
			if(filter == _defaultFilter) {
				if(_activeFilters != null)_savedFilters = _activeFilters.slice();
				_activeFilters = null;
				if(_view)_view.setActivedList(_activeFilters);
			} else {
				if(_activeFilters != null) {
					var t : int = _activeFilters.indexOf(_defaultFilter);
					if(t >= 0) {
						_activeFilters.splice(t, 1);
						if(_view != null)_view.inactiveFilterItem(_defaultFilter);
					}
				}
			}
			
			if(_history == null)_history = [];
			if(_history.indexOf(filter) < 0) {
				_history.push(filter);
				if(_view)_view.addFilterItem(filter);
			}

			if(_activeFilters == null)_activeFilters = [];
			if(_activeFilters.indexOf(filter) < 0) {
				_activeFilters.push(filter);
				if(_view != null)_view.activeFilterItem(filter);
				if(_inspector != null)_inspector.updateInsectorView();
			}
			
			_activeFilters.sort(comapreClass);
		}

		/**
		 * 删除一个过滤器
		 */
		public function killFilter(filter : Class) : void {
			if(filter == _defaultFilter) {
				if(_savedFilters != null)_activeFilters = _savedFilters.slice();
				if(_view)_view.setActivedList(_activeFilters);
			}
			
			if(_activeFilters == null)return;
			var t : int = _activeFilters.indexOf(filter);
			if(t >= 0) {
				_activeFilters.splice(t, 1);
				if(_view)_view.inactiveFilterItem(filter);
				if(_inspector != null)_inspector.updateInsectorView();
				
				_activeFilters.sort(comapreClass);
			}
			
			if(_activeFilters.length == 0) {
				_activeFilters = null;
			}
		}

		private function comapreClass(a : Class, b : Class) : int {
			if(a == b)return 0;
			
			//判断a是否是b的基类
			var c : Class = b;
			while(c = ClassTool.getParentClassOf(c)) {
				if(c == Object) {
					//判断b是否是a的基类
					c = a;
					while(c = ClassTool.getParentClassOf(c)) {
						if(c == Object) {
							return 0;
						}else if(b == c) {
							return -1;
						}
					}
				}else if(a == c) {
					return 1;
				}
			}
			
			return 0;
		}

		/**
		 * 检查一个对象是不是可以查看
		 */
		public function checkInFilter(target : DisplayObject) : Boolean {
			if(_activeFilters == null || _activeFilters.length == 0) {
				//				if(target is _defaultFilter)return true;
				return false;
			}
			
			var l : int = _activeFilters.length;
			for(var i : int = 0;i < l;i++) {
				if(target is _activeFilters[i])return true;
			}

			return false;
		}

		/**
		 * 一个类型目前是否是可以查看的
		 */
		public function isFilterActiving(filter : Class) : Boolean {
			if(_activeFilters == null)return false;
			return _activeFilters.indexOf(filter) >= 0;
		}

		private function toChangeFilter(evt : InspectorFilterEvent) : void {
			if(evt.type == InspectorFilterEvent.APPLY) {
				this.applyFilter(evt.filter);
			}else if(evt.type == InspectorFilterEvent.KILL) {
				this.killFilter(evt.filter);
			}else if(evt.type == InspectorFilterEvent.CHANGE) {
				if(isFilterActiving(evt.filter)) {
					this.killFilter(evt.filter);
				} else {
					this.applyFilter(evt.filter);
				}
			}
		}

		/**
		 * 玩家单击关闭按钮时
		 */
		private function onClickClose(evt : Event) : void {
			this._inspector.unregisterViewById(InspectorFilterManager.ID);
		}

		/////////////////////////
		///////////实现接口/////////
		/////////////////////////

		override public function contains(child : DisplayObject) : Boolean {
			if(_view) {
				return _view == child || _view.contains(child);
			} else {
				return false;
			}
		}

		override public function onTurnOn() : void {			
			_view = new InspectorFileterManagerPanel(InspectorLanguageManager.getStr('InspectorFilterManager'));
			_view.setFilterList(this._history);
			_view.setActivedList(this._activeFilters);
			_view.addEventListener(Event.CLOSE, onClickClose);
			
			_inspector.stage.addChild(_view);
			_inspector.stage.addEventListener(InspectorFilterEvent.APPLY, toChangeFilter, false, 0, true);			_inspector.stage.addEventListener(InspectorFilterEvent.KILL, toChangeFilter, false, 0, true);			_inspector.stage.addEventListener(InspectorFilterEvent.CHANGE, toChangeFilter, false, 0, true);			_inspector.stage.addEventListener(InspectorFilterEvent.RESTORE, toChangeFilter, false, 0, true);
		}

		override public function onTurnOff() : void {
			if(_view != null) {
				if(_view.stage)_view.parent.removeChild(_view);
				_view.removeEventListener(Event.CLOSE, onClickClose);
				_view.dispose();
				_view = null;
			}
			
			_inspector.stage.removeEventListener(InspectorFilterEvent.APPLY, toChangeFilter);
			_inspector.stage.removeEventListener(InspectorFilterEvent.KILL, toChangeFilter);
			_inspector.stage.removeEventListener(InspectorFilterEvent.CHANGE, toChangeFilter);			_inspector.stage.removeEventListener(InspectorFilterEvent.RESTORE, toChangeFilter);
		}

		override public function onUnRegister(inspector : Inspector) : void {
			if(inspector == this._inspector) {
				_inspector.stage.removeEventListener(InspectorFilterEvent.APPLY, toChangeFilter);
				_inspector.stage.removeEventListener(InspectorFilterEvent.KILL, toChangeFilter);
				_inspector.stage.removeEventListener(InspectorFilterEvent.CHANGE, toChangeFilter);
			}
			if(_view != null) {
				_view.removeEventListener(Event.CLOSE, onClickClose);
				if(_view.stage)_view.parent.removeChild(_view);
			}
		}

		/**
		 * 返回这个InspectorView的id, 在tInspector中, 通过id来管理各个InspectorView.
		 */
		override public function getInspectorViewClassID() : String {
			return InspectorFilterManager.ID;
		}
	}
}
