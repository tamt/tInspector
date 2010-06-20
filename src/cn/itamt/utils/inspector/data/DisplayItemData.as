package cn.itamt.utils.inspector.data {
	import cn.itamt.utils.inspector.events.DisplayItemEvent;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;	

	/**
	 * @author itamt@qq.com
	 */
	public class DisplayItemData extends EventDispatcher {

		public var displayObject : DisplayObject;
		public var hasChildren : Boolean = false;
		public var isExpand : Boolean;

		public var isOnInspect : Boolean;
		public var isOnLiveInspect : Boolean;

		public function DisplayItemData(object : DisplayObject, isExpand : Boolean = false) {
			displayObject = object;
			
			if(displayObject is DisplayObjectContainer) {
				if((displayObject as DisplayObjectContainer).numChildren) {
					hasChildren = true;
					this.isExpand = isExpand;
				}
			}
		}

		public function toggleExpand() : void {
			if(isExpand) {
				this.collapseChilds();
			} else {
				this.expandChilds();
			}
		}

		/**
		 * 展开孩子节点
		 */
		public function expandChilds() : void {
			this.isExpand = true;
			this.dispatchEvent(new DisplayItemEvent(DisplayItemEvent.EXPAND));			this.dispatchEvent(new DisplayItemEvent(DisplayItemEvent.CHANGE));
		}

		/**
		 * 折叠孩子几点
		 */
		public function collapseChilds() : void {
			this.isExpand = false;
			this.dispatchEvent(new DisplayItemEvent(DisplayItemEvent.COLLAPSE));			this.dispatchEvent(new DisplayItemEvent(DisplayItemEvent.CHANGE));
		}

		/**
		 * "查看"
		 */
		public function onInspect(val : Boolean) : void {
			this.isOnInspect = val;
			this.dispatchEvent(new DisplayItemEvent(DisplayItemEvent.CHANGE));
		}

		/**
		 * "实时查看"
		 */
		public function onLiveInspect(val : Boolean) : void {
			this.isOnLiveInspect = val;
			this.dispatchEvent(new DisplayItemEvent(DisplayItemEvent.CHANGE));
		}
	}
}
