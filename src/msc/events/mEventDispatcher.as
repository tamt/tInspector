package msc.events {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * 加强EventDispatcher的一些功能
	 * @author tamt
	 */
	public class mEventDispatcher extends EventDispatcher {
		private var _map : Dictionary;

		public function mEventDispatcher() {
			super();
			
			_map = new Dictionary(true);
		}

		//////////////////////////////////////
		////////////override funcions/////////
		//////////////////////////////////////

		override public function dispatchEvent(evt : Event) : Boolean {
			if(hasEventListener(evt.type) || evt.bubbles) {
				return super.dispatchEvent(evt);
			}
			return false;
		}

		/**
		 * 添加一个事件的侦听。【注意】程序内部已经避免了重复侦听。
		 */
		override public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			if(_map[type]) {
				if(_map[type].indexOf(listener) < 0) {
					_map[type].push(listener);
				} else {
					return;
				}
			} else {
				_map[type] = [listener];
			}
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		override public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
			if(_map[type]) {
				var t : int = _map[type].indexOf(listener);
				if(t >= 0) {
					_map[type].splice(t, 1);
					super.removeEventListener(type, listener, useCapture);
				}
				
				if(_map[type].length == 0) {
					delete _map[type];
				}
			}
		}

		//////////////////////////////////////
		/////////public functions/////////////
		//////////////////////////////////////
		
		/**
		 * 删除某一事件的所有侦听，如果没有提供事件名称，将删除所有事件的侦听
		 * @param type			事件名称
		 * @param useCapture	0|1|2	false|true|both
		 */
		public function removeEventListeners(type : String = null, useCapture : uint = 0) : void {
			if(type) {
				if(_map[type]) {
					for each(var listener:Function in _map[type]) {
						if(useCapture == 0) {
							super.removeEventListener(type, listener, false);
						} else if(useCapture == 1) {
							super.removeEventListener(type, listener, true);
						} else {
							super.removeEventListener(type, listener, false);
							super.removeEventListener(type, listener, true);
						}
					}
					delete _map[type];
				}
			} else {
				for each(var listeners:Array in _map) {
					for each(var listener:Function in listeners) {
						if(useCapture == 0) {
							super.removeEventListener(type, listener, false);
						} else if(useCapture == 1) {
							super.removeEventListener(type, listener, true);
						} else {
							super.removeEventListener(type, listener, false);
							super.removeEventListener(type, listener, true);
						}
					}
				}
				_map = new Dictionary();
			}
		}
	}
}
