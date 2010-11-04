package cn.itamt.dedo.manager {
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author itamt[at]qq.com
	 */
	public class TickManager {
		private var ticker : Timer;
		private var tickListeners : Vector.<Function>;
		private var _tick : uint;

		public function get tick():uint {
			return _tick;
		}

		public function TickManager():void {
			tickListeners = new Vector.<Function>();

			ticker = new Timer(250);
			ticker.addEventListener(TimerEvent.TIMER, onTimer);
		}

		public function start():void {
			ticker.start();
		}

		public function resume():void {
		}

		public function pause():void {
		}

		public function stop():void {
			ticker.stop();
		}

		public function onTick(fun : Function):void {
			if(tickListeners.indexOf(fun) < 0) {
				tickListeners.push(fun);
			}
		}

		/*************************************
		 *********private functions***********
		 ************************************/
		private function onTimer(event : TimerEvent) : void {
			_tick += 1;
			var i : uint = 0;
			var l : uint = tickListeners.length;
			for(;i < l; i++) {
				tickListeners[i].call();
			}
		}
	}
}
