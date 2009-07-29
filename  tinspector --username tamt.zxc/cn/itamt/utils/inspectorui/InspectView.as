package cn.itamt.utils.inspectorui {
	import flash.text.TextFormat;	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getQualifiedClassName;	

	/**
	 * @author tamt
	 */
	public class InspectView extends Sprite {
		public static const MOVE : String = 'move';
		public static const START_MOVE : String = 'start_move';
		public static const END_MOVE : String = 'end_move';
		public static const RESET_MOVE : String = 'reset_move';
		public static const CLOSE : String = 'close';
		public static const INSPECT_PARENT : String = 'inspect_parent';
		public static const INSPECT_CHILD : String = 'inspect_child';
		public static const INSPECT_BROTHER : String = 'inspect_brother';
		public static const INSPECT_INFO : String = 'inspect_info';
		public static const INSPECT : String = 'inpsect';
		public static const LIVE_INSPECT : String = 'live_inpect';
		public var target : DisplayObject;
		private var _des : TextField;
		private var _mBtn : Shape;
		private var _bar : InspectorViewOperationBar;
		private var _layoutView : InspectLayoutView;
		private var _structView : InspectStructureView;

		public function InspectView() : void {
			super();
		
			_des = new TextField();
			_des.autoSize = TextFieldAutoSize.LEFT;
			_des.textColor = 0xffffff;
			_des.background = true;
			_des.backgroundColor = 0x636C02;
			_des.border = true;
			_des.borderColor = 0x636C02;
			_des.cacheAsBitmap = true;
			var tfmt : TextFormat = new TextFormat(null, null, 0xffffff);
			_des.defaultTextFormat = tfmt;
			addChild(_des);
		
			_mBtn = new Shape();
			addChild(_mBtn);
			
			//------操作条------
			_bar = new InspectorViewOperationBar();
			_bar.init();
			addChild(_bar);
			//------------------
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
			_bar.addEventListener(InspectorViewOperationBar.DOWN_MOVE, onDownMove);			_bar.addEventListener(InspectorViewOperationBar.PRESS_CLOSE, onCloseBar);
			_bar.addEventListener(InspectorViewOperationBar.PRESS_PARENT, onPressParent);			_bar.addEventListener(InspectorViewOperationBar.PRESS_CHILD, onPressChild);			_bar.addEventListener(InspectorViewOperationBar.PRESS_BROTHER, onPressBrother);			_bar.addEventListener(InspectorViewOperationBar.PRESS_INFO, onPressInfo);
			addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(evt : MouseEvent = null) : void {
		}

		private function onAddToStage(evt : Event = null) : void {
			initEventListeners();
		}

		public function update() : void {
			if(!contains(_des))addChild(_des);
			if(!contains(_mBtn))addChild(_mBtn);
			graphics.clear();
			graphics.lineStyle(1, 0x636C02, 1, false, 'normal', 'square', 'miter');
			graphics.beginFill(0xff0000, 0);
			var rect : Rectangle = target.getBounds(stage);
			graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			graphics.endFill();
		
			//			graphics.moveTo(rect.x, rect.y);
			//			graphics.lineTo(rect.x + rect.width, rect.y + rect.height);
			//			graphics.moveTo(rect.x + rect.width, rect.y);
			//			graphics.lineTo(rect.x, rect.y + rect.height);
			_des.text = '[' + getClassName(target) + ']' + '[x: ' + target.x + ', y: ' + target.y + '][w: ' + int(target.width) + ', h: ' + int(target.height) + ']';
			_des.x = rect.x - .5;
			_des.y = rect.y - _des.height + .5;
			_mBtn.x = rect.x;
			_mBtn.y = rect.y;
			
			_bar.x = rect.x - .5;
			_bar.y = _des.y - _bar.height;
		}

		private function getClassName(value : *) : String {
			var str : String = getQualifiedClassName(value);
			return str.slice((str.lastIndexOf('::') >= 0) ? str.lastIndexOf('::') + 2 : 0);
		}

		private function onDoubleClick(evt : MouseEvent = null) : void {
			if(_mBtn.hitTestPoint(mouseX, mouseY)) {
				dispatchEvent(new Event(InspectView.RESET_MOVE, false, true));
			}
		}

		private function onDownMove(evt : Event) : void {
			_bar.addEventListener(InspectorViewOperationBar.UP_MOVE, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			dispatchEvent(new Event(InspectView.START_MOVE, false, true));
		}

		private function onMouseUp(evt : Event = null) : void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		
			dispatchEvent(new Event(InspectView.END_MOVE, false, true));
		}

		private function onMouseMove(evt : MouseEvent = null) : void {
			dispatchEvent(new Event(InspectView.MOVE, false, true));
		}

		private function onCloseBar(evt : Event = null) : void {
			dispatchEvent(new Event(InspectView.CLOSE, false, true));
		}

		private function onPressParent(evt : Event) : void {
			dispatchEvent(new Event(InspectView.INSPECT_PARENT, false, true));
		}

		private function onPressChild(evt : Event) : void {
			dispatchEvent(new Event(InspectView.INSPECT_CHILD, false, true));
		}

		private function onPressBrother(evt : Event) : void {
			dispatchEvent(new Event(InspectView.INSPECT_BROTHER, false, true));
		}

		private function onPressInfo(evt : Event) : void {
			if(_layoutView == null) {
				_layoutView = new InspectLayoutView();
				_layoutView.addEventListener(InspectLayoutView.INSPECT, onInpectFromLayout);				_layoutView.addEventListener(InspectLayoutView.LIVE_INSPECT, onLiveInpectFromLayout);
				_layoutView.x = stage.stageWidth - _layoutView.width;
				_layoutView.y = (stage.stageHeight - _layoutView.height) / 2;
				stage.addChild(_layoutView);
				_layoutView.inspect(target);
			}else {
				if(_layoutView.target == target) {
					stage.removeChild(_layoutView);
					_layoutView.dispose();
					_layoutView = null;
					_layoutView.removeEventListener(InspectLayoutView.INSPECT, onInpectFromLayout);					_layoutView.removeEventListener(InspectLayoutView.LIVE_INSPECT, onLiveInpectFromLayout);
				}else {
					_layoutView.inspect(target);
				}
			}
			
			if(_structView == null) {
				_structView = new InspectStructureView();
				stage.addChild(_structView);
				_structView.inspect(target);
				_structView.x = (stage.stageWidth - _structView.width) / 2;
				_structView.y = stage.stageHeight - _structView.height;
			}else {
				if(_structView.target == target){
					stage.removeChild(_structView);
					_structView.dispose();
					_structView = null;
				}else {
					_structView.inspect(target);
				}
			}
		}

		private function onInpectFromLayout(evt : Event) : void {
			this.target = _layoutView.target; 
			dispatchEvent(new Event(InspectView.INSPECT));
		}

		private function onLiveInpectFromLayout(evt : Event) : void {
			this.target = _layoutView.target;
			dispatchEvent(new Event(InspectView.LIVE_INSPECT));
		}

		public function dispose() : void {
			graphics.clear();
			if(_des)if(_des.parent)_des.parent.removeChild(_des);
		
			target = null;
		
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			
			//
			if(_layoutView) {
				stage.removeChild(_layoutView);
				_layoutView.dispose();
				_layoutView = null;
			}
		}

		public function inspect(ele : DisplayObject) : void {
			target = ele;
			update();
			
			_bar.validate(target);
		}
	}
}
