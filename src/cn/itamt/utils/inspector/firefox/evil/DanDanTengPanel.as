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
	
	/**
	 * 弹弹堂操作面板
	 * @author tamt
	 */
	public class DanDanTengPanel extends InspectorViewPanel 
	{
		private var _status_tf:InspectorTextField;
		private var _status:String = "";
		
		private var _data : Array;
		private var _listContainer:Sprite;
		private var _itemRenderer:Class = DanDanTengPlayerItemRenderer;
		private var _visibleBtn:InspectorLabelButton;
		
		public function DanDanTengPanel() 
		{
			super("蛋蛋疼 -_-! ");
		
			_status_tf = InspectorTextField.create(_status, 0xffffff, 14, 0, 0, "left");
			addChild(_status_tf);
			
			_listContainer = new Sprite();
			this.setContent(_listContainer);
			
			_visibleBtn = new InspectorLabelButton("去隐身");
			_visibleBtn.tip = "显示隐身的玩家";
			addChild(_visibleBtn);
			_visibleBtn.addEventListener(MouseEvent.CLICK, onClickVisible);
		}
		
		private function onClickVisible(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
			dispatchEvent(new Event("anti_invisible", true, true));
		}
		
		override public function relayout():void {
			super.relayout();
			
			this._visibleBtn.x = _resizer.x - this._visibleBtn.width - 10;
			this._visibleBtn.y = _height - _padding.bottom - this._visibleBtn.height;
			
			this.drawStatus();
		}
		
		private function drawStatus():void 
		{
			_status_tf.text = _status;
			_status_tf.x = _padding.left;
			_status_tf.y = _height - _padding.bottom - _status_tf.height;
			_status_tf.width = _visibleBtn.x - _padding.left;
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
		
		public function setListData(list:Array):void {
			_data = list;
			drawContent();
		}
		
	}

}