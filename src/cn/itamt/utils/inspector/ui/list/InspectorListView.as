package cn.itamt.utils.inspector.ui.list 
{
	import cn.itamt.display.tSprite;
	import cn.itamt.utils.Debug;
	import cn.itamt.utils.DisplayObjectTool;
	import cn.itamt.utils.inspector.core.structureview.IDisplayItemRenderer;
	import cn.itamt.utils.ObjectPool;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * tInspector的List组件
	 * @author tamt
	 */
	public class InspectorListView extends tSprite 
	{
		protected var _data : Array;
		protected var _list:Sprite;
		protected var _itemViewClass:Class;
		//逻辑渲染区域
		protected var _renderArea:Rectangle;
		protected var _lineHeight:Number = 20;
		protected var _gap:Number = 2;
		
		public function InspectorListView(itemViewClass:Class) 
		{
			_itemViewClass = itemViewClass;
			_data = new Array;
			_list = new Sprite;
			super();
		}
		
		override protected function onAdded():void {
			if (_data) {
				if (_renderArea == null) {
					_renderArea = new Rectangle(0, 0, 200, lineHeight * (_data.length + _gap) - _gap);
				}
				drawList();
			}
		}
		
		/**
		 * 更新显示(绘制)
		 */
		public function drawList() : void {
			if (_renderArea == null) return;
			var rendersNum:uint;
			for(var i : int = 0;i < _data.length;i++) {
				if (_renderArea.top - lineHeight - _gap < i * lineHeight && _renderArea.bottom > i * lineHeight) {
					var render : DisplayObject;
					if (rendersNum < _list.numChildren) {
						render = _list.getChildAt(rendersNum) as DisplayObject;
						if (render == null) {
							render = ObjectPool.getObject(_itemViewClass) as DisplayObject;
							_list.addChild(render);
						}
					}else {
						render = new _itemViewClass();
						_list.addChild(render);
					}
					
					if(render is IDisplayItemRenderer)(render as IDisplayItemRenderer).setData(_data[i]);
					render.x = 0;
					render.y = i * lineHeight + 2;
					
					rendersNum++;
				}else {
				}
			}
			
			while (rendersNum < _list.numChildren) {
				ObjectPool.disposeObject(_list.removeChildAt(_list.numChildren -1), _itemViewClass);
			}
		}
		
		public function get lineHeight():Number 
		{
			return _lineHeight;
		}
		
		public function set lineHeight(value:Number):void 
		{
			_lineHeight = value;
		}
		
		private var _invalidate:Boolean = false;
		public function set renderArea(rect:Rectangle):void 
		{
			_renderArea = rect;
			if (!_invalidate) {
				_invalidate = true;
				DisplayObjectTool.callLater(renderList);
			}
		}
		
		public function get renderArea():Rectangle {
			return _renderArea;
		}
		
		public function get data():Array 
		{
			return _data;
		}
		
		public function set data(value:Array):void 
		{
			_data = value;
			if (_inited) {
				this.drawList();
			}
		}
		
		private function renderList():void {
			_invalidate = false;
			drawList();
		}
		
	}

}