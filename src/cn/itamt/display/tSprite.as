package cn.itamt.display 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class tSprite extends Sprite
	{
		
		protected var _inited:Boolean;
		
		public function tSprite() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onInterAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onInterRemoved);
			
			if(this.stage){
				this.onInterAdded();
			}
		}
		
		private function onInterRemoved(e:Event = null):void 
		{
			if (!_inited) return;
			_inited = false;
			onRemoved();
		}
		
		private function onInterAdded(e:Event = null):void 
		{
			if (_inited) return;
			_inited = true;
			onAdded();
		}
		
		protected function onAdded():void {
		}
		
		protected function onRemoved():void {
		}
		
		override public function dispatchEvent(evt : Event) : Boolean {
			if(hasEventListener(evt.type) || evt.bubbles) {
				return super.dispatchEvent(evt);
			}
		    
			return false;
		}
	}

}