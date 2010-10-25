package cn.itamt.utils.inspector.plugins.gerrorkeeper {
	import cn.itamt.utils.ObjectPool;
	import cn.itamt.utils.inspector.firefox.reloadapp.ReloadButton;
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.ui.InspectorLabelButton;
	import cn.itamt.utils.inspector.ui.InspectorTextField;
	import cn.itamt.utils.inspector.ui.InspectorViewPanel;
	import cn.itamt.utils.inspector.ui.Padding;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.StyleSheet;
	import flash.text.TextField;

	/**	 * @author itamt[at]qq.com	 */
	public class ErrorListPanel extends InspectorViewPanel {
		private var _listContainer : Sprite;
		private var _data : Array;
		private var _itemRenderer : Class = ErrorLogItemRenderer;
		private var _clearBtn : ReloadButton;
		private var _statusInfo : TextField;
		public var alertBtn : InspectorLabelButton;

		public function ErrorListPanel(title : String = '错误列表', w : Number = 200, h : Number = 200, autoDisposeWhenRemove : Boolean = true, resizeable : Boolean = true, closeable : Boolean = true) {
			super(title, w, h, autoDisposeWhenRemove, resizeable, closeable);
			_listContainer = new Sprite();
			this.setContent(_listContainer);
			_clearBtn = new ReloadButton();
			_clearBtn.tip = InspectorLanguageManager.getStr("GEK_ClearHistory");
			_clearBtn.addEventListener(MouseEvent.CLICK, onClickClear);
			this.addChild(this._clearBtn);
			this._padding = new	Padding(33, 10, 40, 10);
			// 刷新按钮
			alertBtn = new InspectorLabelButton(InspectorLanguageManager.getStr("GEK_ENABLE_POPUP"));
			alertBtn.addEventListener(MouseEvent.CLICK, onToggleAlert);
			addChild(alertBtn);

			_statusInfo = InspectorTextField.create('', 0xcccccc, 12);
			_statusInfo.selectable = false;
			_statusInfo.height = 20;

			var styleSheet : StyleSheet = new StyleSheet();
			styleSheet.setStyle('a:hover', {textDecoration:"underline"});
			styleSheet.setStyle('a', {color:"#99cc00"});
			_title.styleSheet = styleSheet;
			addChild(_statusInfo);
		}

		// // // // // // // // // // //////////////////
		// // // // // //      override     funcions/////////
		// // // // // // // // // // //////////////////
		override public function relayout() : void {
			super.relayout();
			_clearBtn.x = this.resizeBtn.x - this.resizeBtn.width - 2;
			_clearBtn.y = 5;

			alertBtn.x = _width - _padding.right - alertBtn.width;
			alertBtn.y = _height - alertBtn.height - 10;
			
			drawStatus();
		}

		/**		 * 销毁		 */
		override public function dispose() : void {
			alertBtn.removeEventListener(MouseEvent.CLICK, onToggleAlert);
			alertBtn = null;
			_data = null;
			_itemRenderer = null;
			while(_listContainer.numChildren) {
				_listContainer.removeChildAt(0);
			}
			super.dispose();
		}

		override public function open():void {
			super.open();
			this.alertBtn.visible = true;
			this._statusInfo.visible = true;
		}

		override public function hide():void {
			super.hide();
			this.alertBtn.visible = false;
			this._statusInfo.visible = false;
		}

		// // // // // // // // // // //////////////////
		// // // // //     private    functions///////////
		// // // // // // // // // // //////////////////

		private function drawStatus() : void {
			_statusInfo.width = _statusInfo.textWidth + 4;
			if(_statusInfo.width > _width - _padding.left - _padding.right)
				_statusInfo.width = _width - _padding.left - _padding.right;
			_statusInfo.x = _padding.left;
			_statusInfo.y = _height - _padding.bottom / 2 - _statusInfo.height / 2;
		}

		private function drawList() : void {
			
			_listContainer.graphics.clear();
			_listContainer.graphics.lineTo(0, 0);
			while(_listContainer.numChildren) {
				ObjectPool.disposeObject(_listContainer.removeChildAt(0), _itemRenderer);
			}
			var l : int = (_data == null) ? 0 : _data.length;
			for(var i : int = 0;i < l;i++) {
				var render : ErrorLogItemRenderer;
				render = ObjectPool.getObject(ErrorLogItemRenderer);
				render.x = 0;
				render.y = _listContainer.height + 2;
				render.data = _data[i];
				_listContainer.addChild(render);
			}
			
			_statusInfo.text = l.toString();
			
			this.relayout();
		}

		private function onClickClear(event : MouseEvent) : void {
			this.dispatchEvent(new Event("clear"));
		}

		private function onToggleAlert(event : MouseEvent) : void {
			this.dispatchEvent(new Event("change"));
		}

		// // // // // // // // // // //////////////////
		// // // //    /public   functions/////////////
		// // // // // // // // // // //////////////////
		/**		 * @param errorList		an array store ErrorLog instances.		 */
		public function setData(errorList : Array) : void {
			this._data = errorList;
			this.drawList();
		}

		/**		 * call this method when errorList is change.		 */
		public function update() : void {
			this.drawList();
		}
	}
}