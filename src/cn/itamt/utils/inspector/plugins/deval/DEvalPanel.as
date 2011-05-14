package cn.itamt.utils.inspector.plugins.deval
{
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.ui.InspectorLabelButton;
	import cn.itamt.utils.inspector.ui.InspectorTextField;
	import cn.itamt.utils.inspector.ui.InspectorViewPanel;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;

	/**
	 * Deval面板，包含一个输入的文本框，和“执行”按钮
	 * @author tamt
	 */
	public class DEvalPanel extends InspectorViewPanel
	{
		//用户输入代码的文本框
		protected var cmd:InspectorTextField;
		protected var btn:InspectorLabelButton;
		
		public function DEvalPanel(w : Number = 300, h : Number = 300, autoDisposeWhenRemove : Boolean = true, resizeable : Boolean = true, closeable : Boolean = true)
		{
			super(InspectorLanguageManager.getStr("DEval"), w, h, autoDisposeWhenRemove, resizeable, closeable);

			_title.mouseEnabled = _title.mouseWheelEnabled = _title.selectable = false;
			
			cmd = InspectorTextField.create("", 0xffffff, 12);
			cmd.type = TextFieldType.INPUT;
			cmd.multiline = true;
			cmd.border = true;
			cmd.borderColor = 0x666666;
			addChild(cmd);
			
			btn = new InspectorLabelButton(InspectorLanguageManager.getStr("runEval"));
			btn.tip = null;
			addChild(btn);
			
			btn.addEventListener(MouseEvent.CLICK, clickRunHandler);
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
			
			cmd.x = padding.left;
			cmd.y = padding.top;
			cmd.width = _width - padding.right - padding.left;
			cmd.height = _height - padding.top - padding.bottom - btn.height - 5;
			
			btn.x = _width - padding.right - btn.width;
			btn.y = _height - padding.bottom - btn.height;
		}

		override public function open() : void
		{
			super.open();
			this.btn.visible = true;
			this.cmd.visible = true;
		}
		
		
		override public function hide() : void
		{
			super.hide();
			this.btn.visible = false;
			this.cmd.visible = false;
		}
		
		/**
		 * 用户输入的代码
		 */
		public function get input():String{
			return cmd.text;
		}
		
		/**
		 * 用户输入的代码
		 */
		public function set input(text:String):void{
			cmd.text = text;	
		}

	}
}
