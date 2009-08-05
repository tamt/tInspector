package cn.itamt.utils.inspectorui {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	
	import cn.itamt.utils.inspector.events.InspectEvent;
	import cn.itamt.utils.inspectorui.StructureElement;		

	class StructureElementView extends Sprite {
		private var _tf : TextField;
		private var _ele : StructureElement;

		public function StructureElementView(ele : StructureElement) : void {
			super();
			
			_ele = ele;
					
			_tf = new TextField();
			_tf.selectable = false;
			_tf.autoSize = 'left';
			_tf.textColor = InspectorColorStyle.getObjectColor(ele.target);
			_tf.text = getClassName(ele.target);
			_tf.x = ele.level * 15;
			addChild(_tf);
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}
		
		private function onAdded(evt:Event):void{
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onRemove(evt:Event):void{
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			removeEventListener(MouseEvent.MOUSE_OVER, onClick);
		}
		
		private function onMouseOut(evt:MouseEvent):void{
			this._tf.border = false;
		}
		
		private function onClick(evt:MouseEvent):void{
			dispatchEvent(new InspectEvent(InspectEvent.INSPECT, _ele.target, true));
			
			evt.stopImmediatePropagation();
		}

		private function getClassName(value : *) : String {
			var str : String = getQualifiedClassName(value);
			return str.slice((str.lastIndexOf('::') >= 0) ? str.lastIndexOf('::') + 2 : 0);
		}
		
		private function onMouseOver(evt:MouseEvent):void{
			this._tf.border = true;
			this._tf.borderColor = 0xff00ff;
			
			dispatchEvent(new InspectEvent(InspectEvent.LIVE_INSPECT, _ele.target, true));
			
			evt.stopImmediatePropagation();
		}

		public function highLight() : void {
			_tf.background = true;
			_tf.backgroundColor = 0x0000ff;
		}

		public function unhighLight() : void {
			_tf.background = false;
		}
		
		public function dispose():void{
			
		}
	}
}
