package cn.itamt.fx.core {
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.EventDispatcher;		

	/**
	 * @author itamt@qq.com
	 */
	public class Effect extends EventDispatcher {
		protected var _target : DisplayObject;
		protected var stage:Stage;

		public function Effect(tg : DisplayObject) : void {
			this._target = tg;
			stage = tg.stage;
		}

		/**
		 * start use the effect
		 */
		public function apply() : void {
		}

		/**
		 * clear use the effect
		 */
		public function clear() : void {
		}

		/**
		 * dispose the effect, clear reference, memory.
		 */
		public function dispose() : void {
		}
	}
}
