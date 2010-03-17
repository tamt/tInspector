package cn.itamt.utils.inspector.key {
	import cn.itamt.keyboard.Shortcut;
	import cn.itamt.keyboard.ShortcutEvent;
	import cn.itamt.keyboard.ShortcutManager;
	import cn.itamt.utils.Inspector;
	import cn.itamt.utils.inspector.data.InspectTarget;
	import cn.itamt.utils.inspector.interfaces.IInspectorView;

	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;	

	/**
	 * 管理inspector的快捷鍵
	 * @author itamt@qq.com
	 */
	public class InspectorKeyManager extends ShortcutManager implements IInspectorView {
		public static const ID : String = 'inspector_key_manager';

		private var _inspector : Inspector;
		private var _keyViewMap : Dictionary;		private var _keyFunMap : Dictionary;

		public function InspectorKeyManager() : void {
			super();
			
			this.addEventListener(ShortcutEvent.DOWN, onShortcutDown);
		}

		/**
		 * 绑定一组视图与快捷键。
		 */
		public function bindKey2View(keys : Array, viewID : String = null) : void {
			if(_keyViewMap == null)_keyViewMap = new Dictionary(true);
			
			var shortcut : Shortcut = checkShortcutExist(keys);
			if(shortcut == null) {
				shortcut = new Shortcut(keys);
				this.registerShortcut(shortcut);
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
				shortcut = this.checkShortcutExist(keys);
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
			
			var shortcut : Shortcut = checkShortcutExist(keys);
			if(shortcut == null) {
				shortcut = new Shortcut(keys);
				this.registerShortcut(shortcut);
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
				shortcut = this.checkShortcutExist(keys);
				if(shortcut) {
					_keyFunMap[shortcut] = null;
					delete _keyFunMap[shortcut];
				}
			} else {
				if(fun) {
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
			if(fun) {
				fun.call();
			}
		}

		///////////////////////
		///////////实现接口///////
		///////////////////////

		public function contains(child : DisplayObject) : Boolean {
			return false;
		}

		public function onRegister(inspector : Inspector) : void {
			_inspector = inspector;
			
			this.setStage(_inspector.stage);
		}

		public function onTurnOn() : void {
			_downKeys = new Array(255);
			
			_inspector.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}

		public function onTurnOff() : void {
			_inspector.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}

		private function onKeyDown(evt : KeyboardEvent) : void {
			_downKeys[evt.keyCode] = true;
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
			if(inspector == this._inspector) {
				_inspector.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			}
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
			return InspectorKeyManager.ID;
		}
	}
}

class ShortCut {
	public function ShortCut() : void {
	}
}
