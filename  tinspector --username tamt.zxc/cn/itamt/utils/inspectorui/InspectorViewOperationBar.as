package cn.itamt.utils.inspectorui {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;	

	/**
	 * TODO:增加reset按钮
	 * @author tamt
	 */
	public class InspectorViewOperationBar extends Sprite {
		public static const PRESS_MOVE : String = 'press_move';
		public static const PRESS_PARENT : String = 'press_parent';
		public static const PRESS_CHILD : String = 'press_child';
		public static const PRESS_BROTHER : String = 'press_brother';
		public static const PRESS_INFO : String = 'press_info';
		public static const PRESS_CLOSE : String = 'press_close';
		public static const DOWN_MOVE : String = 'down_move';
		public static const UP_MOVE : String = 'up_move';
		//按钮
		private var _moveBtn : InspectorViewMoveButton;
		private var _pareBtn : InspectorViewParentButton;
		private var _childBtn : InspectorViewChildButton;
		private var _broBtn : InspectorViewBrotherButton;
		private var _infoBtn : InspectorViewInfoButton;
		private var _closeBtn : InspectorViewCloseButton;
		//布局
		private var _paddings : Array = [10, 5, 10];
		private var _btnGap : int = 5;
		private var _width : int = 200;
		//tip
		private var _tip : Sprite;

		public function InspectoViewOperationBar() : void {
		}

		public function init() : void {
			//背景
			graphics.clear();
			graphics.beginFill(0x393939);
			graphics.drawRoundRectComplex(0, 0, _width, 33, 8, 8, 0, 8);
			graphics.endFill();
		
			//按钮
			var btns : Array = [_moveBtn = new InspectorViewMoveButton, 
									_pareBtn = new InspectorViewParentButton, 
									_childBtn = new InspectorViewChildButton, 
									_broBtn = new InspectorViewBrotherButton, 
									_infoBtn = new  InspectorViewInfoButton];
			var btn : InspectorViewOperationButton;
			for(var i : int = 0;i < btns.length; i++) {
				btn = btns[i] as InspectorViewOperationButton;
				addChild(btn);
				if(i == 0) {
					btn.x = _paddings[0] + i * _btnGap;
				}else {
					btn.x = _paddings[0] + i * (_btnGap + (btns[i - 1] as InspectorViewOperationButton).width);
				}
				btn.y = _paddings[1]; 
			}
			//关闭按钮
			_closeBtn = new InspectorViewCloseButton;
			addChild(_closeBtn);
			_closeBtn.x = _width - _paddings[2] - _closeBtn.width;
			_closeBtn.y = _paddings[1];
			
			_moveBtn.addEventListener(MouseEvent.CLICK, onClickMoveBtn);			_moveBtn.addEventListener(MouseEvent.MOUSE_DOWN, onDownMoveBtn);			_moveBtn.addEventListener(MouseEvent.MOUSE_UP, onUpMoveBtn);
			_pareBtn.addEventListener(MouseEvent.CLICK, onClickParentBtn);
			_childBtn.addEventListener(MouseEvent.CLICK, onClickChildBtn);
			_broBtn.addEventListener(MouseEvent.CLICK, onClickBrotherBtn);
			_infoBtn.addEventListener(MouseEvent.CLICK, onClickInfoBtn);			_closeBtn.addEventListener(MouseEvent.CLICK, onClickCloseBtn);
			
			addEventListener(InspectorViewOperationButton.EVT_SHOW_TIP, onShowTip);			addEventListener(InspectorViewOperationButton.EVT_REMOVE_TIP, onRemoveTip);
		}

		private function onShowTip(evt : Event) : void {
			if(evt.target is InspectorViewOperationButton) {
				var target : InspectorViewOperationButton = evt.target as InspectorViewOperationButton;
				if(_tip) {
					_tip.graphics.clear();
					removeAllChildAndChild(_tip);
					removeChild(_tip);
					_tip = null;
				}
				_tip = new Sprite();
				var _tf : TextField = new TextField();
				_tf.textColor = 0xffffff;
				_tf.autoSize = 'left';
				_tf.text = target.tip;
				_tf.x = 5;
				_tf.y = 3;
				_tip.addChild(_tf);
				_tip.graphics.beginFill(0x000000);
				_tip.graphics.drawRoundRect(0, 0, _tf.width + 10, 26, 10, 10);
				_tip.graphics.endFill();
				_tip.graphics.beginFill(0x000000);
				_tip.graphics.moveTo(9, 25);
				_tip.graphics.lineTo(15, 25);
				_tip.graphics.lineTo(12, 30);
				_tip.graphics.lineTo(9, 25);
				_tip.graphics.endFill();
				addChild(_tip);
				
				_tip.x = target.x - 5;
				_tip.y = target.y - _tip.height - 5;
			}
			
			evt.stopImmediatePropagation();
		}

		private function onRemoveTip(evt : Event) : void {
			if(_tip) {
				_tip.graphics.clear();
				removeAllChildAndChild(_tip);
				removeChild(_tip);
				_tip = null;
			}
			evt.stopImmediatePropagation();
		}

		private function onClickMoveBtn(evt : MouseEvent) : void {
			dispatchEvent(new Event(PRESS_MOVE));
		}

		private function onDownMoveBtn(evt : MouseEvent) : void {
			dispatchEvent(new Event(DOWN_MOVE));
		}

		private function onUpMoveBtn(evt : MouseEvent) : void {
			dispatchEvent(new Event(UP_MOVE));
		}

		private function onClickParentBtn(evt : MouseEvent) : void {
			dispatchEvent(new Event(PRESS_PARENT));
		}

		private function onClickChildBtn(evt : MouseEvent) : void {
			dispatchEvent(new Event(PRESS_CHILD));
		}

		private function onClickBrotherBtn(evt : MouseEvent) : void {
			dispatchEvent(new Event(PRESS_BROTHER));
		}

		private function onClickInfoBtn(evt : MouseEvent) : void {
			dispatchEvent(new Event(PRESS_INFO));
		}

		private function onClickCloseBtn(evt : MouseEvent) : void {
			dispatchEvent(new Event(PRESS_CLOSE));
		}

		/**
		 * 销毁对象
		 */
		public function dispose() : void {
		}

		/**
		 * 验证target, 是否禁用相关按钮
		 */
		public function validate(target : DisplayObject) : void {
			_moveBtn.enabled = _pareBtn.enabled = _childBtn.enabled = _broBtn.enabled = _infoBtn.enabled = _closeBtn.enabled = true;
			
			if(target is Stage) {
				_moveBtn.enabled = false;
			}
			
			if(target.parent) {
				if(target.parent is Stage) {
					_pareBtn.enabled = false;
				}
				if(target.parent.numChildren == 1) {
					_broBtn.enabled = false;
				}
			}else {
				_pareBtn.enabled = false;
				_broBtn.enabled = false;
			}
			
			if(target is DisplayObjectContainer){
			}else {
				_childBtn.enabled = false;
			}
		}

		/**
		 * 移除显示容器底下, 所有所有的显示对象. 不仅仅是子级.
		 */
		private function removeAllChildAndChild(container : DisplayObjectContainer) : void {
			while (container.numChildren) {
				if (container.getChildAt(0) is DisplayObjectContainer) {
					removeAllChildAndChild(container.getChildAt(0) as DisplayObjectContainer);
				}
				container.removeChildAt(0);
			}
		}
	}
}
