﻿package cn.itamt.utils {
	import cn.itamt.utils.inspector.consts.InspectorViewID;
	import cn.itamt.utils.inspector.data.InspectTarget;
	import cn.itamt.utils.inspector.filter.InspectorFilterManager;
	import cn.itamt.utils.inspector.interfaces.IInspector;
	import cn.itamt.utils.inspector.interfaces.IInspectorView;
	import cn.itamt.utils.inspector.key.InspectorKeyManager;
	import cn.itamt.utils.inspector.tip.InspectorTipsManager;
	import cn.itamt.utils.inspector.ui.InspectorRightMenu;
	import cn.itamt.utils.inspector.ui.InspectorStageReference;
	import cn.itamt.utils.inspector.ui.LiveInspectView;
	import cn.itamt.utils.inspector.ui.PropertiesView;
	import cn.itamt.utils.inspector.ui.StructureView;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	/**
	 * @author tamt
	 * @example
	 * 	<code>
	 * 		_inspector = Inspector.getInstance();
	 * 		_inspector.init(root, true);
	 * 	</code>
	 * @version 1.0 beta
	 */
	public class Inspector extends EventDispatcher implements IInspector {
		public static const VERSION : String = '1.1';

		private static var _instance : Inspector;

		public static var APP_DOMAIN : ApplicationDomain;

		//////////////////////////////////////
		////////////setter, getter////////////
		//////////////////////////////////////
		private var _root : DisplayObjectContainer;

		public function get root() : DisplayObjectContainer {
			return _root;
		}

		private var _stage : Stage;

		public function get stage() : Stage {
			return _stage;
		}

		private var _filterManager : InspectorFilterManager;

		public function get filterManager() : InspectorFilterManager {
			return _filterManager;
		}

		private var _keysManager : InspectorKeyManager;
		private var _inspectView : LiveInspectView;

		/**
		 * “鼠标查看”视图
		 */
		public function get liveInspectView() : LiveInspectView {
			return _inspectView;
		}

		private var _structureView : StructureView;

		public function get structureView() : StructureView {
			return _structureView;
		}

		private var _propertiesView : PropertiesView;
		private var _ctmenu : InspectorRightMenu;

		private var _curInspectEle : InspectTarget;

		public function getCurInspectTarget() : InspectTarget {
			return _curInspectEle;
		}

		public function Inspector(sf : SingletonEnforcer) {
			super();
			
			if(sf == null) {
				throw new Error('use Inspector.getInstance() to play.');
				return;
			}
			
			_ctmenu = new InspectorRightMenu();
			_inspectView = new LiveInspectView();
			_structureView = new StructureView();
			_propertiesView = new PropertiesView();
			_keysManager = new InspectorKeyManager();
			_filterManager = new InspectorFilterManager();
		}

		public static function getInstance() : Inspector {
			if(_instance == null) {
				_instance = new Inspector(new SingletonEnforcer());
			}

			return _instance;
		}

		////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////
		/////////////////////public functions///////////////////
		////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////

		/**
		 * 初始化tInspector，并注册要使用功能（只有注册过的功能才能开启，turnOn）。
		 * @param root				所在根对象
		 * @param menu				注册右键菜单
		 * @param live				注册实时查看功能
		 * @param structure			注册显示结构功能
		 * @param property			注册显示对象信息功能
		 * @param keys				注册快捷键
		 */
		public function init(root : DisplayObjectContainer, menu : Boolean = true, live : Boolean = true, property : Boolean = true, structure : Boolean = true, keys : Boolean = false) : void {
			
			this._root = root;
			this._stage = root.stage;

			if(this._stage == null) {
				throw new Error("Set inspector's stage before you call inspector.init(); ");
				return;
			}
			
			InspectorStageReference.referenceTo(this._stage);
			
			//注册各個功能模塊
			if(menu) {
				registerView(_ctmenu, InspectorViewID.RIGHT_MENU);
				activeView(InspectorViewID.RIGHT_MENU);
			}
			if(live)registerView(_inspectView, InspectorViewID.LIVE_VIEW);
			if(structure)registerView(_structureView, InspectorViewID.STRUCT_VIEW);
			if(property)registerView(_propertiesView, InspectorViewID.PROPER_VIEW);
			if(keys)registerView(_keysManager, InspectorViewID.SHORT_CUT);
			registerView(_filterManager, InspectorViewID.FILTER_VIEW);
		}

		private var _views : Dictionary;

		/**
		 * 往tInspector註冊一個功能模塊
		 */
		public function registerView(view : IInspectorView, id : String) : void {
			if(_views == null)_views = new Dictionary();
			if(view != _views[id]) {
				view.onRegister(this);
				
				for(var t:String in _views) {
					view.onRegisterView(t);
				}
				
				_views[id] = view;
			}
			
			for each(var item:IInspectorView in _views) {
				item.onRegisterView(id);
			}
		}

		/**
		 * 删除註冊一個功能模塊
		 */
		public function unregisterView(id : String) : void {
			if(_views == null)_views = new Dictionary();
			var view : IInspectorView = _views[id];
			if(view != null) {		
				view.onUnRegister(this);
			
				for each(var item:IInspectorView in _views) {
					item.onUnRegisterView(id);
				}
			
				delete	_views[id];
			}
		}

		/**
		 * 开启Inspector的视图.
		 */
		public function activeView(id : String) : void {
			if(_views == null)return;
			
			var view : IInspectorView = _views[id];
			if(view) {
				if(!view.isActive)view.onActive();
				if(_curInspectEle != null) {
					if(!this.isLiveInspecting) {
						view.onInspect(_curInspectEle);
					} else {
						view.onLiveInspect(_curInspectEle);
					}
				}
				for each(var item:IInspectorView in _views) {
					item.onActiveView(id);
				}
			} else {
				trace(id + '没有注册，不能开启。使用Inspector.registerView来注册功能，然后再调用Inspector.activeView。');
			}
		}

		/**
		 * 关闭Inspector的视图.
		 */
		public function unactiveView(id : String) : void {
			if(_views[id] != null) {
				(_views[id] as IInspectorView).onUnActive();
			}
			
			for each(var view:IInspectorView in _views) {
				if(view.isActive)view.onUnActiveView(id);
			}
		}

		public function toggleViewByID(id : String) : void {
			var view : IInspectorView = _views[id];
			if(view.isActive) {
				view.onUnActive();
			} else {
				view.onActive();
			}
		}

		public function getViewByID(viewId : String) : IInspectorView {
			if(_views == null)return null;
			return _views[viewId];
		}

		/**
		 * 开启tInspector，开始指定的功能模块
		 */
		public function turnOn(...paras) : void {
			if(_isOn)return;
			_isOn = true;
			_curInspectEle = null;
			
			//鼠標tip
			InspectorTipsManager.init();
			
			//调用各个模块的onTurnOn
			for each(var view:IInspectorView in _views) {
				view.onTurnOn();
			}
			
			for(var i : int = 0;i < paras.length;i++) {
				this.activeView(String(paras[i]));
			}
		}

		/**
		 * 关闭tInspector
		 */
		public function turnOff() : void {
			this.stopLiveInspect();
			
			InspectorTipsManager.dispose();
			
			if(!_isOn)return;
			_isOn = false;
			_curInspectEle = null;
			
			for each(var view:IInspectorView in _views) {
				if(view.isActive)view.onUnActive();
				view.onTurnOff();
			}
		}

		public function toggleTurn() : void {
			if(_isOn) {
				this.turnOff();
			} else {
				this.turnOn();
			}
		}

		/**
		 * 开启查看
		 */
		private var _isOn : Boolean = false;

		public function get isOn() : Boolean {
			return _isOn;
		}

		private var _isLiveInspecting : Boolean = false;

		//是否处于LiveInspect状态.
		public function get isLiveInspecting() : Boolean {
			return _isLiveInspecting;
		}

		
		public function startLiveInspect() : void {
			if(!_isLiveInspecting) {
				_curInspectEle = null;
			
				_isLiveInspecting = true;
				this.stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
				
				for each(var view:IInspectorView in _views) {
					if(view.isActive)view.onStartLiveInspect();
				}
			}
		}

		public function stopLiveInspect() : void {
			_isLiveInspecting = false;
			this.stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			for each(var view:IInspectorView in _views) {
				if(view.isActive)view.onStopLiveInspect();
			}
		}

		private function enterFrameHandler(evt : Event = null) : void {
			var mousePos : Point = new Point(stage.mouseX, stage.mouseY);
			var objs : Array = stage.getObjectsUnderPoint(mousePos);
			var l : int = objs.length;
			
			if(l) {
				while(l--) {
					var target : DisplayObject = objs[l];
					if(isInspectView(target)) {
						if(liveInspectView.contains(target)) {
							continue;
						} else {
							return;
						}
					} 
					while(target) {
							liveInspect(target, false);
							return;
						} else {
							if(target.parent && target.parent != this.stage) {
								target = target.parent;
							} else {
								break;
							}
						}
					}
				}
			}
		}

		/**
		 * 要查看的对像是否是InspectView
		 */
		public function isInspectView(target : DisplayObject) : Boolean {
			for each(var view:IInspectorView in _views) {
				if(view.contains(target)) {
					return true;
				}
			}
			return false;
		}

		/**
		 * 实时查看某个显示对象
		 * @param ele					要查看的显示对象
		 * @param checkIsInspectorView	把InspectorView的显示对象排除掉
		 */
		public function liveInspect(ele : DisplayObject, checkIsInspectorView : Boolean = true) : void {
			if(_curInspectEle && _curInspectEle.displayObject == ele)return;
			if(checkIsInspectorView)if(isInspectView(ele))return;
			
			_curInspectEle = getInspectTarget(ele);
			
			for each(var view:IInspectorView in _views) {
				if(view.isActive)
				view.onLiveInspect(_curInspectEle);
			}
		}

		/**
		 * 查看某一个显示对象.
		 */
		public function inspect(ele : DisplayObject) : void {
			if(isInspectView(ele))return;
			
			stopLiveInspect();
			
			_curInspectEle = getInspectTarget(ele);
			
			for each(var view:IInspectorView in _views) {
				if(view.isActive)view.onInspect(_curInspectEle);
			}
		}

		/**
		 * 更新当前的查看对象
		 */
		public function updateInsectorView() : void {
			if(_curInspectEle != null) {
				for each(var view:IInspectorView in _views) {
					if(view.isActive)view.onUpdate(_curInspectEle);
				}
			}
		}

		private var _tMap : Dictionary;

		/**
		 * InspectTarget存储
		 */
		private function getInspectTarget(target : DisplayObject) : InspectTarget {
			if(_tMap == null) {
				_tMap = new Dictionary();
			}
			
			if(_tMap[target] == null) {
				_tMap[target] = new InspectTarget(target);
			}
			
			return _tMap[target];
		}
	}
}

class SingletonEnforcer {
}