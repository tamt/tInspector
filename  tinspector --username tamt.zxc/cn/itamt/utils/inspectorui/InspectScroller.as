package cn.itamt.utils.inspectorui {
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;	

	/**
	 * @author tamt
	 */
	public class InspectScroller extends Sprite {
		private var _w : Number;
		private var _h : Number;
		private var _totalVal : Number;
		//拖动块
		private var _block : SimpleButton;
		//值
		private var  _value : Number;

		public function set value(val : Number) : void {
			_value = val;
			_block.y = (_value / _totalVal) * (_h - _block.height);
		}

		public function get value() : Number {
			return _value;
		}

		public function InspectScroller(w : Number = 15, h : Number = 260, val : Number = 0, totalVal : Number = 1) {
			
			_w = w;
			_h = h;
			_value = (val < 0 ? 0 : val) > totalVal ? totalVal : val;
			_totalVal = totalVal;
			
			//背景
			graphics.beginFill(0x333333);
			graphics.drawRoundRect(0, 0, _w, _h, 5, 5);
			graphics.endFill();
			//拖动块
			_block = new SimpleButton(buildBlockShape(_w, _h / 3, 0x4D4D4D), buildBlockShape(_w, _h / 3, 0xffffff), buildBlockShape(_w, _h / 3, 0xffffff), buildBlockShape(_w, _h / 3, 0x4D4D4D));
			_block.y = (_value / _totalVal) * (_h - _block.height);
			addChild(_block);
			
			//处于显示列表时才侦听拖动事件。
			addEventListener(Event.ADDED_TO_STAGE, onAdd);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}

		private function onAdd(evt : Event) : void {
			_block.addEventListener(MouseEvent.MOUSE_DOWN, onDownBlock);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onUpBlock);
		}

		private function onRemove(evt : Event) : void {
			_block.removeEventListener(MouseEvent.MOUSE_DOWN, onDownBlock);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onUpBlock);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDrag);
		}

		private var _pMouseY : Number;

		private function onDownBlock(evt : MouseEvent) : void {
			_pMouseY = _block.mouseY;
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onDrag);
		}

		private function onUpBlock(evt : MouseEvent) : void {
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDrag);
		}

		private function onDrag(evt : MouseEvent) : void {
			var ty : Number = this.mouseY - _pMouseY;
			if(ty < 0)ty = 0;
			if(ty > _h - _block.height)ty = _h - _block.height;
			_block.y = ty;
			
			var t:int = Math.round(_block.y * _totalVal/(_h - _block.height));
			if(_value != t){
				_value = t;
				dispatchEvent(new Event(Event.CHANGE));
			}
		}

		private function buildBlockShape(w : Number, h : Number, color : uint) : Shape {
			var sp : Shape = new Shape();
			
			sp.graphics.beginFill(color);
			sp.graphics.drawRoundRect(0, 0, w, h, 5, 5);
			sp.graphics.endFill();
			
			return sp;
		}

		/**
		 * 销毁
		 */
		public function dispose() : void {
		}
		override public function dispatchEvent(evt:Event):Boolean{
		    if(hasEventListener(evt.type) || evt.bubbles){
		        return super.dispatchEvent(evt);
		    }
		    
		    return false;
		}
	}
}
