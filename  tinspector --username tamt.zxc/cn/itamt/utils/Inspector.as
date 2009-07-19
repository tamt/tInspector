package cn.itamt.utils {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;	

	/**
	 * TODO:[tamt]實現像調試時可用鼠標查看元素相關信息的Inspector
	 * @author tamt
	 * @example
	 * 	<code>
	 * 		_inspector = Inspector.getInstance();
	 * 		_inspector.stage = this;
	 * 		_inspector.init();
	 * 	</code>
	 * @version 0.2
	 */
	public class Inspector {
		private static var _instance : Inspector;
		public var stage : DisplayObjectContainer;
		private var inspectView : InspectView;
		private var ctmenu : NpContextMenu;

		public function Inspector(sf : SingletonEnforcer) {
			super();
		}

		public static function getInstance() : Inspector {
			if(_instance == null) {
				_instance = new Inspector(new SingletonEnforcer());
			}

			return _instance;
		}

		/**
		 * @param withMenu			是否在右键中显示操作选项
		 */
		public function init(withMenu : Boolean = false) : void {

			if(stage == null) {
				throw new Error("Set inspector's stage before you call inspector.init(); ");
				return;
			}
			inspectView = new InspectView();
			if(withMenu)createContextMenu();
		}

		private function createContextMenu() : void {
			ctmenu = new NpContextMenu(stage);
			ctmenu.addMenuItem('Inspector On', true);
			ctmenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleMenuSelection);
		}

		private function handleMenuSelection(evt : ContextMenuEvent) : void {
			switch(ctmenu.selectedMenu) {
				case 'Inspector On':
					ctmenu.removeMenuItem('Inspector On');
					ctmenu.addMenuItem('Inspector Off', true);

					startLiveInspect();
					break;
				case 'Inspector Off':
					ctmenu.removeMenuItem('Inspector Off');
					ctmenu.addMenuItem('Inspector On', true);

					stopLiveInspect();
					break;
			}
		}

		/**
		 * 开启查看
		 */
		private var isOn : Boolean = false;
		/**
		 * 只检测查看InteractiveObject的显示对象
		 */
		private var inspectMode : String = InspectMode.ALL_DISPLAY_OBJECT;

		public function startLiveInspect() : void {
			if(isOn)return;
			isOn = true;
			curInspectEle = null;
			
			switch(inspectMode) {
				case InspectMode.ALL_DISPLAY_OBJECT:
					this.stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, int.MAX_VALUE);
					break;
				case InspectMode.ONLY_INTERACTIVE_OBJECT:
					this.stage.addEventListener(MouseEvent.MOUSE_OVER, mouseHandler, false, int.MAX_VALUE);
					break;
			}

			inspectView = new InspectView();
			inspectView.addEventListener(InspectView.MOVE, onInspectViewMove);
			inspectView.addEventListener(InspectView.START_MOVE, onInspectViewStartMove);
			inspectView.addEventListener(InspectView.END_MOVE, onInspectViewEndMove);			inspectView.addEventListener(InspectView.RESET_MOVE, onInspectViewResetMove);
		}

		/**
		 * 关闭查看
		 */
		public function stopLiveInspect() : void {
			if(!isOn)return;
			isOn = false;
			curInspectEle = null;
			this.stage.removeEventListener(MouseEvent.MOUSE_OVER, mouseHandler, false);
			this.stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			inspectView.removeEventListener(InspectView.MOVE, onInspectViewMove);
			inspectView.removeEventListener(InspectView.START_MOVE, onInspectViewStartMove);
			inspectView.removeEventListener(InspectView.END_MOVE, onInspectViewEndMove);
			inspectView.removeEventListener(InspectView.RESET_MOVE, onInspectViewResetMove);
			this.inspectView.dispose();
			if(this.inspectView.parent)this.inspectView.parent.removeChild(this.inspectView);
			this.inspectView = null;
		}

		private function enterFrameHandler(evt : Event = null) : void {
			var mousePos : Point = new Point(stage.mouseX, stage.mouseY);
			var objs : Array = stage.getObjectsUnderPoint(mousePos);
			var l : int = objs.length;
			
			if(l) {
				while(l--) {
					var target : DisplayObject = objs[l] as DisplayObject; 
					if(target != inspectView && target.parent != inspectView) {
						inspect(target);
						break;
					}
				}
			}
		}

		private function mouseHandler(evt : MouseEvent) : void {
			if(evt.target == this.stage) {
				return;
			}
			if(evt.target != inspectView) {
				inspect(evt.target as DisplayObject);
			}
		}

		private var curInspectEle : DisplayObject;

		private function inspect(ele : DisplayObject) : void {
			if(curInspectEle == ele)return;
			curInspectEle = ele;
			showCurInspectView(ele);
		}

		private function showCurInspectView(ele : DisplayObject) : void {

			stage.addChildAt(inspectView, stage.numChildren);
			
			inspectView.target = ele;
			inspectView.update();
		}

		var regPoint : Point; 
		var	regTargetPoint : Point;

		private function onInspectViewMove(evt : Event = null) : void {
			inspectView.target.x = regTargetPoint.x - (regPoint.x - inspectView.mouseX);			inspectView.target.y = regTargetPoint.y - (regPoint.y - inspectView.mouseY);
			inspectView.update();
		}

		private function onInspectViewStartMove(evt : Event = null) : void {
			lock(inspectView.target);
			
			regPoint = new Point(inspectView.mouseX, inspectView.mouseY);
			regTargetPoint = new Point(inspectView.target.x, inspectView.target.y);
		}

		private function onInspectViewEndMove(evt : Event = null) : void {
			unlock();
		}

		private function onInspectViewResetMove(evt : Event = null) : void {
			inspectView.target.x = regTargetPoint.x;
			inspectView.target.y = regTargetPoint.y;
			
			inspectView.update();
		}

		/**
		 * 锁定查看元素
		 */
		public function lock(ele : DisplayObject) : void {
			if(ele != curInspectEle) {
				inspect(ele);
			}
			this.stage.removeEventListener(MouseEvent.MOUSE_OVER, mouseHandler, false);
		}

		/**
		 * 解锁查看元素
		 */
		public function unlock() : void {
			this.stage.addEventListener(MouseEvent.MOUSE_OVER, mouseHandler, false);	
		}
		
		/*
			 
			关闭按钮
			var close_sp:Shape = new Shape();
			addChild(close_sp);
			with(close_sp){
				//背景
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();
				
				graphics.lineStyle(3, 0xff0000);
				graphics.moveTo(8.7, 8.7);
				graphics.lineTo(14.2, 14.2);
				graphics.moveTo(8.7, 14.2);
				graphics.lineTo(14.2, 8.7);
			} 
		 */
	}
}

