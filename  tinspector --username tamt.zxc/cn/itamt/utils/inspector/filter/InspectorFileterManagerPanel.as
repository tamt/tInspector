package cn.itamt.utils.inspector.filter {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;

	import flash.display.DisplayObject;

	import cn.itamt.utils.inspector.ui.InspectorViewPanel;

	import flash.display.Sprite;
	import flash.utils.Dictionary;

	/**
	 * 设置查看类型的面板
	 * @author itamt@qq.com
	 */
	public class InspectorFileterManagerPanel extends InspectorViewPanel {
		private var _listContainer : Sprite;
		private var _data : Array;
		private var _itemRenderer : Class = InspectorFilterItemRenderer;
		private var _activing : Dictionary;
		private var _all : InspectorFilterItemRenderer;

		public function InspectorFileterManagerPanel(title : String = '设定查看类型', w : Number = 200, h : Number = 200, autoDisposeWhenRemove : Boolean = true) {
			super(title, w, h, autoDisposeWhenRemove);
			
			_padding.bottom = 30;

			_listContainer = new Sprite();
			this.setContent(_listContainer);
			
			_all = new InspectorFilterItemRenderer();
			_all.data = DisplayObject;
			_all.label = InspectorLanguageManager.getStr('FilterAllDisplayObject');
			this.addChild(_all);
			
			_activing = new Dictionary();
		}

		override public function relayout() : void {
			super.relayout();
			
			_all.x = _padding.left;
			_all.y = _height - _all.height - 5;
		}

		/**
		 * 設置查看類型的數組
		 */
		public function setFilterList(arr : Array) : void {
			_data = arr;
			drawList();
		}

		public function setActivedList(arr : Array) : void {
			for each(var filter:Class in arr) {
				_activing[filter] = true;
				
				activeFilterItem(filter);
			}
		}

		/**
		 * 添加一個查看類型
		 */
		public function addFilterItem(filter : Class) : void {
			if(_data == null) {
				_data = [];	
			}
			
			if(_data.indexOf(filter) < 0) {
				_data.push(filter);
			}
			this.drawList();
		}

		public function activeFilterItem(filter : Class) : void {
			_activing[filter] = true;
			
			var item : InspectorFilterItemRenderer = findFilterItem(filter);
			if(item != null)item.enable = true;
		}

		public function inactiveFilterItem(filter : Class) : void {
			_activing[filter] = false;
			
			var item : InspectorFilterItemRenderer = findFilterItem(filter);
			if(item != null)item.enable = false;
		}

		private function findFilterItem(filter : Class) : InspectorFilterItemRenderer {
			var i : int = _listContainer.numChildren;
			var item : InspectorFilterItemRenderer;
			while(i--) {
				item = _listContainer.getChildAt(i) as InspectorFilterItemRenderer;
				if(item.data == filter) {
					return item;
					break;
				}
			}
			
			return null;
		}

		private function drawList() : void {
			_listContainer.graphics.clear();
			_listContainer.graphics.lineTo(0, 0);
			
			while(_listContainer.numChildren) {
				//				ObjectPool.disposeObject(_listContainer.removeChildAt(0), _itemRenderer);				_listContainer.removeChildAt(0);
			}
			
			var l : int = (_data == null) ? 0 : _data.length;
			for(var i : int = 0;i < l;i++) {
				var render : InspectorFilterItemRenderer = new InspectorFilterItemRenderer();				//				var render : InspectorFilterItemRenderer = ObjectPool.getObject(InspectorFilterItemRenderer);
				render.x = 0;
				render.y = _listContainer.height + 2;
				render.data = _data[i];
				render.enable = Boolean(_activing[_data[i]]);
				_listContainer.addChild(render);
			}
			
			this.relayout();
		}
	}
}
