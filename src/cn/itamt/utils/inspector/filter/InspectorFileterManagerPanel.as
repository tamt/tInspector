package cn.itamt.utils.inspector.filter {
	import flash.events.MouseEvent;

	import msc.events.mTextEvent;

	import cn.itamt.utils.ClassTool;
	import cn.itamt.utils.ObjectPool;
	import cn.itamt.utils.inspector.controls.InspectSearchBar;
	import cn.itamt.utils.inspector.events.InspectorFilterEvent;
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.ui.InspectorViewPanel;

	import flash.display.DisplayObject;
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
		private var _search : InspectSearchBar;
		private var litem : InspectorFilterItemRenderer;

		public function InspectorFileterManagerPanel(title : String = '设定查看类型', w : Number = 260, h : Number = 200, autoDisposeWhenRemove : Boolean = true) {
			super(title, w, h, autoDisposeWhenRemove);
			
			_padding.left = _padding.right = 15;			_padding.bottom = 40;

			_listContainer = new Sprite();
			this.setContent(_listContainer);
			
			_all = new InspectorFilterItemRenderer();
			_all.data = DisplayObject;
			_all.color = 0xff6666;
			_all.label = InspectorLanguageManager.getStr('FilterAllDisplayObject');
			_all.addEventListener(InspectorFilterEvent.APPLY, onToggleAll);			_all.addEventListener(InspectorFilterEvent.KILL, onToggleAll);
			disableAllToggler();
			
			_search = new InspectSearchBar();
			_search.addEventListener(mTextEvent.ENTER, onSearch);			_search.addEventListener(mTextEvent.SELECT, onSearch);
			addChild(_search);

			_activing = new Dictionary();
		}

		override public function relayout() : void {
			super.relayout();
			
			_all.x = _width - this._padding.right - this._all.width;
			_all.y = _height - _all.height - 7;
			
			if(_search.stage) {
				_search.x = _padding.left;
				_search.y = _height - 26;
				_search.setSize(_width - this._padding.right - this._padding.left - _all.width - 10);
			}
		}

		override public function open() : void {
			super.open();
			
			_search.visible = _all.visible = true;
		}

		override public function hide() : void {
			super.hide();
			
			_search.visible = _all.visible = false;
		}

		/**
		 * 設置查看類型的數組
		 */
		public function setFilterList(arr : Array) : void {
			_data = arr;
			
			_data.sort(this.compareFilter);
			for each(var filter:Class in _data) {
				_search.addToDictionary(ClassTool.getShortClassName(filter));
			}
			
			drawContent();
		}

		public function setActivedList(arr : Array) : void {
			if(arr != null) {
				for each(var filter:Class in arr) {
					activeFilterItem(filter);
				}
			} else {
				for each(var tfilter:Class in _data) {
					inactiveFilterItem(tfilter);
				}
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
				_data.sort(compareFilter);
				_search.addToDictionary(ClassTool.getShortClassName(filter));
			}
			this.drawContent();
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

		//////////////////////////////////////
		//////////private functions///////////
		//////////////////////////////////////

		private function compareFilter(a : Class, b : Class) : int {
			var aName : String = ClassTool.getShortClassName(a);
			var bName : String = ClassTool.getShortClassName(b);
			if(aName > bName) {
				return 1;
			}else if(aName < bName) {
				return -1;
			} else {
				return 0;
			}
		}

		private function findFilterItem(filter : Class) : InspectorFilterItemRenderer {
			if(filter == DisplayObject)return _all;
			
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

		private function drawContent() : void {
			_listContainer.graphics.clear();
			_listContainer.graphics.lineTo(0, 0);
			
			while(_listContainer.numChildren) {
				ObjectPool.disposeObject(_listContainer.removeChildAt(0), _itemRenderer);//				_listContainer.removeChildAt(0);
			}
			
			var l : int = (_data == null) ? 0 : _data.length;
			for(var i : int = 0;i < l;i++) {
				//				var render : InspectorFilterItemRenderer = new InspectorFilterItemRenderer();
				var render : InspectorFilterItemRenderer;
				if(_data[i] != DisplayObject) {					render = ObjectPool.getObject(InspectorFilterItemRenderer);
					render.x = 0;
					render.y = _listContainer.height + 2;
					render.data = _data[i];
					_listContainer.addChild(render);
				} else {
					enableAllToggler();
					render = _all;
				}
				render.enable = Boolean(_activing[_data[i]]);
			}
			
			this.relayout();
		}

		/**
		 * 启用"查看所有显示对象"按钮
		 */
		private function enableAllToggler() : void {
			this.addChild(_all);
		}

		/**
		 * 禁用"查看所有显示对象"按钮
		 */
		private function disableAllToggler() : void {
			if(_all.parent)_all.parent.removeChild(_all);
		}

		private function onToggleAll(evt : InspectorFilterEvent) : void {
			if(evt.type == InspectorFilterEvent.APPLY) {
				_contentContainer.alpha = .5;
				_contentContainer.mouseChildren = _contentContainer.mouseEnabled = false;
			}else if(evt.type == InspectorFilterEvent.KILL) {
				_contentContainer.alpha = 1;
				_contentContainer.mouseChildren = _contentContainer.mouseEnabled = true;
			}
		}

		private function onSearch(evt : mTextEvent) : void {
			if(litem != null)litem.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
			var i : int = _listContainer.numChildren;
			var item : InspectorFilterItemRenderer;
			while(i--) {
				item = _listContainer.getChildAt(i) as InspectorFilterItemRenderer;
				if(ClassTool.getShortClassName(item.data) == evt.text) {
					litem = item;
					break;
				}
			}
			
			if(evt.type == mTextEvent.ENTER) {
				item.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}else if(evt.type == mTextEvent.SELECT) {
				item.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
				this.showContentArea(item.getBounds(item.parent), 0);
			}
		}
	}
}
