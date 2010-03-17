package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.ObjectPool;
	import cn.itamt.utils.inspector.data.DisplayItemData;
	import cn.itamt.utils.inspector.events.DisplayItemEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;	

	/**
	 * 显示对象树
	 * @author itamt@qq.com
	 */
	public class DisplayObjectTree extends Sprite {

		private var _root : DisplayObject;
		private var _data : Array;
		private var _map : Dictionary;

		private var _list : Sprite;

		private var _itemRenderer : Class;

		public var filterFun : Function;

		/**
		 * @param object				显示对象
		 * @param itemRenderClass		显示对象树节点的渲染类
		 */
		public function DisplayObjectTree(object : DisplayObject, itemRenderClass : Class = null) {
			_data = [];
			_map = new Dictionary();
			
			if(itemRenderClass == null) {
				_itemRenderer = DisplayItemRenderer;
			} else {
				_itemRenderer = itemRenderClass;
			}

			this._root = object;
			
			this._list = new Sprite();
			addChild(this._list);
			
			//绘制
			//			this.buildTree(this._root);
			this.initTree();
			this.drawList();
		}

		/**
		 * 创建显示结构树的数据.
		 */
		private function initTree() : void {
			var itemData : DisplayItemData = getDisplayItem(_root);
			itemData.isExpand = true;
			addDisplayItem(itemData);

			if(_root is DisplayObjectContainer) {
				var container : DisplayObjectContainer = _root as DisplayObjectContainer;
				for(var i : int = 0;i < container.numChildren; i++) {
					addDisplayItem(getDisplayItem(container.getChildAt(i)));
				}
			}
		}

		/**
		 * 创建显示结构树的数据.
		 */
		private function buildTree(object : DisplayObject) : void {
			addDisplayItem(getDisplayItem(object));

			if(object is DisplayObjectContainer) {
				var container : DisplayObjectContainer = object as DisplayObjectContainer;
				for(var i : int = 0;i < container.numChildren; i++) {
					buildTree(container.getChildAt(i));
				}
			}
		}

		/**
		 * 查看某个元素
		 */
		public function onInspect(object : DisplayObject) : void {
			this.inspectDisplayItem(this.getDisplayItem(object));
			this.drawList();
		}

		private function inspectDisplayItem(item : DisplayItemData) : void {
			var parent : DisplayItemData;
			var parentObject : DisplayObjectContainer = item.displayObject.parent;
			if(parentObject == null || item.displayObject == this._root) {
				this.expandDisplayItem(item);
			} else {
				parent = getDisplayItem(parentObject);
				parent.isExpand = true;
				if(hasDisplayItem(parent)) {
					this.expandDisplayItem(parent);
				} else {
					inspectDisplayItem(parent);
				}
			}
//			buildTree(this._root);
//			this.drawList();
		}

		/**
		 * 添加一个项
		 */
		private function addDisplayItem(item : DisplayItemData) : void {
			//过滤显示
			if(item.displayObject == this && this.contains(item.displayObject))return;

			if(_data.indexOf(item) < 0) {
				_data.push(item);
			}
		}

		/**
		 * 某项是否处于显示中.
		 */
		private function hasDisplayItem(item : DisplayItemData) : Boolean {
			return _data.indexOf(item) >= 0;
		}

		/**
		 * 添加项
		 */
		private function addDisplayItemAfter(item : DisplayItemData, afterItem : DisplayItemData) : void {
			var t : int = _data.indexOf(afterItem);
			if(t >= 0)addDisplayItemAt(t + 1, item);
		}

		/**
		 * 添加项
		 */
		private function addDisplayItemAt(index : int, item : DisplayItemData) : void {
			//过滤显示
			if(item.displayObject == this && this.contains(item.displayObject))return;

			if(_data.indexOf(item) < 0) {
				_data.splice(index, 0, item);
			}
		}

		/**
		 * 删除一个项
		 */
		private function removeDisplayItem(item : DisplayItemData) : void {
			var i : int = _data.indexOf(item);
			if(i >= 0)_data.splice(i, 1);
		}

		/**
		 * 更新显示(绘制)
		 * TODO:优化绘制.
		 */
		public function drawList() : void {
			_list.graphics.clear();
			_list.graphics.lineTo(0, 0);
			while(_list.numChildren) {
				ObjectPool.disposeObject(_list.removeChildAt(0), _itemRenderer);
			}
			
			var item : DisplayItemData;
			for(var i : int = 0;i < _data.length; i++) {
				item = _data[i];
				if(item.displayObject.stage == null)continue;
				if(filterFun) {
					if(filterFun.apply(null, [item.displayObject])){
						continue;
					}
				}
				//				var render : BaseDisplayItemView = new _itemRenderer();				var render : BaseDisplayItemView = ObjectPool.getObject(_itemRenderer);
				render.setData(item);
				render.x = 0;
				render.y = _list.height + 2;
				_list.addChild(render);
			}
			
			dispatchEvent(new Event(Event.RESIZE));
		}

		/**
		 * 根据显示对象返回其对应在显示树中的数据类.
		 */
		public function getDisplayItem(object : DisplayObject) : DisplayItemData {
			if(_map[object] == null) {
				_map[object] = new DisplayItemData(object);
				(_map[object] as DisplayItemData).addEventListener(DisplayItemEvent.EXPAND, onExpandCollapseItem);				(_map[object] as DisplayItemData).addEventListener(DisplayItemEvent.COLLAPSE, onExpandCollapseItem);
			}
			
			return _map[object];
		}

		/**
		 * 展开或折叠子节点事件.
		 */
		private function onExpandCollapseItem(evt : DisplayItemEvent) : void {
			var item : DisplayItemData = evt.target as DisplayItemData;
			switch(evt.type) {
				case DisplayItemEvent.EXPAND:
					expandDisplayItem(item);
					break;
				case DisplayItemEvent.COLLAPSE:
					collapseDisplayItem(item);
					break;
			}
			
			this.drawList();
		}

		private function collapseDisplayItem(item : DisplayItemData) : void {
			if(item.hasChildren) {
				if(item.displayObject is DisplayObjectContainer) {
					var container : DisplayObjectContainer = item.displayObject as DisplayObjectContainer;
					for(var i : int = 0;i < container.numChildren; i++) {
						removeItemAndChilds(getDisplayItem(container.getChildAt(i)));
					}
				}
			}
		}

		private function removeItemAndChilds(item : DisplayItemData) : void {
			this.removeDisplayItem(item);
			if(item.hasChildren) {
				var container : DisplayObjectContainer = item.displayObject as DisplayObjectContainer;
				for(var i : int = 0;i < container.numChildren; i++) {
					removeItemAndChilds(getDisplayItem(container.getChildAt(i)));
				}
			}
		}

		private function expandDisplayItem(item : DisplayItemData) : void {
			if(item.hasChildren) {
				if(item.displayObject is DisplayObjectContainer) {
					var container : DisplayObjectContainer = item.displayObject as DisplayObjectContainer;
					var childItem : DisplayItemData;
					for(var i : int = container.numChildren - 1;i >= 0; i--) {
						childItem = getDisplayItem(container.getChildAt(i));
						addDisplayItemAfter(childItem, item);
						if(childItem.hasChildren && childItem.isExpand) {
							expandDisplayItem(childItem);
						}
					}
				}
			}
		}

		/**
		 * 返回某个显示对象在结构树中的渲染节点.
		 */
		public function getObjectRenderer(object : DisplayObject) : * {
			var render : BaseDisplayItemView;
			
			var i : int = _list.numChildren;
			while(i--) {
				render = _list.getChildAt(i) as BaseDisplayItemView;
				if(render.data.displayObject == object) {
					return render as _itemRenderer;
					break;
				}
			}
			
			return null;
		}
	}
}
