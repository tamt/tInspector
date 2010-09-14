package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.inspector.data.InspectTarget;
	import cn.itamt.utils.inspector.interfaces.IInspector;
	import cn.itamt.utils.inspector.interfaces.IInspectorPlugin;
	import cn.itamt.utils.inspector.output.InspectorOutPuterManager;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * base class of all plugins of tInspector, this is an Abstract class, should be extended and custom for use.
	 * @author itamt@qq.com
	 */
	public class BaseInspectorPlugin implements IInspectorPlugin {
		protected var viewContainer : Sprite;
		protected var _inspector : IInspector;
		//current inspect target.
		protected var target : InspectTarget;
		//
		protected var _outputerManager : InspectorOutPuterManager;
		//is this plugin actived?
		protected var _actived : Boolean;

		public function get isActive() : Boolean {
			return _actived;
		}

		protected var _isOn : Boolean;

		public function set outputerManager(value : InspectorOutPuterManager) : void {
			this._outputerManager = value;
		}

		public function get outputerManager() : InspectorOutPuterManager {
			return _outputerManager;
		}

		public function BaseInspectorPlugin() {
		}

		public function contains(child : DisplayObject) : Boolean {
			if(viewContainer) {
				return viewContainer == child || viewContainer.contains(child);
			} else {
				return false;
			}
		}

		/**
		 * 註冊到Inspector時
		 */
		public function onRegister(inspector : IInspector) : void {
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
		 * 刪除在Inspector註冊時
		 */
		public function onUnRegister(inspector : IInspector) : void {
		}

		public function onRegisterPlugin(pluginId : String) : void {
		}

		public function onUnRegisterPlugin(pluginId : String) : void {
		}

		public function onActive() : void {
			if(_actived)return;
			_actived = true;
		}

		/**
		 * 当取消在Inspector的注册时.
		 */
		public function onUnActive() : void {
			_actived = false;
		}

		/**
		 * 当Inspector开启时
		 */
		public function onTurnOn() : void {
			if(_isOn)return;
			_isOn = true;
		}

		/**
		 * 当Inspector关闭时
		 */
		public function onTurnOff() : void {
			_isOn = false;
			
			if(_actived)onUnActive();
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
		 * 当设置Inspect的查看模式时.
		 */
		public function onInspectMode(clazz : Class) : void {
		}

		/**
		 * 当该InspectorView注册到Inspector时.
		 */
		public function onActivePlugin(pluginId : String) : void {
		}

		/**
		 * 当该InspectorView从Inspector删除注册时
		 */
		public function onUnActivePlugin(pluginId : String) : void {
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
		 * get this plugin's id
		 */
		public function getPluginId() : String {
			return "baseInspectorView";
		}

		/**
		 * get this plugin's version
		 */
		public function getPluginVersion() : String {
			return "1.0";
		}
	}
}
