package cn.itamt.utils.inspector.tip {
	import cn.itamt.utils.inspector.ui.InspectorStageReference;

	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author itamt[at]qq.com
	 */
	public class InspectorPopupManager {

		private static var _childs : Array;

		public static function init() : void {	
			InspectorStageReference.addEventListener(PopupEvent.ADD, onAddPopup);
			InspectorStageReference.addEventListener(PopupEvent.REMOVE, onRemovePopup);
		}

		public static function dispose() : void {
			InspectorStageReference.removeEventListener(PopupEvent.ADD, onAddPopup);
			InspectorStageReference.removeEventListener(PopupEvent.REMOVE, onRemovePopup);
		}

		private static function onRemovePopup(event : PopupEvent) : void {
			popup(event.popup);
		}

		private static function onAddPopup(event : PopupEvent) : void {
			remove(event.popup);
		}

		/**
		 * 校正popup的位置，保证它在舞台内显示
		 */
		private static function reviseTipPanelPos(dp : DisplayObject) : void {
			if(dp == null)return;

			var gpt : Point = InspectorStageReference.getBounds(dp).topLeft;

			var needRevise : Boolean;
			var rect : Rectangle = InspectorStageReference.getStageBounds();
			if(gpt.x > rect.right - dp.width) {
				gpt.x = gpt.x - dp.width - 16;
				needRevise = true;
			}
			
			if(gpt.x < rect.left) {
				gpt.x = rect.left;
				needRevise = true;
			}
			
			if(gpt.y > rect.bottom - dp.height) {				gpt.y = gpt.y - dp.height;
				needRevise = true;
			}
			if(gpt.y < rect.top) {
				needRevise = true;
			}
			
			if(needRevise) {
				gpt = dp.parent.globalToLocal(gpt);
				dp.x = gpt.x;
				dp.y = gpt.y;
			}
		}

		/**
		 * popup一个显示对象
		 * @param dp			要popup的对象
		 * @param alignMode		popup时的对齐方式, 查看PopupAlignMode
		 * @param keepTime		popup持续多久(毫秒)后,进行移除, 0代表不移除.
		 */
		public static function popup(dp : DisplayObject, alignMode : int = 1, keepTime : uint = 0) : void {
			if(_childs == null)_childs = [];
			var t : int = _childs.indexOf(dp);
			if(t >= 0) {
				_childs.splice(t, 1);
			}
			_childs.push(dp);
			
			InspectorStageReference.addChild(dp);
			
			switch(alignMode) {
				case PopupAlignMode.SHOW_ALL:
					reviseTipPanelPos(dp);
					break;
				case PopupAlignMode.CENTER:
					InspectorStageReference.centerOnStage(dp);
					break;
			}
		}

		/**
		 * 去掉一个popup
		 */
		public static function remove(dp : DisplayObject) : void {
			var t : int = _childs.indexOf(dp);
			if(t >= 0) {
				_childs.splice(t, 1);
			}
			
			if(dp.stage)dp.parent.removeChild(dp);
		}

		public static function contains(dp : DisplayObject) : Boolean {
			if(dp == null)return false;
			return _childs.indexOf(dp) >= 0;
		}
	}
}
