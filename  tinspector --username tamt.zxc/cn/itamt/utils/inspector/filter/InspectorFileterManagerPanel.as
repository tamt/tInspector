package cn.itamt.utils.inspector.filter {
	import flash.display.DisplayObject;
	import cn.itamt.utils.ObjectPool;
	import flash.display.Sprite;
	import cn.itamt.utils.inspector.ui.InspectorViewPanel;

	/**
	 * 设定查看类型的面板
	 * @author itamt@qq.com
	 */
	public class InspectorFileterManagerPanel extends InspectorViewPanel {
		private var _listContainer:Sprite;
		private var _data:Array;
		private var _itemRenderer:Class = InspectorFilterItemRenderer;
		
		public function InspectorFileterManagerPanel(title : String = '设定查看类型', w : Number = 200, h : Number = 200, autoDisposeWhenRemove : Boolean = true) {
			super(title, w, h, autoDisposeWhenRemove);
			
			_listContainer = new Sprite();
			this.setContent(_listContainer);
		}
		
		/**
		 * 設置查看類型的數組
		 */
		public function setFilterList(arr:Array):void{
			_data = arr;
			drawList();
		}
		
		/**
		 * 添加一個查看類型
		 */
		public function addFilterItem(filter:Class):void{
			if(_data == null){
				_data = [];	
			}
			
			_data.push(filter);
			
			this.drawList();
		}
		
		private function drawList():void{
			_listContainer.graphics.clear();
			_listContainer.graphics.lineTo(0, 0);
			
			while(_listContainer.numChildren) {
				ObjectPool.disposeObject(_listContainer.removeChildAt(0), _itemRenderer);
			}
			
			var l:int = (_data == null)?0:_data.length;
			for(var i:int = 0; i<l; i++){
				var render:DisplayObject = ObjectPool.getObject(_itemRenderer);
				render.x = 0;
				render.y = _listContainer.height + 2;
				render['data'] = _data[i];
				_listContainer.addChild(render);
			}
			
			this.relayout();
		}
	}
}
