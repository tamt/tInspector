package cn.itamt.utils.inspector.firefox.download {
	import cn.itamt.utils.ObjectPool;
	import cn.itamt.utils.inspector.firefox.reloadapp.ReloadButton;
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.ui.InspectorViewPanel;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author itamt[at]qq.com
	 */
	public class DownloadAllPanel extends InspectorViewPanel {
		private var _listContainer : Sprite;
		private var _data : Array;
		private var _itemRenderer : Class = LoadedStuffItemRenderer;
		private var _clearBtn : ReloadButton;
		private var _sortOnDomain : Boolean = true;

		public function DownloadAllPanel(title : String = 'resources list', w : Number = 340, h : Number = 200, autoDisposeWhenRemove : Boolean = true, resizeable : Boolean = true, closeable : Boolean = true) {
			super(title, w, h, autoDisposeWhenRemove, resizeable, closeable);

			_listContainer = new Sprite();
			this.setContent(_listContainer);

			_clearBtn = new ReloadButton();
			_clearBtn.tip = InspectorLanguageManager.getStr("Clear");
			_clearBtn.addEventListener(MouseEvent.CLICK, onClickClear);
			// this.addChild(this._clearBtn);
		}

		// // // // // // // // // // // // // // // // // // //
		// // // // // //      override     funcions/////////
		// // // // // // // // // // // // // // // // // // //
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

		// // // // // // // // // // // // // // // // // // //
		// // // // //     private    functions///////////
		// // // // // // // // // // // // // // // // // // //
		private function drawList() : void {
			_listContainer.graphics.clear();
			_listContainer.graphics.lineTo(0, 0);

			while(_listContainer.numChildren) {
				ObjectPool.disposeObject(_listContainer.removeChildAt(0), _itemRenderer);
			}

			// 按照域名进行排序
			var list : Array;
			if(_data) {
				list = _data.slice();
				if(_sortOnDomain) {
					list.sortOn("path");
					if(list.length > 1) {
						var lastDomainInfo : LoadedStuffInfo = new LoadedStuffInfo((list[0] as LoadedStuffInfo).path);
						list[0] = lastDomainInfo;
						for(var j : int = 1; j < list.length; j++) {
							var info : LoadedStuffInfo = list[j] as LoadedStuffInfo;
							if(info.path != lastDomainInfo.path) {
								list.splice(j, 0, new LoadedStuffInfo(info.path));
								lastDomainInfo = list[j];
							}
						}
					}
				} else {
					list.sortOn("time");
				}
			}

			var l : int = (list == null) ? 0 : list.length;
			var lastDomainLevel : uint = 0;
			var lastDomain : LoadedStuffInfo = list[0] as LoadedStuffInfo;
			for(var i : int = 1;i < l;i++) {
				var tinfo : LoadedStuffInfo = list[i] as LoadedStuffInfo;
				var render : LoadedStuffItemRenderer;
				render = ObjectPool.getObject(_itemRenderer);
				render.x = 0;
				render.y = _listContainer.height + 2;
				render.data = list[i];
				if(tinfo.contentType == null) {
					if(tinfo.path.indexOf(lastDomain.path) == 0) {
						lastDomainLevel++;
					} else {
						lastDomainLevel = 0;
					}
					render.paddingLeft = lastDomainLevel * 16;
					render.label = (tinfo.path.indexOf(lastDomain.path) == 0) ? tinfo.path.substring(lastDomain.path.length - 1, tinfo.path.length) : tinfo.path;
					lastDomain = tinfo;
				} else {
					render.paddingLeft = (lastDomainLevel + 1) * 16;
					render.label = tinfo.name;
				}
				_listContainer.addChild(render);
			}

			this.relayout();
		}

		private function onClickClear(event : MouseEvent) : void {
			this.dispatchEvent(new Event("clear"));
		}

		// // // // // // // // // // // // // // // // // // //
		// // // //    /public   functions/////////////
		// // // // // // // // // // // // // // // // // // //
		/**
		 * @param stuffList		an array store ErrorLog instances.
		 */
		public function setData(stuffList : Array) : void {
			this._data = stuffList;
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
