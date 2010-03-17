package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.DisplayObjectTool;
	import cn.itamt.utils.inspector.consts.InspectorSymbolIcon;
	import cn.itamt.utils.inspector.data.DisplayItemData;
	import cn.itamt.utils.inspector.events.DisplayItemEvent;
	import cn.itamt.utils.inspector.output.DisplayObjectInfoOutPuter;
	import cn.itamt.utils.inspector.output.StructureTreeItemInfoOutputer;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;		

	public class StructureElementView extends BaseDisplayItemView {		
		private var _tf : TextField;
		private var btn : SimpleButton;
		private var symbol : Bitmap;

		public static var outputer : DisplayObjectInfoOutPuter;

		public function StructureElementView() : void {
			super();
             
			symbol = new Bitmap();
			addChild(symbol);
             
			_tf = InspectorTextField.create('', 0, 12);
			_tf.selectable = false;
			_tf.autoSize = 'left';
			addChild(_tf);
			
			btn = new SimpleButton();
			addChild(btn);
                        
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}

		private var inited : Boolean = false;

		private function onAdded(evt : Event) : void {
			if(inited)return;
			inited = true;
			_tf.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);			_tf.addEventListener(MouseEvent.CLICK, onClickItem);
			btn.addEventListener(MouseEvent.CLICK, onClickExpand);
		}

		private function onRemove(evt : Event) : void {
			this.dispose();
		}

		override public function setData(value : DisplayItemData) : void {
			this._data = value;
			
			if(outputer == null) outputer = new StructureTreeItemInfoOutputer();
			_tf.htmlText = outputer.output(this._data.displayObject);
			
			if(_data != value) {
				if(_data) {
					_data.removeEventListener(DisplayItemEvent.CHANGE, onDataChange);
				}
				_data = value;
				_data.addEventListener(DisplayItemEvent.CHANGE, onDataChange, false, 0, true);
			}
			
			var bmp : Bitmap;
			if(_data.hasChildren) {
				btn.visible = true;
				if(_data.isExpand) {
					//					this.btn.text = '－';
					bmp = new Bitmap(InspectorSymbolIcon.getIcon(InspectorSymbolIcon.CLLOAPSE));
				} else {
					//					this.btn.text = '＋';
					bmp = new Bitmap(InspectorSymbolIcon.getIcon(InspectorSymbolIcon.EXPAND));
				}
				this.btn.upState = this.btn.downState = this.btn.overState = this.btn.hitTestState = bmp;
			} else {
				btn.visible = false;
			}
			
			//			symbol.bitmapData = InspectorSymbolIcon.getIcon(className);			symbol.bitmapData = InspectorSymbolIcon.getIconByClass(this._data.displayObject);
			
			var level : int = DisplayObjectTool.getDisplayObjectLevel(_data.displayObject);
			btn.x = level * 16;
			symbol.x = btn.x + btn.width;			_tf.x = symbol.x + symbol.width;
			
			resetStyle();
			
			if(_data.isOnInspect) {
				_tf.background = true;
				_tf.backgroundColor = 0x0000ff;
			}
			
			if(_data.isOnLiveInspect) {
				this._tf.border = true;
				this._tf.borderColor = 0xff00ff;
			}
		}

		private function onMouseOver(evt : MouseEvent) : void {
			evt.stopImmediatePropagation();	
			this.dispatchEvent(new DisplayItemEvent(DisplayItemEvent.OVER, true, true));
		}

		/**
		 * 重置样式.
		 */
		public function resetStyle() : void {
			_tf.background = false;
			_tf.border = false;
		}

		/**
		 * 单击
		 */
		private function onClickItem(evt : MouseEvent) : void {
			evt.stopImmediatePropagation();
			
			this.dispatchEvent(new DisplayItemEvent(DisplayItemEvent.CLICK, true, true));
		}

		/**
		 * 单击展开/折叠按钮
		 */
		private function onClickExpand(evt : MouseEvent) : void {
			_data.toggleExpand();
		}

		/**
		 * 数据发生改变时
		 */
		private function onDataChange(evt : DisplayItemEvent) : void {
			this.setData(_data);
		}

		/**
		 * 销毁
		 */
		public function dispose() : void {
			inited = false;
			_tf.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			_tf.removeEventListener(MouseEvent.CLICK, onClickItem);
			btn.removeEventListener(MouseEvent.CLICK, onClickExpand);
		}
	}
}
