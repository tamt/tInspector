package cn.itamt.utils.inspector.tip {
	import cn.itamt.utils.DisplayObjectTool;
	import cn.itamt.utils.inspector.ui.InspectorStageReference;
	import cn.itamt.utils.inspector.ui.InspectorTextField;

	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 * @author itamt@qq.com
	 */
	public class InspectorTipsManager {

		public static function init() : void {	
			InspectorStageReference.addEventListener(TipEvent.EVT_SHOW_TIP, onShowTip);
			InspectorStageReference.addEventListener(TipEvent.EVT_REMOVE_TIP, onRemoveTip);
		}

		public static function dispose() : void {
			InspectorStageReference.removeEventListener(TipEvent.EVT_SHOW_TIP, onShowTip);
			InspectorStageReference.removeEventListener(TipEvent.EVT_REMOVE_TIP, onRemoveTip);
		}

		private static var _tip : Sprite;		private static var _target : DisplayObject;

		/**
		 * 显示tip
		 */
		private static function onShowTip(evt : TipEvent) : void {
			_target = evt.target as DisplayObject;
				
			if(_tip) {
				_tip.graphics.clear();
				DisplayObjectTool.removeAllChildren(_tip);
				InspectorPopupManager.remove(_tip);
				_tip = null;
			}
				
			_tip = new Sprite();
			_tip.filters = [new GlowFilter(0x0, 1, 16, 16, 1)];
			_tip.mouseEnabled = _tip.mouseChildren = false;
				
			var _tf : TextField = InspectorTextField.create(evt.tip, 0xffffff, 15, 5, 0, 'left');
			_tf.y = 26 - _tf.height;
			_tip.addChild(_tf);
				
			var tipBg : Shape = new Shape();
			tipBg.graphics.beginFill(0x000000);
			tipBg.graphics.drawRoundRect(0, 26 - _tf.height, _tf.width + 10, _tf.height, 10, 10);
			tipBg.graphics.endFill();
			//				tipBg.graphics.beginFill(0x000000);
			//				tipBg.graphics.moveTo(9, 25);
			//				tipBg.graphics.lineTo(15, 25);
			//				tipBg.graphics.lineTo(12, 30);
			//				tipBg.graphics.lineTo(9, 25);
			//				tipBg.graphics.endFill();
			_tip.addChildAt(tipBg, 0);
			
			if(_target == null) {
				InspectorPopupManager.popup(_tip, PopupAlignMode.CENTER);
			} else {
				var rect : Rectangle = InspectorStageReference.getBounds(_target);
				_tip.x = rect.x - 5;
				_tip.y = rect.y + 25;
				
				InspectorPopupManager.popup(_tip);
			}
			
			evt.stopImmediatePropagation();
		}

		/**
		 * 移除tip
		 */
		private static function onRemoveTip(evt : Event) : void {
			if(_tip) {
				_tip.graphics.clear();
				DisplayObjectTool.removeAllChildren(_tip);
				InspectorPopupManager.remove(_tip);
				_tip = null;
			}
			evt.stopImmediatePropagation();
		}
	}
}
