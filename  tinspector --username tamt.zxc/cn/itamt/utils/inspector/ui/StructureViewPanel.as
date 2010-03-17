package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.ClassTool;
	import cn.itamt.utils.inspector.events.InspectEvent;
	import cn.itamt.utils.inspector.output.DisplayObjectChildrenInfoOutputer;
	import cn.itamt.utils.inspector.output.DisplayObjectInfoOutPuter;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.StyleSheet;
	import flash.text.TextField;

	/**
	 * 用于装载显示列表结构树的面板
	 * @author itamt@qq.com
	 */
	public class StructureViewPanel extends InspectorViewPanel {
		public var statusOutputer : DisplayObjectInfoOutPuter;
		private var _statusInfo : TextField;

		//提交bug的按钮.
		private var bugBtn : InspectorViewBugButton;
		//刷新按钮
		private var refreshBtn : InspectorViewRefreshButton;

		public function StructureViewPanel(w : Number = 200, h : Number = 200) {
			super('Structure', w, h);
			
			_padding = new Padding(33, 10, 30, 10);
			
			_statusInfo = InspectorTextField.create('', 0xcccccc, 12);
			_statusInfo.selectable = false;
			_statusInfo.height = 20;
			
			var styleSheet : StyleSheet = new StyleSheet();
			styleSheet.setStyle('a:hover', {color:"#ff0000", textDecoration:"underline"});
			_title.styleSheet = styleSheet;
			addChild(_statusInfo);
			
			//提交bug的按钮.
			bugBtn = new InspectorViewBugButton();
			bugBtn.addEventListener(MouseEvent.CLICK, onClickBug);
			addChild(bugBtn);
			
			//刷新按钮
			refreshBtn = new InspectorViewRefreshButton();
			refreshBtn.addEventListener(MouseEvent.CLICK, onClickRefresh);
			addChild(refreshBtn);
		}

		override public function relayout() : void {
			super.relayout();
			
			this.bugBtn.x = _width - this._padding.right - this.bugBtn.width;/*this.viewPropBtn.x - this.bugBtn.width - 2*/
			this.bugBtn.y = _height - 5 - this.bugBtn.height;
			
			refreshBtn.x = this.resizeBtn.x - this.resizeBtn.width - 2;
			refreshBtn.y = 5;
			
			this.drawStatus();
		}

		private function drawStatus() : void {
			_statusInfo.width = _statusInfo.textWidth + 4;
			if(_statusInfo.width > _width - _padding.left - _padding.right)_statusInfo.width = _width - _padding.left - _padding.right;
			_statusInfo.x = _padding.left;
			_statusInfo.y = _height - _padding.bottom / 2 - _statusInfo.height / 2;
		}

		override protected function drawTitle() : void {
			_title.x = _padding.left;
			_title.y = 7;
			
			_title.width = _title.textWidth + 4;
			if(_title.width > refreshBtn.x - _padding.left - 3)_title.width = refreshBtn.x - _padding.left - 3;
		}

		override public function open() : void {
			super.open();
			
			_statusInfo.visible = true;
			bugBtn.visible = true;
		}

		override public function hide() : void {
			super.hide();

			_statusInfo.visible = false;
			bugBtn.visible = false;
		}

		private var _inspectObject : DisplayObject;

		public function get inspectObject() : DisplayObject {
			return _inspectObject;
		}

		public function onInspect(object : DisplayObject) : void {
			_inspectObject = object;
			
			_title.htmlText = getChainInfoStr(object);
			this.drawTitle();
			
			this.updateStatus();
		}

		public function onLiveInspect(object : DisplayObject) : void {
			_inspectObject = object;
			
			this.updateStatus();
		}

		private function updateStatus() : void {
			if(statusOutputer == null) {
				statusOutputer = new DisplayObjectChildrenInfoOutputer();
			}
			this._statusInfo.htmlText = statusOutputer.output(_inspectObject);
			this.drawStatus();
		}

		/**
		 * 返回一个显示对象的"层级链"信息文本
		 * 如:child>child.parent>child.parent.parent>...>Stage
		 */
		private function getChainInfoStr(child : DisplayObject, level : uint = 0) : String {
			var str : String = '<a href="event:' + level + '">' + ClassTool.getShortClassName(child) + '</a>';
			if(child.parent) {
				str += '<font color="#cccccc">-></font>' + getChainInfoStr(child.parent, ++level);
			}
			
			return str;
		}

		/**
		 * 提交bug按钮
		 */
		private function onClickBug(evt : MouseEvent = null) : void {
			if(this.stage) {
				var panel : BugReportPanel = new BugReportPanel();
				panel.x = this.stage.stageWidth / 2 - panel.width / 2;
				panel.y = this.stage.stageHeight / 2 - panel.height / 2;
				this.stage.addChild(panel);
			}
		}

		/**
		 * 单击刷新按钮时
		 */
		private function onClickRefresh(evt : MouseEvent = null) : void {
			evt.stopImmediatePropagation();
			dispatchEvent(new Event(InspectEvent.REFRESH));
		}
	}
}
