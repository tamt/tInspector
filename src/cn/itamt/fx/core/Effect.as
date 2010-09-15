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
		 * 开始使用效果.
		 */
		public function apply() : void {
		}

		/**
		 * 清除效果.
		 */
		public function clear() : void {
		}

		/**
		 * 销毁.
		 */
		public function dispose() : void {
		}
	}
}
