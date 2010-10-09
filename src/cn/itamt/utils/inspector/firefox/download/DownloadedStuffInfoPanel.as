package cn.itamt.utils.inspector.firefox.download {
	import cn.itamt.utils.inspector.core.propertyview.PropertyPanel;
	import cn.itamt.utils.inspector.core.propertyview.accessors.PropertyAccessorRender;

	import flash.events.MouseEvent;

	/**
	 * @author itamt[at]qq.com
	 */
	public class DownloadedStuffInfoPanel extends PropertyPanel {
		public function DownloadedStuffInfoPanel(w : Number = 300, h : Number = 200) {
			super(w, h, null, false);

			this.removeChild(this.viewMethodBtn);
			this.removeChild(this.viewPropBtn);
			this.removeChild(this.singletonBtn);
			this.removeChild(this.refreshBtn);
			this.search.visible = false;
		}

		override protected function onClickFull(evt : MouseEvent = null) : void {
			if(evt)
				evt.stopImmediatePropagation();
			this.drawList();
		}

		// 对象的属性重绘
		override protected function drawPropList() : void {
			list.graphics.clear();
			list.graphics.lineTo(0, 0);
			while(list.numChildren) {
				list.removeChildAt(0);
			}

			if(propList) {
				var l : int = propList.length;
				for(var i : int = 0;i < l;i++) {
					var render : PropertyAccessorRender;
					render = new PropertyAccessorRender(200, 20, false, this.owner, this.favoritable);
					render.setXML(this.curTarget, propList[i]);
					render.y = list.height + 4;

					list.addChild(render);
				}
			}
		}
	}
}
