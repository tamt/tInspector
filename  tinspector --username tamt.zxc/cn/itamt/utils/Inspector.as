package cn.itamt.utils {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import cn.itamt.utils.inspectorui.InspectView;	

	/**
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
		private var stage : DisplayObjectContainer;
		private var root : DisplayObjectContainer;
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
		public function init(root : DisplayObjectContainer, withMenu : Boolean = false) : void {
			
			this.root = root;
			this.stage = root.stage;
			
			if(stage == null) {
				throw new Error("Set inspector's stage before you call inspector.init(); ");
				return;
			}
			inspectView = new InspectView();
			if(withMenu)createContextMenu();
		}

		private function createContextMenu() : void {
			ctmenu = new NpContextMenu(root);
			ctmenu.addMenuItem('Inspector On', true);
			ctmenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleMenuSelection);
		}

		private function handleMenuSelection(evt : ContextMenuEvent) : void {
			switch(ctmenu.selectedMenu) {
				case 'Inspector On':
					ctmenu.removeMenuItem('Inspector On');
					ctmenu.addMenuItem('Inspector Off', true);

					startInspect();
					break;
				case 'Inspector Off':
					ctmenu.removeMenuItem('Inspector Off');
					ctmenu.addMenuItem('Inspector On', true);

					stopInspect();
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

		public function startInspect() : void {
			if(isOn)return;
			isOn = true;
			curInspectEle = null;
			
			startLiveInspect();			
		}

		private function startLiveInspect() : void {
			
			if(inspectView == null)inspectView = new InspectView();
			inspectView.mouseChildren = false;
			inspectView.addEventListener(MouseEvent.CLICK, onClickInspectView);
			
			this.stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		private function onClickInspectView(evt : MouseEvent) : void {
			stopLiveInspect();
		}

		private function stopLiveInspect() : void {
			inspectView.mouseChildren = true;
			inspectView.removeEventListener(MouseEvent.CLICK, onClickInspectView);
			this.stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		/**
		 * 关闭查看
		 */
		public function stopInspect() : void {
			if(!isOn)return;
			isOn = false;
			curInspectEle = null;
			this.stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			inspectView.removeEventListener(MouseEvent.CLICK, onClickInspectView);
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

		private var curInspectEle : DisplayObject;

		private function inspect(ele : DisplayObject) : void {
			if(curInspectEle == ele)return;
			curInspectEle = ele;
			showCurInspectView(ele);
		}

		private function showCurInspectView(ele : DisplayObject) : void {

			stage.addChildAt(inspectView, stage.numChildren);
			
			inspectView.addEventListener(InspectView.START_MOVE, onInspectViewStartMove);
			inspectView.addEventListener(InspectView.MOVE, onInspectViewMove);
			inspectView.addEventListener(InspectView.END_MOVE, onInspectViewEndMove);
			inspectView.addEventListener(InspectView.RESET_MOVE, onInspectViewResetMove);
			inspectView.addEventListener(InspectView.CLOSE, onInspectViewClose);
			inspectView.addEventListener(InspectView.INSPECT_PARENT, onInspectParent);			inspectView.addEventListener(InspectView.INSPECT_CHILD, onInspectChild);			inspectView.addEventListener(InspectView.INSPECT_BROTHER, onInspectBrother);			inspectView.addEventListener(InspectView.INSPECT, onInspect);			inspectView.addEventListener(InspectView.LIVE_INSPECT, onLiveInspect);
			
			inspectView.inspect(ele);
		}

		private function closeCurInspectView() : void {
			
			inspectView.removeEventListener(InspectView.START_MOVE, onInspectViewStartMove);
			inspectView.removeEventListener(InspectView.MOVE, onInspectViewMove);
			inspectView.removeEventListener(InspectView.END_MOVE, onInspectViewEndMove);
			inspectView.removeEventListener(InspectView.RESET_MOVE, onInspectViewResetMove);
			inspectView.removeEventListener(InspectView.CLOSE, onInspectViewClose);
			inspectView.removeEventListener(InspectView.INSPECT_PARENT, onInspectParent);			inspectView.removeEventListener(InspectView.INSPECT_CHILD, onInspectChild);			inspectView.removeEventListener(InspectView.INSPECT_BROTHER, onInspectBrother);
			inspectView.removeEventListener(InspectView.INSPECT, onInspect);			inspectView.removeEventListener(InspectView.LIVE_INSPECT, onLiveInspect);
			
			inspectView.dispose();
			
			stage.removeChild(inspectView);
		}

		private function onInspectParent(evt : Event) : void {
			if(curInspectEle) {
				if(curInspectEle.parent) {
					inspect(curInspectEle.parent);
				}
			}
		}

		private function onInspectChild(evt : Event) : void {
			if(curInspectEle) {
				if(curInspectEle is DisplayObjectContainer) {
					inspect((curInspectEle as DisplayObjectContainer).getChildAt(0));
				}
			}
		}

		private function onInspectBrother(evt : Event) : void {
			if(curInspectEle) {
				if(curInspectEle.parent) {
					var container : DisplayObjectContainer = curInspectEle.parent;
					var i : int = container.getChildIndex(curInspectEle);
					var t : int = (++i) % (container.numChildren);
					inspect(container.getChildAt(t));
				}
			}
		}

		var regPoint : Point; 
		var	regTargetPoint : Point;

		private function onInspectViewMove(evt : Event = null) : void {
			inspectView.target.x = regTargetPoint.x - (regPoint.x - inspectView.mouseX);			inspectView.target.y = regTargetPoint.y - (regPoint.y - inspectView.mouseY);
			inspectView.update();
		}

		private function onInspectViewStartMove(evt : Event = null) : void {
			
			regPoint = new Point(inspectView.mouseX, inspectView.mouseY);
			regTargetPoint = new Point(inspectView.target.x, inspectView.target.y);
		}

		private function onInspectViewEndMove(evt : Event = null) : void {
		}

		private function onInspectViewResetMove(evt : Event = null) : void {
			inspectView.target.x = regTargetPoint.x;
			inspectView.target.y = regTargetPoint.y;
			
			inspectView.update();
		}

		private function onInspectViewClose(evt : Event) : void {
			curInspectEle = null;
			closeCurInspectView();
			startLiveInspect();
		}

		private function onInspect(evt : Event) : void {
			trace("[Inspector][onInspect]");
			stopLiveInspect();
			inspect(inspectView.target);
		}

		private function onLiveInspect(evt : Event) : void {
			inspect(inspectView.target);
		}
	}
}

class SingletonEnforcer {
}

class InspectMode {
	public static const ONLY_INTERACTIVE_OBJECT : String = 'only_interactive_obj';
	public static const ALL_DISPLAY_OBJECT : String = 'all_display_obj';
}


