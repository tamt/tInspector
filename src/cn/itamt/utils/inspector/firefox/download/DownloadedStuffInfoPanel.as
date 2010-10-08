package cn.itamt.utils.inspector.firefox.download {
	import cn.itamt.utils.inspector.core.propertyview.PropertyPanel;
	import cn.itamt.utils.inspector.core.propertyview.accessors.PropertyAccessorRender;

	import flash.events.MouseEvent;

	/**
	 * @author itamt[at]qq.com
	 */
	public class DownloadedStuffInfoPanel extends PropertyPanel {
		public function DownloadedStuffInfoPanel(w : Number = 340, h : Number = 230, owner : PropertyAccessorRender = null, favoritable : Boolean = false) {
			super(w, h, owner, favoritable);

			this.removeChild(this.viewMethodBtn);
			this.removeChild(this.viewPropBtn);
			this.removeChild(this.singletonBtn);
			this.removeChild(this.refreshBtn);
		}

		override protected function onClickFull(evt : MouseEvent = null) : void {
			if(evt)
				evt.stopImmediatePropagation();
			this.drawList();
			// if(this.resizeBtn.normalMode) {
			// if(_fSavedSize == null) {
			// _fSavedSize = new Point(this._width, 400);
			// } else {
			// _fSavedSize = new Point(this._width, this.height);
			// }
			// if(_mSavedSize == null)
			// _mSavedSize = new Point(this._width, 270);
			// this.addChild(this.search);
			// if(this.resizeBtn.normalMode)
			// this.resize(_mSavedSize.x, _mSavedSize.y);
			// }
		}
	}
}
