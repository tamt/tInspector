package cn.itamt.utils.inspector.ui {
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author itamt@qq.com
	 */
	public class InspectorScroller extends Sprite {
		private var _w : Number;
		private var _h : Number;
		private var _totalVal : Number;
		//拖动块
		private var _block : SimpleButton;
		//值
		private var  _value : Number;
		//
		private var _ratio : Number = 1 / 3;

		public function set value(val : Number) : void {
			_value = val;
			_block.y = (_value / _totalVal) * (_h - _block.height);
		}

		public function get value() : Number {
			return _value;
		}

		public function InspectorScroller(w : Number = 15, h : Number = 260, val : Number = 0, totalVal : Number = 100) {
			
			_w = w;
			_h = h;
			_value = (val < 0 ? 0 : val) > totalVal ? totalVal : val;
			_totalVal = totalVal;
			//
			_block = new SimpleButton(buildBlockShape(_w, _h / 3, 0x4D4D4D), buildBlockShape(_w, _h / 3, 0xffffff), buildBlockShape(_w, _h / 3, 0xffffff), buildBlockShape(_w, _h / 3, 0x4D4D4D));
			_block.y = (_value / _totalVal) * (_h - _block.height);
			addChild(_block);
			//
			this.relayout();
			//
			addEventListener(Event.ADDED_TO_STAGE, onAdd);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}

		private var inited : Boolean;

		private function onAdd(evt : Event) : void {
			if(inited)return;
			inited = true;
			_block.addEventListener(MouseEvent.MOUSE_DOWN, onDownBlock);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onUpBlock);			this.addEventListener(MouseEvent.MOUSE_UP, onUpBlock);
		}

		private function onRemove(evt : Event) : void {
			inited = false;
			_block.removeEventListener(MouseEvent.MOUSE_DOWN, onDownBlock);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onUpBlock);			this.removeEventListener(MouseEvent.MOUSE_UP, onUpBlock);
			this.stage.removeEventListener(Event.ENTER_FRAME, onDrag);
		}

		/**
		 * 设置滚动内容的比例
		 */
		public function setContenRatio(ratio : Number) : void {
			_ratio = ratio;
			if(_ratio > 1)_ratio = 1;
			this.relayout();
		}

		/**
		 * 改变大小
		 */
		public function resize(w : Number, h : Number) : void {
			_w = w;
			_h = h;
			
			this.relayout();
			
			_block.y = (_value / _totalVal) * (_h - _block.height);
		}

		/**
		 * 重绘布局
		 */
		public function relayout() : void {
			//绘制背景
			graphics.clear();
			graphics.beginFill(0x232323);
			graphics.drawRoundRect(0, 0, _w, _h, 5, 5);
			graphics.endFill();
			
			//绘制拖动按钮
			var th : Number = _h * _ratio;
			if(th < 6)th = 10;
			_block.upState = buildBlockShape(_w, th, 0x4D4D4D);
			_block.downState = buildBlockShape(_w, th, 0xffffff);
			_block.overState = buildBlockShape(_w, th, 0xffffff);
			_block.hitTestState = buildBlockShape(_w, th, 0x4D4D4D);
		}

		private var _pMouseY : Number;

		private function onDownBlock(evt : MouseEvent) : void {
			_pMouseY = _block.mouseY;
			this.stage.addEventListener(Event.ENTER_FRAME, onDrag);
		}

		private function onUpBlock(evt : MouseEvent) : void {
			this.stage.removeEventListener(Event.ENTER_FRAME, onDrag);
		}

		private function onDrag(evt : Event) : void {
			var ty : Number = this.mouseY - _pMouseY;
			if(ty < 0)ty = 0;
			if(ty > _h - _block.height)ty = _h - _block.height;
			_block.y = ty;
			
			var t : int = Math.round(_block.y * _totalVal / (_h - _block.height));
			if(_value != t) {
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

		override public function dispatchEvent(evt : Event) : Boolean {
			if(hasEventListener(evt.type) || evt.bubbles) {
				return super.dispatchEvent(evt);
			}
		    
			return false;
		}
	}
}