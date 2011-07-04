package cn.itamt.utils.inspector.popup
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import cn.itamt.utils.inspector.events.PopupEvent;
	import cn.itamt.utils.inspector.ui.InspectorStageReference;
	/**
	 * @author itamt[at]qq.com
	 */
	public class InspectorPopupManager
	{

		private static var _childs:Array;
		//container where popup will be added in.
		private static var _container:DisplayObjectContainer;

		public static function contains(dp:DisplayObject):Boolean
		{
			if (dp == null || _childs == null)
				return false;
			var t:int=_childs.indexOf(dp);
			if (t >= 0)
			{
				return true;
			}
			else
			{
				for each (var child:DisplayObject in _childs)
				{
					if (child is DisplayObjectContainer)
					{
						if ((child as DisplayObjectContainer).contains(dp))
							return true;
					}
				}
				return false;
			}
		}

		public static function dispose():void
		{
			InspectorStageReference.removeEventListener(PopupEvent.ADD, onAddPopup);
			InspectorStageReference.removeEventListener(PopupEvent.REMOVE, onRemovePopup);
		}

		public static function init():void
		{
			InspectorStageReference.addEventListener(PopupEvent.ADD, onAddPopup);
			InspectorStageReference.addEventListener(PopupEvent.REMOVE, onRemovePopup);
		}

		/**
		 * popup一个显示对象
		 * @param dp			要popup的对象
		 * @param alignMode		popup时的对齐方式, 查看PopupAlignMode
		 * @param keepTime		popup持续多久(毫秒)后,进行移除, 0代表不移除.
		 */
		public static function popup(dp:DisplayObject, alignMode:int=9):void
		{
			if (_childs == null)
				_childs=[];
			var t:int=_childs.indexOf(dp);
			if (t >= 0)
			{
				_childs.splice(t, 1);
			}
			_childs.push(dp);

			if(_container){
				_container.addChild(dp);
			}else{
				InspectorStageReference.addChild(dp);
			}

			var stageBounds:Rectangle=InspectorStageReference.getStageBounds();

			switch (alignMode)
			{
				case PopupAlignMode.SHOW_ALL:
					reviseTipPanelPos(dp);
					break;
				case PopupAlignMode.CENTER:
					InspectorStageReference.centerOnStage(dp);
					break;
				case PopupAlignMode.TL:
					dp.x=stageBounds.left;
					dp.y=stageBounds.top;
					break;
				case PopupAlignMode.TOP:
					dp.x=stageBounds.left + stageBounds.width / 2 - dp.width / 2;
					dp.y=stageBounds.top;
					break;
			}
		}

		/**
		 * 去掉一个popup
		 */
		public static function remove(dp:DisplayObject):void
		{
			var t:int=_childs.indexOf(dp);
			if (t >= 0)
			{
				_childs.splice(t, 1);
			}

			if (dp.parent)
				dp.parent.removeChild(dp);
		}

		private static function onAddPopup(event:PopupEvent):void
		{
			remove(event.popup);
		}

		private static function onRemovePopup(event:PopupEvent):void
		{
			popup(event.popup);
		}

		/**
		 * 校正popup的位置，保证它在舞台内显示
		 */
		private static function reviseTipPanelPos(dp:DisplayObject):void
		{
			if (dp == null)
				return;

			var gpt:Point=InspectorStageReference.getBounds(dp).topLeft;

			var needRevise:Boolean;
			var rect:Rectangle=InspectorStageReference.getStageBounds();
			if (gpt.x > rect.right - dp.width)
			{
				gpt.x=gpt.x - dp.width - 16;
				needRevise=true;
			}

			if (gpt.x < rect.left)
			{
				gpt.x=rect.left;
				needRevise=true;
			}

			if (gpt.y > rect.bottom - dp.height)
			{
				gpt.y=gpt.y - dp.height;
				needRevise=true;
			}
			if (gpt.y < rect.top)
			{
				needRevise=true;
			}

			if (needRevise)
			{
				gpt=dp.parent.globalToLocal(gpt);
				dp.x=gpt.x;
				dp.y=gpt.y;
			}
		}

		static public function get container() : DisplayObjectContainer {
			return _container;
		}

		static public function set container(popupContainer : DisplayObjectContainer) : void {
			_container = popupContainer;
		}
	}
}
