package cn.itamt.utils.inspector.plugins.deval
{
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.ui.InspectorLabelButton;
	import cn.itamt.utils.inspector.ui.InspectorTextField;
	import cn.itamt.utils.inspector.ui.InspectorViewPanel;
	import cn.itamt.utils.inspector.ui.ToggleBooleanButton;

	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	/**
	 * Deval面板，包含一个输入的文本框，和“执行”按钮
	 * @author tamt
	 */
	public class DEvalPanel extends InspectorViewPanel
	{
		//用户输入代码的文本框
		protected var _input:InspectorTextField;
		protected var _output:InspectorTextField;
		protected var btn:InspectorLabelButton;
		protected var _autoLinkThis:ToggleBooleanButton;
		protected var _autoLinkThisTip:InspectorTextField;
		
		public function DEvalPanel(w : Number = 300, h : Number = 300, autoDisposeWhenRemove : Boolean = true, resizeable : Boolean = true, closeable : Boolean = true)
		{
			super(InspectorLanguageManager.getStr("DEval"), w, h, autoDisposeWhenRemove, resizeable, closeable);

			_title.mouseEnabled = _title.mouseWheelEnabled = _title.selectable = false;
			
			_input = InspectorTextField.create("", 0xffffff, 12);
			_input.type = TextFieldType.INPUT;
			_input.multiline = true;
			_input.border = true;
			_input.borderColor = 0x666666;
			addChild(_input);
			
			_output = InspectorTextField.create("type code in the TextField below. and then click 'run'", 0xffffff, 12);
			_output.multiline = true;
			_output.border = true;
			_output.wordWrap = true;
			_output.borderColor = 0x999999;
			var cm:ContextMenu = new ContextMenu();
			var clearItem:ContextMenuItem = new ContextMenuItem(InspectorLanguageManager.getStr("Clear"));
			cm.customItems.push(clearItem);
			clearItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuItemSelect);
			_output.contextMenu = cm;
			addChild(_output);
			
			//运行
			btn = new InspectorLabelButton(InspectorLanguageManager.getStr("runEval"));
			btn.tip = null;
			addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, clickRunHandler);
			
			//把thisObj链接到当前查看的对象，这样代码中的this会引用当前查看的对象
			_autoLinkThis = new ToggleBooleanButton(true);
			_autoLinkThis.tip = InspectorLanguageManager.getStr("autoLinkThisTip");
			addChild(_autoLinkThis);
			_autoLinkThisTip = InspectorTextField.create(InspectorLanguageManager.getStr("autoLinkThis"), 0xcccccc, 12);
			addChild(_autoLinkThisTip);
		}
		
		/**
		 * 点击了右键菜单项
		 */
		private function onMenuItemSelect(event : ContextMenuEvent) : void
		{
			var menuItem:ContextMenuItem = event.target as ContextMenuItem;
			if(menuItem.caption == InspectorLanguageManager.getStr("Clear")){
				_output.text = "";				
			}
		}
		
		
		/**
		 * 单击运行时
		 */
		private function clickRunHandler(event : MouseEvent) : void
		{
			dispatchEvent(new Event("click_run"));
		}
		
		/**
		 * 实现布局
		 */
		override public function relayout() : void
		{
			super.relayout();
			
			_output.x = padding.left;
			_output.y = padding.top;
			_output.width = _width - padding.right - padding.left;
			_output.height = _height - padding.top - padding.bottom - 70 - btn.height - 5;
			
			_input.x = padding.left;
			_input.y = _output.y + _output.height + 5;
			_input.width = _width - padding.right - padding.left;
			_input.height = 65;
			
			btn.x = _width - padding.right - btn.width;
			btn.y = _height - padding.bottom - btn.height;
			
			_autoLinkThis.x = padding.left;
			_autoLinkThis.y = _height - _autoLinkThis.height - padding.bottom;
			_autoLinkThisTip.x = padding.left + _autoLinkThis.width;
			_autoLinkThisTip.y = _height - _autoLinkThis.height - padding.bottom;
		}
		
		/**
		 * 展开面板时
		 */
		override public function open() : void
		{
			super.open();
			this.btn.visible = this._input.visible = this._output.visible = this._autoLinkThis.visible = this._autoLinkThisTip.visible =true;
		}
		
		/**
		 * 最小化面板时
		 */
		override public function hide() : void
		{
			super.hide();
			this.btn.visible = this._input.visible = this._output.visible = this._autoLinkThis.visible = this._autoLinkThisTip.visible =false;
		}
		
		/**
		 * 用户输入的代码
		 */
		public function get input():String{
			return _input.text;
		}
		
		/**
		 * 用户输入的代码
		 */
		public function set input(text:String):void{
			_input.text = text;
		}
		
		/**
		 * 用于输出代码运行结果的文本框
		 */
		public function get outputControl() : InspectorTextField
		{
			return _output;
		}
		
		/**
		 * 是否自动链接this引用
		 */
		public function get autoLinkThis() : Boolean
		{
			return _autoLinkThis.value;
		}
		
		/**
		 * 是否自动链接this引用
		 */
		public function set autoLinkThis(value:Boolean) : void
		{
			_autoLinkThis.value = value;
		}

	}
}
