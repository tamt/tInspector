package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.Inspector;
	import cn.itamt.utils.inspector.data.InspectTarget;
	import cn.itamt.utils.inspector.output.InspectorOutPuterManager;

	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * tInspector的属性视图
	 * @author itamt@qq.com
	 */
	public class PropertiesView extends BaseInspectorView {
		public static const ID : String = 'PropertyPanel';

		private var panels : Array;

		public function PropertiesView() {
			super();
		}

		override public function set outputerManager(value : InspectorOutPuterManager) : void {
			trace('[PropertiesView][outputerManager]PropertiesView没有设计信息输出的接口，忽略该属性设置。');
		}

		override public function contains(child : DisplayObject) : Boolean {
			if(panels) {
				var l : int = panels.length;
				for(var i : int = 0;i < l;i++) {
					if(panels[i] == child || panels[i].contains(child)) {
						return true;
					}
				}
			}
			
			return false;
		}

		override public function onTurnOn() : void {
			super.onTurnOn();
			
			if(this.panels == null)this.panels = [];
			
			var panel : PropertiesViewPanel = new PropertiesViewPanel();
			panel.x = panel.y = 10;
			this.panels.push(panel);
			
			this._inspector.stage.addChild(panel);
			panel.addEventListener(Event.CLOSE, onClickClose, false, 0, true);
		}

		override public function onTurnOff() : void {
			super.onTurnOff();
			
			if(panels) {
				for each(var panel:PropertiesViewPanel in panels) {
					this._inspector.stage.removeChild(panel);
				}
			}
			
			this.panels = null;
		}

		/**
		 * 查看对象时
		 */		
		override public function onInspect(target : InspectTarget) : void {
			super.onInspect(target);
			
			for each(var panel:PropertiesViewPanel in this.panels) {
				if(panel.getSingleMode()) {
					panel.onInspect(target.displayObject);
					return;
					break;
				}
			}
			
			panel = new PropertiesViewPanel();
			this.panels.push(panel);
			
			this._inspector.stage.addChild(panel);
			panel.addEventListener(Event.CLOSE, onClickClose, false, 0, true);
			panel.onInspect(target.displayObject);
		}

		/**
		 * 实时查看对象时
		 */		
		override public function onLiveInspect(target : InspectTarget) : void {
			//实现置顶
			//DisplayObjectTool.swapToTop(this.panel);
		}

		/**
		 * 对象有更新时
		 */
		override public function onUpdate(target : InspectTarget = null) : void {
			for each(var panel:PropertiesViewPanel in this.panels) {
				if(panel.getSingleMode() || panel.getCurTarget() == target.displayObject) {
					panel.onInspect(target.displayObject);
				}
			}
		}

		/**
		 * 当取消在Inspector的注册时.
		 */
		override public function onUnRegister(inspector : Inspector) : void {
			if(panels) {
				for each(var panel:PropertiesViewPanel in panels) {
					this._inspector.stage.removeChild(panel);
				}
			}
			
			this.panels = null;
		}

		/**
		 * 返回这个InspectorView的id, 在tInspector中, 通过id来管理各个InspectorView.
		 */
		override public function getInspectorViewClassID() : String {
			return PropertiesView.ID;
		}

		/**
		 * 玩家单击关闭按钮时
		 */
		private function onClickClose(evt : Event) : void {
			var panel : PropertiesViewPanel = evt.target as PropertiesViewPanel;
			var t : int = this.panels.indexOf(panel);
			if(t > -1) {
				this.panels.splice(t, 1);
				this._inspector.stage.removeChild(panel);
			}
			
			if(this.panels.length == 0) {
				this._inspector.unregisterViewById(PropertiesView.ID);
			}
		}
	}
}
