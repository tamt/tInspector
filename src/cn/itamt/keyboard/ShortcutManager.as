package cn.itamt.keyboard {
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;	

	/**
	 * 快捷键管理
	 * TODO:添加ShortCut的UP事件的派发.
	 * @author 	itamt@qq.com
	 * @version	v0.1	2010.03.09
	 */
	public class ShortcutManager extends EventDispatcher {

		protected var _stage : Stage;
		//整个键盘, 所有的按键情况.
		protected var _downKeys : Array;
		//所有处于按下的键值
		protected var _typeKeys : Array;
		protected var _shortcuts : Array;

		public function ShortcutManager() : void {
			_downKeys = new Array(255);
			_shortcuts = [];
			_typeKeys = [];
		}

		/**
		 * 设置舞台
		 */
		public function setStage(stage : Stage) : void {
			if(_stage != stage) {
				if(_stage == null) {
					_stage = stage;
					_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);					_stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				}else{
					//TODO:一些清理工作.
				}
			}
		}

		private function onKeyDown(evt : KeyboardEvent) : void {
			if(!_downKeys[evt.keyCode]) {
				_downKeys[evt.keyCode] = true;
				_typeKeys.push(evt.keyCode);
			
				checkShortcutTyped();
			}
		}

		private function onKeyUp(evt : KeyboardEvent) : void {
			_downKeys[evt.keyCode] = false;
			
			var t : int = _typeKeys.indexOf(evt.keyCode);
			if(t > -1)_typeKeys.splice(t, 1);
		}

		protected function checkShortcutTyped() : void {
			var shortcut : Shortcut = this.checkShortcutExist(_typeKeys);
			if(shortcut) {
				this.dispatchEvent(new ShortcutEvent(shortcut, ShortcutEvent.DOWN));
			}
		}

		/**
		 * 提供的按键是否已经注册了快捷键. 如果则返回这个Shortcut, 如果没有返回null.
		 */
		public function checkShortcutExist(keys : Array) : Shortcut {
			var i : int = _shortcuts.length;
			var shortcut : Shortcut;
			while(i-- > 0) {
				shortcut = _shortcuts[i];
				if(shortcut.equalKeys(keys)) {
					return shortcut;
				}
			}
			return null;
		}

		/**
		 * 注册一个快捷键
		 */
		public function registerShortcut(st : Shortcut) : void {
			if(_shortcuts.indexOf(st) >= 0)return;
			_shortcuts.push(st);
		}

		/**
		 * 删除一个快捷键的注册
		 */
		public function unregisterShorcut(st : Shortcut) : void {
			var t : int = _shortcuts.indexOf(st);
			if(t > -1)_shortcuts.splice(t, 1);
		}

		/**
		 * 通过指定键指来删除快捷键的注册
		 */
		public function unregisterKeys(keys : Array) : void {
			var shortcut : Shortcut = checkShortcutExist(keys);
			if(shortcut) {
				this.unregisterShorcut(shortcut);
			}
		}
	}
}
