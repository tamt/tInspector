package cn.itamt.utils.inspector.key {
	import cn.itamt.keyboard.Shortcut;
	import cn.itamt.keyboard.ShortcutEvent;
	import cn.itamt.keyboard.ShortcutManager;
	import cn.itamt.utils.inspector.consts.InspectorViewID;
	import cn.itamt.utils.inspector.interfaces.IInspector;
	import cn.itamt.utils.inspector.ui.BaseInspectorView;

	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	/**
	 * 管理inspector的快捷鍵
	 * @author itamt@qq.com
	 */
	public class InspectorKeyManager extends BaseInspectorView {
		private var _keyViewMap : Dictionary;
		private var _keyFunMap : Dictionary;
		private var _stMgr : ShortcutManager;

		public function InspectorKeyManager() : void {
			super();
			
			_stMgr = new ShortcutManager();
			_stMgr.addEventListener(ShortcutEvent.DOWN, onShortcutDown);
		}

		/**
		 * 绑定一组视图与快捷键。
		 */
		public function bindKey2View(keys : Array, viewID : String = null) : void {
			if(_keyViewMap == null)_keyViewMap = new Dictionary(true);
			
			var shortcut : Shortcut = _stMgr.checkShortcutExist(keys);
			if(shortcut == null) {
				shortcut = new Shortcut(keys);
				_stMgr.registerShortcut(shortcut);
			}
			_keyViewMap[shortcut] = viewID;
		}

		/**
		 * 解除一组视图与快捷键的绑定
		 */
		public function unbindKey2View(keys : Array = null, viewID : String = null) : void {
			if(keys == null && viewID == null)throw new ArgumentError('keys, view两个参数不能同时为空.');
			
			var shortcut : Shortcut;
			if(keys) {
				shortcut = _stMgr.checkShortcutExist(keys);
				if(shortcut) {
					_keyViewMap[shortcut] = null;
					delete _keyViewMap[shortcut];
				}
			} else {
				if(viewID) {
					for(var i:* in _keyViewMap) {
						if(_keyViewMap[i] == viewID) {
							_keyViewMap[i] = null;
							delete _keyViewMap[shortcut];
							break;
						}
					}
				}
			}
		}

		/**
		 * 绑定键盘与函数
		 */
		public function bindKey2Fun(keys : Array, fun : Function) : void {
			if(_keyFunMap == null)_keyFunMap = new Dictionary(true);
			
			var shortcut : Shortcut = _stMgr.checkShortcutExist(keys);
			if(shortcut == null) {
				shortcut = new Shortcut(keys);
				_stMgr.registerShortcut(shortcut);
			}
			_keyFunMap[shortcut] = fun;
		}

		/**
		 * 解除绑定键盘与函数
		 */
		public function unbindKey2Fun(keys : Array = null, fun : Function = null) : void {
			if(keys == null && fun == null)throw new ArgumentError('keys, fun两个参数不能同时为空.');
			
			var shortcut : Shortcut;
			if(keys) {
				shortcut = _stMgr.checkShortcutExist(keys);
				if(shortcut) {
					_keyFunMap[shortcut] = null;
					delete _keyFunMap[shortcut];
				}
			} else {
				if(fun != null) {
					for(var i:* in _keyFunMap) {
						if(_keyFunMap[i] == fun) {
							_keyFunMap[i] = null;
							delete _keyFunMap[shortcut];
							break;
						}
					}
				}
			}
		}

		private function onShortcutDown(evt : ShortcutEvent) : void {
			var viewID : String = _keyViewMap[evt.shortcut];
			if(viewID) {
				this._inspector.toggleViewByID(viewID);
			}
			
			var fun : Function = _keyFunMap[evt.shortcut];
			if(fun != null) {
				fun.call();
			}
		}

		///////////////////////
		///////////实现接口///////
		///////////////////////

		override public function contains(child : DisplayObject) : Boolean {
			return false;
		}

		override public function onRegister(inspector : IInspector) : void {
			super.onRegister(inspector);
			
			_stMgr.setStage(_inspector.stage);
			
			//			this.bindKey2Fun([KeyCode.CONTROL, KeyCode.I], this.toggleTurn);			
			this.bindKey2Fun([17, 73], _inspector.toggleTurn);
		}

		override public function onActive() : void {
			super.onActive();

			//			this.bindKey2View([KeyCode.CONTROL, KeyCode.S], StructureView.ID);
			//			this.bindKey2View([KeyCode.CONTROL, KeyCode.T], LiveInspectView.ID);
			//			this.bindKey2View([KeyCode.CONTROL, KeyCode.P], PropertiesView.ID);
			//			this.bindKey2Fun([KeyCode.CONTROL, KeyCode.F], InspectorFilterManager.ID);
			this.bindKey2View([17, 83], InspectorViewID.STRUCT_VIEW);
			this.bindKey2View([17, 84], InspectorViewID.LIVE_VIEW);
			this.bindKey2View([17, 80], InspectorViewID.PROPER_VIEW);
			this.bindKey2View([17, 77], InspectorViewID.FILTER_VIEW);
		}

		override public function onUnActive() : void {
			super.onUnActive();
			
			this.unbindKey2View([17, 83], InspectorViewID.STRUCT_VIEW);
			this.unbindKey2View([17, 84], InspectorViewID.LIVE_VIEW);
			this.unbindKey2View([17, 80], InspectorViewID.PROPER_VIEW);
			this.unbindKey2View([17, 77], InspectorViewID.FILTER_VIEW);
		}

		override public function onTurnOn() : void {
			super.onTurnOn();
			
			this.bindKey2View([17, 83], InspectorViewID.STRUCT_VIEW);
			this.bindKey2View([17, 84], InspectorViewID.LIVE_VIEW);
			this.bindKey2View([17, 80], InspectorViewID.PROPER_VIEW);
			this.bindKey2View([17, 77], InspectorViewID.FILTER_VIEW);
		}

		override public function onTurnOff() : void {
			super.onTurnOff();
			
			this.unbindKey2View([17, 83], InspectorViewID.STRUCT_VIEW);
			this.unbindKey2View([17, 84], InspectorViewID.LIVE_VIEW);
			this.unbindKey2View([17, 80], InspectorViewID.PROPER_VIEW);
			this.unbindKey2View([17, 77], InspectorViewID.FILTER_VIEW);
		}
	}
}
