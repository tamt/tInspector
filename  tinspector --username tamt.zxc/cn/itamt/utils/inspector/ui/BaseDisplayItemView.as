package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.inspector.data.DisplayItemData;
	import cn.itamt.utils.inspector.interfaces.IDisplayItemRenderer;
	
	import flash.display.Sprite;	

	/**
	 * DisplayObjectTree节点的渲染类.
	 * 开发时可以扩展它, 自定已DisplayObjectTree节点的渲染类; DisplayObjectTree.setItemRenderer(classRef);
	 * @author itamt@qq.com
	 */
	public class BaseDisplayItemView extends Sprite  implements IDisplayItemRenderer {

		protected var _data : DisplayItemData;
		public function get data() : DisplayItemData{
			return _data;
		}

		public function BaseDisplayItemView() {
		}

		public function setData(value : DisplayItemData) : void {
		}
	}
}
