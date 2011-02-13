package cn.itamt.utils.inspector.firefox.evil 
{
	import cn.itamt.utils.inspector.ui.InspectorLabelButton;
	import cn.itamt.utils.inspector.ui.InspectorTextField;
	import cn.itamt.utils.inspector.ui.InspectorViewPanel;
	import cn.itamt.utils.ObjectPool;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.controls.NumericStepper;

	
	/**
	 * 弹弹堂操作面板
	 * @author tamt
	 */
	public class DanDanTengPanel extends InspectorViewPanel 
	{
		private var _status_tf:InspectorTextField;
		private var _status:String = "";
		private var _message_tf:InspectorTextField;
		private var _message:String = "云蒸霞蔚云蒸霞蔚云蒸霞蔚云蒸霞蔚云蒸霞蔚云蒸霞蔚云蒸霞蔚云蒸霞蔚云蒸霞蔚云蒸霞蔚云蒸霞蔚云蒸霞蔚";
		
		private var _data : Array;
		private var _listContainer:Sprite;
		private var _itemRenderer:Class = DanDanTengPlayerItemRenderer;
		private var _visibleBtn:InspectorLabelButton;
		private var _fireBtn:InspectorLabelButton;
		private var _selectedItem:DanDanTengPlayerItemRenderer;
		
		public var energyRatio:NumericStepper;
		public var windRatio:NumericStepper;
		public var gravity:NumericStepper;
		
		public function DanDanTengPanel() 
		{
			super("蛋蛋疼 -_-! ", 200, 200, true, false);
			
			_padding.bottom = 30;
		
			_status_tf = InspectorTextField.create(_status, 0xffffff, 12, 0, 0, "left");
			addChild(_status_tf);
			
			_message_tf = InspectorTextField.create(_message, 0xffffff, 12, 0, 0, "left");
			//addChild(_message_tf);
			
			_listContainer = new Sprite();
			this.setContent(_listContainer);
			
			_visibleBtn = new InspectorLabelButton("去隐身");
			_visibleBtn.tip = "显示隐身的玩家";
			addChild(_visibleBtn);
			_visibleBtn.addEventListener(MouseEvent.CLICK, onClickVisible);
			
			_fireBtn = new InspectorLabelButton("发射");
			_fireBtn.tip = "按照外挂计算的数值发射";
			addChild(_fireBtn);
			_fireBtn.addEventListener(MouseEvent.CLICK, onClickFire);
			
			//选择某一项时
			addEventListener(Event.SELECT, onSelectItem);
		}
		
		private function onClickFire(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
			dispatchEvent(new Event("fire_ddt"));
		}
		
		private function onSelectItem(e:Event):void 
		{
			if (_data) {
				if(_selectedItem)_selectedItem.enable = false;
				var item:DanDanTengPlayerItemRenderer = e.target as DanDanTengPlayerItemRenderer;
				//if (item && item != _selectedItem) {
				if (item) {
					_selectedItem = item;
					_selectedItem.enable = true;
				}
			}
		}
		
		private function onClickVisible(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
			dispatchEvent(new Event("anti_invisible", true, true));
		}
		
		override public function relayout():void {
			drawMessage();
			
			_padding.bottom = _message_tf.height + 10 + _status_tf.height + 5;
			
			super.relayout();
			
			this._visibleBtn.x = _resizer.x - this._visibleBtn.width - 10;
			this._visibleBtn.y = _height - 10 - this._visibleBtn.height;
			
			this.drawStatus();
			
			setChildIndex(energyRatio, this.numChildren - 1);
			setChildIndex(windRatio, this.numChildren - 1);
			setChildIndex(gravity, this.numChildren - 1);
		}
		
		private function drawStatus():void 
		{
			_status_tf.text = _status;
			_status_tf.x = _padding.left;
			_status_tf.y = _height - 10 - _status_tf.height;
			_status_tf.width = _visibleBtn.x - _padding.left;
		}
		
		private function drawMessage():void 
		{
			_message_tf.text = _message;
			_message_tf.width = _width - _padding.left - _padding.bottom;
			_message_tf.x = _padding.left;
			_message_tf.y = _height - 10 - _status_tf.height - 5 - _message_tf.height;
		}

		private function drawContent() : void {
			_listContainer.graphics.clear();
			_listContainer.graphics.lineTo(0, 0);
			
			while (_listContainer.numChildren) {
				ObjectPool.disposeObject(_listContainer.removeChildAt(0), _itemRenderer);
//				_listContainer.removeChildAt(0);
			}
			
			var l : int = (_data == null) ? 0 : _data.length;
			for(var i : int = 0;i < l;i++) {
				//				var render : InspectorFilterItemRenderer = new InspectorFilterItemRenderer();
				var render : DanDanTengPlayerItemRenderer;
				//if(_data[i] != DisplayObject) {
				render = ObjectPool.getObject(DanDanTengPlayerItemRenderer);
				render.x = 0;
				render.y = _listContainer.height + 2;
				render.data = _data[i];
				_listContainer.addChild(render);
				//}
			}
			
			this.relayout();
		}
		
		public function get status():String 
		{
			return _status;
		}
		
		public function set status(value:String):void 
		{
			_status = value;
			this.drawStatus();
		}
		
		public function get message():String 
		{
			return _message;
		}
		
		public function set message(value:String):void 
		{
			_message = value;
			this.drawMessage();
		}
		
		public function setListData(list:Array):void {
			_data = list;
			drawContent();
		}
		
	}

}