package cn.itamt.utils.inspector.tip {
	import flash.display.DisplayObject;

	import cn.itamt.utils.DisplayObjectTool;
	import cn.itamt.utils.inspector.ui.InspectorStageReference;
	import cn.itamt.utils.inspector.ui.InspectorTextField;
	import cn.itamt.utils.inspector.ui.InspectorViewOperationButton;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 * @author itamt@qq.com
	 */
	public class InspectorTipsManager {

		public static function init() : void {	
			InspectorStageReference.addEventListener(InspectorViewOperationButton.EVT_SHOW_TIP, onShowTip);
			InspectorStageReference.addEventListener(InspectorViewOperationButton.EVT_REMOVE_TIP, onRemoveTip);
		}

		public static function dispose() : void {
			InspectorStageReference.removeEventListener(InspectorViewOperationButton.EVT_SHOW_TIP, onShowTip);
			InspectorStageReference.removeEventListener(InspectorViewOperationButton.EVT_REMOVE_TIP, onRemoveTip);
		}

		
		//tip
		private static var _tip : Sprite;		private static var _target : InspectorViewOperationButton;
		
		/**
		 * 显示tip
		 */
		private static function onShowTip(evt : Event) : void {
			if(evt.target is InspectorViewOperationButton) {
				_target = evt.target as InspectorViewOperationButton;
				if(_tip) {
					_tip.graphics.clear();
					DisplayObjectTool.removeAllChildren(_tip);
					if(_tip.stage)_tip.parent.removeChild(_tip);
					_tip = null;
				}
				_tip = new Sprite();
				_tip.filters = [new GlowFilter(0x0, 1, 16, 16, 1)];
				_tip.mouseEnabled = _tip.mouseChildren = false;
				
				var _tf : TextField = InspectorTextField.create(_target.tip, 0xffffff, 15, 5, 0, 'left');
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
				
				_target.stage.addChild(_tip);
				
				//				var pt : Point = target.localToGlobal(new Point(0, 0));
				var rect : Rectangle = _target.getBounds(_target.stage);
				
				_tip.x = rect.x - 5;
				_tip.y = rect.y - 35;
				
				reviseTipPanelPos();
				//
//				DisplayObjectTool.swapToTop(_tip);
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
				if(_tip.stage)_tip.parent.removeChild(_tip);
				_tip = null;
			}
			evt.stopImmediatePropagation();
		}

		/**
		 * 校正tip的位置，保证它在舞台内显示
		 */
		private static function reviseTipPanelPos() : void {
			if(!_tip.stage)return;
			
			var gpt : Point = _target.localToGlobal(new Point());
			var bg : DisplayObject = _tip.getChildAt(0);
			
			var needRevise : Boolean;
			if(gpt.x > _tip.stage.stageWidth - _tip.width) {
				gpt.x = gpt.x - _tip.width - 16;
				needRevise = true;
			}
			
			if(gpt.x < 0) {
				gpt.x = 0;
				needRevise = true;
			}
			if(gpt.y > _tip.stage.stageHeight - _tip.height) {
				gpt.y = gpt.y - _tip.height - _target.height;
				needRevise = true;
			}
			if(gpt.y < _tip.height) {
				gpt.y = _target.height + gpt.y;
				needRevise = true;
				bg.scaleY = -1;
				bg.y = bg.height + 8;
			}
			
			if(needRevise) {
				gpt = _tip.parent.globalToLocal(gpt);
				_tip.x = gpt.x;
				_tip.y = gpt.y;
			}
		}
	}
}
