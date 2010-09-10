package cn.itamt.dopin.events {
	import cn.itamt.dopin.BaseDopin;

	import flash.events.MouseEvent;	

	/**
	 * @author tamt
	 */
	public class DopinMouseEvent extends DopinEvent {

		public var localX : Number, localY : Number, stageX : Number, stateY : Number;
		public var altKey : Boolean, ctrlKey : Boolean, shiftKey : Boolean;
		public var buttonDown : Boolean;
		public var delta : int;

		public function DopinMouseEvent(dopin : BaseDopin, type : String = 'rollOver', bubbles : Boolean = true, cancelable : Boolean = false, localX : Number = 0, localY : Number = 0, ctrlKey : Boolean = false, altKey : Boolean = false, shiftKey : Boolean = false, buttonDown : Boolean = false, delta : int = 0) {
			super(dopin, type, bubbles, cancelable);
			
			this.localX = localX;
			this.localY = localY;
			this.altKey = altKey;
			this.ctrlKey = ctrlKey;
			this.shiftKey = shiftKey;
			this.delta = delta;
			this.buttonDown = buttonDown;
		}

		/**
		 * 从鼠标事件对象中复制属性.
		 */
		public function copyPropertiesFrom(evt : MouseEvent) : void {
			this.localX = evt.localX;
			this.localY = evt.localY;
			this.altKey = evt.altKey;
			this.ctrlKey = evt.ctrlKey;
			this.shiftKey = evt.shiftKey;
			this.delta = evt.delta;
			this.buttonDown = evt.buttonDown;
		}
	}
}
