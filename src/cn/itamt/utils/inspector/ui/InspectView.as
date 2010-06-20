package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.Debug;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
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
		//矩形
		private var _mBtn : Sprite;
		private var _bar : OperationBar;

		//private var _layoutView : LayoutView;
		//private var _structView : StructureView;

		public function InspectView() : void {
			super();
			
			//			this.mouseChildren = this.mouseEnabled = false;

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
		
			_mBtn = new Sprite();
			_mBtn.buttonMode = true;
			addChild(_mBtn);
			
			//------操作条------
			_bar = new OperationBar();
			_bar.init();
			//------------------
			if(stage) {
				initEventListeners();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			}
		}

		private var inited : Boolean;

		private function initEventListeners() : void {
			if(inited)return;
			inited = true;
			//		stage.doubleClickEnabled = true;
			//		stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//		stage.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			_mBtn.addEventListener(MouseEvent.CLICK, onMouseDown);
			
			_bar.addEventListener(OperationBar.DOWN_MOVE, onDownMove);
			_bar.addEventListener(OperationBar.UP_MOVE, onMouseUp);			_bar.addEventListener(OperationBar.PRESS_CLOSE, onCloseBar);
			_bar.addEventListener(OperationBar.PRESS_PARENT, onPressParent);			_bar.addEventListener(OperationBar.PRESS_CHILD, onPressChild);			_bar.addEventListener(OperationBar.PRESS_BROTHER, onPressBrother);//			_bar.addEventListener(OperationBar.PRESS_INFO, onPressInfo);
		}

		private function onAddToStage(evt : Event = null) : void {
			initEventListeners();
		}

		private var rect : Rectangle;
		//目标的注册点
		private var reg : Point;
		//目标父容器的注册点
		private var upReg:Point;

		public function update(isLiveMode : Boolean = false) : void {
			if(!contains(_des))addChild(_des);
			if(!contains(_mBtn))addChild(_mBtn);
			
			rect = target.getBounds(stage);
			reg = target.localToGlobal(new Point(0, 0));
			if(target.parent){
				upReg = target.parent.localToGlobal(new Point(0,0));
			}else{
				upReg = null;
			}
			
			_des.text = '[' + getClassName(target) + ']' + '[x: ' + target.x + ', y: ' + target.y + '][w: ' + int(target.width) + ', h: ' + int(target.height) + ']';
			_des.x = rect.x - .5;
			_des.y = rect.y - _des.height + .5;
				
			if(isLiveMode) {
				this.drawMbtn();
			} else {
				this.drawMbtn(0, 0x636C02);
			}
			
			//			_mBtn.x = rect.x;
			//			_mBtn.y = rect.y;

			_bar.x = rect.x - .5;
			_bar.y = _des.y - _bar.barHeight;
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

		private function onMouseDown(evt : MouseEvent) : void {
//			if(this._mBtn.hitTestPoint(this.mouseX, this.mouseY)) {
				dispatchEvent(new Event(InspectView.INSPECT, false, true));
				this._mBtn.buttonMode = this._mBtn.mouseEnabled = false;
//			}
		}

		private function onDownMove(evt : Event) : void {
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

		private function drawMbtn(alpha : Number = .3, bColor : uint = 0xff0000) : void {
			_mBtn.graphics.clear();
			_mBtn.graphics.lineStyle(2, bColor, 1, false, 'normal', 'square', 'miter');
			_mBtn.graphics.beginFill(0xff0000, alpha);
			_mBtn.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			
			//注册点十字形绘制.
			_mBtn.graphics.lineStyle(1, bColor, 1, false, 'normal', 'square', 'miter');
			_mBtn.graphics.drawCircle(reg.x, reg.y, 5);
			_mBtn.graphics.lineStyle(2, bColor, 1, false, 'normal', 'square', 'miter');
			_mBtn.graphics.moveTo(reg.x - 3, reg.y);
			_mBtn.graphics.lineTo(reg.x + 3, reg.y);
			_mBtn.graphics.moveTo(reg.x, reg.y - 3);
			_mBtn.graphics.lineTo(reg.x, reg.y + 3);
			
			_mBtn.graphics.endFill();
			
			//父容器注册点十字形
			if(upReg){
				_mBtn.graphics.lineStyle(2, 0x0000ff, 1, false, 'normal', 'square', 'miter');
				_mBtn.graphics.moveTo(upReg.x - 4, upReg.y);
				_mBtn.graphics.lineTo(upReg.x + 4, upReg.y);
				_mBtn.graphics.moveTo(upReg.x, upReg.y - 4);
				_mBtn.graphics.lineTo(upReg.x, upReg.y + 4);
			}
		}

		/*
		private function onPressInfo(evt : Event) : void {
		if(_layoutView == null) {
		_layoutView = new LayoutView();
		_layoutView.addEventListener(LayoutView.INSPECT, onInpectFromLayout);		_layoutView.addEventListener(LayoutView.LIVE_INSPECT, onLiveInpectFromLayout);
		_layoutView.x = stage.stageWidth - _layoutView.width;
		_layoutView.y = (stage.stageHeight - _layoutView.height) / 2;
		stage.addChild(_layoutView);
		_layoutView.inspect(target);
		}else {
		if(_layoutView.target == target) {
		stage.removeChild(_layoutView);
		_layoutView.dispose();
		_layoutView = null;
		_layoutView.removeEventListener(LayoutView.INSPECT, onInpectFromLayout);		_layoutView.removeEventListener(LayoutView.LIVE_INSPECT, onLiveInpectFromLayout);
		}else {
		_layoutView.inspect(target);
		}
		}
			
		if(_structView == null) {
		_structView = new StructureView();
		stage.addChild(_structView);
		_structView.inspect(target);
		_structView.x = (stage.stageWidth - _structView.width) / 2;
		_structView.y = stage.stageHeight - _structView.height;
		_structView.addEventListener(InspectEvent.LIVE_INSPECT, onStructViewLiveInspect);
		}else {
		if(_structView.target == target) {
		stage.removeChild(_structView);
		_structView.dispose();
		_structView = null;
		}else {
		_structView.inspect(target);
		}
		}
		}
		
		private function onStructViewLiveInspect(evt:InspectEvent):void{
		trace("[InspectView][onStructViewLiveInspect]");
		this.target = evt.inspectTarget;
		dispatchEvent(new Event(InspectView.LIVE_INSPECT));
		}

		private function onInpectFromLayout(evt : Event) : void {
		this.target = _layoutView.target; 
		dispatchEvent(new Event(InspectView.INSPECT));
		}

		private function onLiveInpectFromLayout(evt : Event) : void {
		this.target = _layoutView.target;
		dispatchEvent(new Event(InspectView.LIVE_INSPECT));
		}

		 * 
		 */
		public function dispose() : void {
			Debug.printf('inspectview dispose');
			graphics.clear();
			if(_des)if(_des.parent)_des.parent.removeChild(_des);
		
			target = null;
		
			removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			
			_mBtn.removeEventListener(MouseEvent.CLICK, onMouseDown);
			
			_bar.removeEventListener(OperationBar.DOWN_MOVE, onDownMove);
			_bar.removeEventListener(OperationBar.UP_MOVE, onMouseUp);
			_bar.removeEventListener(OperationBar.PRESS_CLOSE, onCloseBar);
			_bar.removeEventListener(OperationBar.PRESS_PARENT, onPressParent);
			_bar.removeEventListener(OperationBar.PRESS_CHILD, onPressChild);
			_bar.removeEventListener(OperationBar.PRESS_BROTHER, onPressBrother);
			//
//			if(_layoutView) {
//				stage.removeChild(_layoutView);
//				_layoutView.dispose();
//				_layoutView = null;
//			}
//			if(_structView) {
//				stage.removeChild(_structView);
//				_structView.dispose();
//				_structView = null;	
//			}
		}

		/**
		 * 详细查看
		 */
		public function inspect(ele : DisplayObject) : void {
			Debug.printf('[InspectView]inspect');
			target = ele;
			update();
			
			if(_bar.stage == null)addChild(_bar);
			_bar.validate(target);
		}

		/**
		 * 实时查看
		 */
		public function liveInspect(ele : DisplayObject) : void {
			Debug.printf('[InspectView]liveInspect');
			target = ele;
			update(true);
			
			if(_bar.stage)removeChild(_bar);
			_bar.validate(target);
		}
	}
}
