package cn.itamt.utils.inspector.renders {
	import cn.itamt.utils.inspector.events.PropertyEvent;
	import cn.itamt.utils.inspector.ui.InspectorViewPanel;
	import cn.itamt.utils.inspector.ui.Padding;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author itamt[at]qq.com
	 */
	public class EnumValueListEditor extends BasePropertyEditor {
		protected var _curItem : EnumValueItemRenderer;
		protected var _items : Array;
		protected var _itemsPanel : InspectorViewPanel;

		public function EnumValueListEditor() {
			super();
		}

		private function onSelectItem(evt : Event) : void {
			if(evt.type == Event.SELECT) {
				_value = (evt.target as EnumValueItemRenderer).editor.getValue();
				this.dispatchEvent(new PropertyEvent(PropertyEvent.UPDATE, true, true));
			} else {
				this.setValue(_value);
			}
			
			evt.stopImmediatePropagation();
			
			if(_itemsPanel) {
				if(_itemsPanel.parent) {
					_itemsPanel.parent.removeChild(_itemsPanel);
					this.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					_itemsPanel = null;
				}
			}
		}

		override protected function onReadWrite() : void {
			this.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(event : MouseEvent) : void {
			if(_itemsPanel == null) {
				_itemsPanel = new InspectorViewPanel('', 180, 160, true, false, false);
				_itemsPanel.minH = _itemsPanel.minW = 30;
				_itemsPanel.padding = new Padding(10, 10, 10, 10);
				_itemsPanel.setContent(new Sprite());
			}
			
			if(_items) {
				var maxw : Number = 0;
				for(var i : int = 0;i < _items.length;i++) {
					var item : EnumValueItemRenderer = _items[i];
					_items[i].x = 0;
					maxw = Math.max(maxw, _items[i].width);
					if(i > 0) {
						_items[i].y = _items[i - 1].y + _items[i - 1].height + 3;
					} else {
						_items[i].y = 0;
					}
					(_itemsPanel.getContent() as Sprite).addChild(item);
					_itemsPanel.resize(maxw + 20, _items[i].y + _items[i].height + 20);
				}
			}
			
			this.stage.addChild(_itemsPanel);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			_itemsPanel.x = this.stage.mouseX;			_itemsPanel.y = this.stage.mouseY;
		}

		private function onMouseUp(evt : MouseEvent) : void {
			
			if(_itemsPanel) {
				if(_itemsPanel.parent) {
					if(!_itemsPanel.hitTestPoint(this.stage.mouseX, this.stage.mouseY)) {
						_itemsPanel.parent.removeChild(_itemsPanel);
						this.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
						_itemsPanel = null;
			
						if(_curItem) {
							_curItem.x = 0;
							_curItem.y = 0;
							addChild(_curItem);
						}
					}
				}
			}
		}

		override public function setValue(value : *) : void {
			super.setValue(value);
			
			for each(var item:EnumValueItemRenderer in _items) {
				if(item.editor.getValue() == _value) {
					item.selected = true;
					if(item != _curItem) {
						if(_curItem && contains(_curItem))removeChild(_curItem);
						_curItem = item;
					}
				} else {
					item.selected = false;
				}
			}
			
			if(_curItem) {
				_curItem.x = 0;
				_curItem.y = 0;
				addChild(_curItem);
			}
		}

		/**
		 * 增加一个枚举数据
		 */
		public function addEnumValueEditor(editor : BasePropertyEditor) : void {
			if(_items == null)_items = [];
			if(_items.indexOf(editor) >= 0)return;
			
			var item : EnumValueItemRenderer = new EnumValueItemRenderer(editor);
			_items.push(item);

			item.addEventListener(Event.SELECT, onSelectItem);			item.addEventListener(Event.CANCEL, onSelectItem);
		}

		override public function relayOut() : void {
		}
	}
}