import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.utils.getQualifiedClassName;

class SingletonEnforcer {
}

class InspectMode {
	public static const ONLY_INTERACTIVE_OBJECT : String = 'only_interactive_obj';
	public static const ALL_DISPLAY_OBJECT : String = 'all_display_obj';
}

class InspectView extends Sprite {
	public static const MOVE : String = 'move';
	public static const START_MOVE : String = 'start_move';
	public static const END_MOVE : String = 'end_move';
	public static const RESET_MOVE : String = 'reset_move';
	public var target : DisplayObject;
	private var _des : TextField;
	private var _mBtn : Shape;

	public function InspectView() : void {
		super();
		
		buttonMode = true;
		
		_des = new TextField();
		_des.autoSize = TextFieldAutoSize.LEFT;
		_des.textColor = 0x99cc00;
		_des.background = true;
		_des.backgroundColor = 0x000000;
		_des.border = true;
		_des.borderColor = 0xffffff;
		addChild(_des);
		
		_mBtn = new Shape();
		addChild(_mBtn);
		
		if(stage) {
			initEventListeners();
		}else {
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
	}

	private function initEventListeners() : void {
		//		stage.doubleClickEnabled = true;
		//		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		//		stage.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
		addEventListener(MouseEvent.CLICK, onClick);
	}

	private function onClick(evt : MouseEvent = null) : void {
	}

	private function onAddToStage(evt : Event = null) : void {
		initEventListeners();
	}

	public function update() : void {
		if(!contains(_des))addChild(_des);		if(!contains(_mBtn))addChild(_mBtn);
		graphics.clear();
		graphics.lineStyle(2, 0xff0000, 1);
		graphics.beginFill(0xff0000, .2);
		var rect : Rectangle = target.getBounds(stage);
		graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
		graphics.endFill();
		
		graphics.moveTo(rect.x, rect.y);
		graphics.lineTo(rect.x + rect.width, rect.y + rect.height);
		graphics.moveTo(rect.x + rect.width, rect.y);
		graphics.lineTo(rect.x, rect.y + rect.height);
		
		_des.htmlText = '&nbsp;[' + getClassName(target) + ']&nbsp;&nbsp;' + target.name + '<br> [ x: ' + target.x + ', y: ' + target.y + ', w: ' + int(target.width) + ', h: ' + int(target.height) + ' ]';
		_des.x = rect.x;
		_des.y = rect.y - _des.height;
		_mBtn.x = rect.x;
		_mBtn.y = rect.y;
	}

	private function getClassName(value : *) : String {
		var str : String = getQualifiedClassName(value);
		return str.slice(str.lastIndexOf('::') ? str.lastIndexOf('::') + 2 : 0);
	}

	private function onDoubleClick(evt : MouseEvent = null) : void {
		if(_mBtn.hitTestPoint(mouseX, mouseY)) {
			dispatchEvent(new Event(InspectView.RESET_MOVE, false, true));
		}
	}

	private function onMouseDown(evt : MouseEvent) : void {
		if(_mBtn.hitTestPoint(mouseX, mouseY)) {
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			dispatchEvent(new Event(InspectView.START_MOVE, false, true));
		}
	}

	private function onMouseUp(evt : MouseEvent = null) : void {
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		
		dispatchEvent(new Event(InspectView.END_MOVE, false, true));
	}

	private function onMouseMove(evt : MouseEvent = null) : void {
		dispatchEvent(new Event(InspectView.MOVE, false, true));
	}

	public function dispose() : void {
		graphics.clear();
		if(_des)if(_des.parent)_des.parent.removeChild(_des);
		
		target = null;
		
		removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.removeEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
	}
}

class InspectorViewOperationBar extends Sprite {
	private var _btns : Array;

	public function InspectoViewOperationBar() : void {
	}

	public function init() : void {
		//背景
		graphics.clear();
		graphics.beginFill(0x393939);
		graphics.drawRoundRectComplex(0, 0, 200, 33, 8, 8, 0, 8);
		graphics.endFill();
	}

	/**
	 * 销毁对象
	 */
	public function dispose() : void {
	}
}
