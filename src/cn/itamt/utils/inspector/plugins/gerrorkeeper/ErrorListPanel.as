package cn.itamt.utils.inspector.plugins.gerrorkeeper {
	import cn.itamt.utils.ObjectPool;
	import cn.itamt.utils.inspector.filter.InspectorFilterItemRenderer;
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.ui.ReloadButton;
	import cn.itamt.utils.inspector.ui.InspectorViewPanel;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author itamt[at]qq.com
	 */
	public class ErrorListPanel extends InspectorViewPanel {

		private var _listContainer : Sprite;
		private var _data : Array;
		private var _itemRenderer : Class = InspectorFilterItemRenderer;

		private var _clearBtn : ReloadButton;

		public function ErrorListPanel(title : String = '错误列表', w : Number = 200, h : Number = 200, autoDisposeWhenRemove : Boolean = true, resizeable : Boolean = true, closeable : Boolean = true) {
			super(title, w, h, autoDisposeWhenRemove, resizeable, closeable);
		
			_listContainer = new Sprite();
			this.setContent(_listContainer);
			
			_clearBtn = new ReloadButton();
			_clearBtn.tip = InspectorLanguageManager.getStr("GEK_ClearHistory");
			_clearBtn.addEventListener(MouseEvent.CLICK, onClickClear);
			this.addChild(this._clearBtn);
		}

		//////////////////////////////////////
		////////////override funcions/////////
		//////////////////////////////////////
		override public function relayout() : void {
			super.relayout();
			
			_clearBtn.x = this.resizeBtn.x - this.resizeBtn.width - 2;
			_clearBtn.y = 5;
		}

		/**
		 * 销毁
		 */
		override public function dispose() : void {
			super.dispose();
			
			_data = null;
			_itemRenderer = null;
			while(_listContainer.numChildren) {
				_listContainer.removeChildAt(0);
			}
		}

		//////////////////////////////////////
		//////////private functions///////////
		//////////////////////////////////////

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
			
			this.relayout();			
		}

		private function onClickClear(event : MouseEvent) : void {
			this.dispatchEvent(new Event(Event.CLEAR));
		}

		
		//////////////////////////////////////
		/////////public functions/////////////
		//////////////////////////////////////

		/**
		 * @param errorList		an array store ErrorLog instances.
		 */
		public function setData(errorList : Array) : void {
			this._data = errorList;
			this.drawList();
		}

		/**
		 * call this method when errorList is change.
		 */
		public function update() : void {
			this.drawList();
		}
	}
}
