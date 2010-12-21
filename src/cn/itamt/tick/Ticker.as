package cn.itamt.tick
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	import cn.itamt.tick.TickEvent;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class Ticker extends Sprite
	{
		
		private var _running:Boolean;
		
		private var _lastTime:int;
		
		public function Ticker() 
		{
		}
		
		public function start():void {
			if (_running) return;
			_running = true;
			_lastTime = getTimer();
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function pause():void {
			_running = false;
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function reset():void {
			pause();
			_lastTime = 0;
		}
		
		private function onEnterFrame(e:Event):void 
		{
			var curTime:int = getTimer();
			var evt:TickEvent = new TickEvent(TickEvent.TICK);
			evt.interval = curTime - _lastTime;
			dispatchEvent(evt);
			_lastTime = curTime;
		}
		
	}

}