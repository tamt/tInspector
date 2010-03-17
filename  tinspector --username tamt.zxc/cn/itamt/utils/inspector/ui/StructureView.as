package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.Inspector;
	import cn.itamt.utils.inspector.data.DisplayItemData;
	import cn.itamt.utils.inspector.data.InspectTarget;
	import cn.itamt.utils.inspector.events.DisplayItemEvent;
	import cn.itamt.utils.inspector.events.InspectEvent;
	import cn.itamt.utils.inspector.output.DisplayObjectInfoOutPuter;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;	

	/**
	 * 显示对象结构树显示
	 * TODO:关于对treeView的操作似乎应该封装在panel(StructureViewPanel)中...
	 * @author itamt@qq.com
	 */
	public class StructureView extends BaseInspectorView {
		public static const ID : String = 'StructurePanel';

		private var treeView : DisplayObjectTree;
		private var panel : StructureViewPanel;

		//当前实时查看的对象.
		private var liveTarget : InspectTarget;

		public function StructureView() : void {
			super();
		}

		override public function contains(child : DisplayObject) : Boolean {
			if(panel) {
				return panel == child || panel.contains(child);
			} else {
				return false;
			}
		}

		override public function onTurnOn() : void {
			this.panel = new StructureViewPanel(200, 200);
			this.treeView = new DisplayObjectTree(this._inspector.stage, StructureElementView);
			this.treeView.addEventListener(DisplayItemEvent.OVER, onOverElement, false, 0, true);
			this.treeView.addEventListener(DisplayItemEvent.CLICK, onClickElement, false, 0, true);
			this.panel.addEventListener(MouseEvent.ROLL_OUT, onRollOutPanel, false, 0, true);
			this.panel.addEventListener(Event.CLOSE, onClickClose, false, 0, true);
			this.panel.addEventListener(TextEvent.LINK, onClickLinkTarget);
			this.panel.addEventListener(InspectEvent.REFRESH, onRefresh, false, 0, true);
			
			this.treeView.filterFun = _inspector.isInspectView;
			this.panel.setContent(treeView);
			this.panel.x = this.panel.y = 10;
			this._inspector.stage.addChild(this.panel);
		}

		override public function onTurnOff() : void {
			this.treeView.removeEventListener(DisplayItemEvent.OVER, onOverElement);
			this.treeView.removeEventListener(DisplayItemEvent.CLICK, onClickElement);
			this.panel.removeEventListener(MouseEvent.ROLL_OUT, onRollOutPanel);
			this.panel.removeEventListener(Event.CLOSE, onClickClose);
			this.panel.removeEventListener(TextEvent.LINK, onClickLinkTarget);
			this.panel.removeEventListener(InspectEvent.REFRESH, onRefresh);
			this._inspector.stage.removeChild(this.panel);
			
			this.panel = null;
			this.treeView = null;
		}

		/**
		 * 查看某个显示对象
		 */
		override public function onInspect($target : InspectTarget) : void {
			var item : DisplayItemData;

			if(this.liveTarget) {
				item = this.treeView.getDisplayItem(liveTarget.displayObject);
				item.onLiveInspect(false);
			}
			//			if($target == this.target)return;

			if(this.target) {
				item = this.treeView.getDisplayItem(target.displayObject);
				item.onInspect(false);
			}
			
			this.target = $target;
			
			item = this.treeView.getDisplayItem(target.displayObject);
			item.onInspect(true);
			this.treeView.onInspect(target.displayObject);
			this.panel.onInspect((target.displayObject));
			
			//面板滚动显示到当前目标对象的区域.
			var view : StructureElementView;
			view = this.treeView.getObjectRenderer(target.displayObject);
			if(view) {
				this.panel.showContentArea(view.getBounds(view.parent));
			}
			
			//实现置顶
			//			DisplayObjectTool.swapToTop(panel);
		}

		/**
		 * 当Inspector实时查看某个目标显示对象时
		 */
		override public function onLiveInspect($target : InspectTarget) : void {
			var item : DisplayItemData;
			if($target == this.liveTarget)return;
			
			if(this.liveTarget) {
				item = this.treeView.getDisplayItem(this.liveTarget.displayObject);
				item.onLiveInspect(false);
			}
			
			liveTarget = $target;
			
			item = this.treeView.getDisplayItem(this.liveTarget.displayObject);
			item.onLiveInspect(true);
			this.treeView.onInspect(liveTarget.displayObject);
			this.panel.onLiveInspect(liveTarget.displayObject);
			
			//面板滚动显示到当前目标对象的区域.
			var view : StructureElementView;
			view = this.treeView.getObjectRenderer(liveTarget.displayObject);
			if(view) {
				this.panel.showContentArea(view.getBounds(view.parent));
			}
			
			//实现置顶
//			DisplayObjectTool.swapToTop(panel);
		}

		/**
		 * 开时实时查看
		 */
		override public function onStartLiveInspect() : void {
			if(this.target) {
				var item : DisplayItemData = this.treeView.getDisplayItem(this.target.displayObject);
				item.onInspect(false);
			}
		}

		/**
		 * 经过一个树元素时.
		 */
		private function onOverElement(evt : DisplayItemEvent) : void {
			//			if(!_inspector.isLiveInspecting)return;
			if(evt.target is StructureElementView) {
				var ele : StructureElementView = evt.target as StructureElementView;
				evt.stopImmediatePropagation();
				
				this._inspector.liveInspect(ele.data.displayObject);
			}
		}

		/**
		 * 点击一个树元素时.
		 */
		private function onClickElement(evt : DisplayItemEvent) : void {
			//			if(!_inspector.isLiveInspecting)return;
			if(evt.target is StructureElementView) {
				var ele : StructureElementView = evt.target as StructureElementView;
				evt.stopImmediatePropagation();
				
				this._inspector.inspect(ele.data.displayObject);
			}
		}

		/**
		 * 鼠标离开面板时.
		 */
		private function onRollOutPanel(evt : MouseEvent) : void {
			if(!this._inspector.isLiveInspecting) {
				if(target) {
					if(!this.panel.hitTestPoint(evt.stageX, evt.stageY)) {
						this._inspector.inspect(target.displayObject);
					}
				}
			}
		}

		private function onClickLinkTarget(evt : TextEvent) : void {
			var level : uint = uint(evt.text);
			var object : DisplayObject = this.panel.inspectObject;
			while(level--) {
				object = object.parent;
			}
			
			this._inspector.inspect(object);
		}

		/**
		 * 当取消在Inspector的注册时.
		 */
		override public function onUnRegister(inspector : Inspector) : void {
			if(this.panel.stage)this.panel.parent.removeChild(this.panel);
			
			this.treeView.removeEventListener(DisplayItemEvent.OVER, onOverElement);
			this.treeView.removeEventListener(DisplayItemEvent.CLICK, onClickElement);
			this.panel.removeEventListener(MouseEvent.ROLL_OUT, onRollOutPanel);
			this.panel.removeEventListener(Event.CLOSE, onClickClose);
			this.panel.removeEventListener(TextEvent.LINK, onClickLinkTarget);
			
			this.panel = null;
			this.treeView = null;
		}

		override public function onUpdate(target : InspectTarget = null) : void {
			this.treeView.drawList();
		}

		/**
		 * 玩家单击关闭按钮时
		 */
		private function onClickClose(evt : Event) : void {
			this._inspector.unregisterViewById(StructureView.ID);
		}

		/**
		 * 刷新按钮
		 */
		private function onRefresh(evt : Event) : void {
			this.onInspect(this.target);
		}

		/**
		 * 自定义信息的输出
		 */
		override public function setInfoOutputer(outputer : DisplayObjectInfoOutPuter) : void {
			this.panel.statusOutputer = outputer;
		}

		/**
		 * 返回这个InspectorView的id, 在tInspector中, 通过id来管理各个InspectorView.
		 */
		override public function getInspectorViewClassID() : String {
			return StructureView.ID;
		}

		/**
		 * 销毁对象
		 */
		public function dispose() : void {
		}
	}
}
