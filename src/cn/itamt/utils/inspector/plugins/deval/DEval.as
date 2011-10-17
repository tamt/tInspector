package cn.itamt.utils.inspector.plugins.deval
{
	import cn.itamt.utils.inspector.core.BaseInspectorPlugin;
	import cn.itamt.utils.inspector.core.InspectTarget;
	import cn.itamt.utils.inspector.popup.InspectorPopupManager;
	import cn.itamt.utils.inspector.popup.PopupAlignMode;

	import r1.deval.D;

	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * D.eval插件，在as3中实现eval方法。可以动态运行代码。
	 * @author tamt
	 * @see		http://www.riaone.com/products/deval/
	 */
	public class DEval extends BaseInspectorPlugin
	{
		public function DEval()
		{
			super();

			// 设定插件图标按钮
			_icon = new DEvalButton();
		}

		// 自动链接this，把eval中的this链接到当前查看的对象，这样代码中的this会引用当前查看的对象
		protected var _autoThis : Boolean = true;
		/**
		 * 是否在插件使用时显示面板（用于输入代码）
		 */
		protected var _isShowPanel : Boolean = true;
		// 主要面板
		protected var panel : DEvalPanel;

		/**
		 * 自动链接this，把eval中的this链接到当前查看的对象，这样代码中的this会引用当前查看的对象
		 */
		public function get autoThis() : Boolean
		{
			return _autoThis;
		}

		/**
		 * 自动链接this，把eval中的this链接到当前查看的对象，这样代码中的this会引用当前查看的对象
		 */
		public function set autoThis(autoThis : Boolean) : void
		{
			_autoThis = autoThis;
			if (panel)
			{
				panel.autoLinkThis = _autoThis;
			}
		}

		override public function contains(child : DisplayObject) : Boolean
		{
			if (panel && this.isShowPanel)
			{
				return child == panel || panel.contains(child);
			}
			return super.contains(child);
		}

		/**
		 * 插件id，tInspector通过plugin id来管理各个插件。
		 */
		override public function getPluginId() : String
		{
			return "DEval";
		}

		/**
		 * 是否在插件使用时显示面板（用于输入代码）
		 */
		public function get isShowPanel() : Boolean
		{
			return _isShowPanel;
		}

		/**
		 * 是否在插件使用时显示面板（用于输入、运行代码）
		 */
		public function set isShowPanel(showPanel : Boolean) : void
		{
			_isShowPanel = showPanel;
			if (_isShowPanel)
			{
				if (panel == null)
				{
					panel = new DEvalPanel();
					panel.addEventListener(Event.CLOSE, closePanelHandler);
					panel.addEventListener("click_run", clickRunHandler);
					panel.autoLinkThis = autoThis;

					// 设置输出终端
					D.setTextControlOutput(panel.outputControl);
				}
				InspectorPopupManager.popup(panel, PopupAlignMode.CENTER);
			}
			else
			{
				if (panel)
				{
					if (panel.parent)
						panel.parent.removeChild(panel);
					panel.removeEventListener(Event.CLOSE, closePanelHandler);
					panel.removeEventListener("click_run", clickRunHandler);
					panel = null;
				}
			}
		}

		/**
		 * 插件被激活使用
		 */
		override public function onActive() : void
		{
			super.onActive();

			// 根据默认值，显示面板
			this.isShowPanel = _isShowPanel;
			if (panel)
				panel.input = 'printf(this);';
		}

		/**
		 * 当Inspector查看某个目标显示对象时.
		 */
		override public function onInspect(target : InspectTarget) : void
		{
			this.target = target;
		}

		/**
		 * 插件被取消激活使用
		 */
		override public function onUnActive() : void
		{
			super.onUnActive();

			if (isShowPanel)
			{
				InspectorPopupManager.remove(panel);
				panel = null;
			}
		}

		/**
		 * 单击面的“运行”按钮时
		 */
		private function clickRunHandler(evt : Event) : void
		{
			if (_autoThis)
			{
				var _this : DisplayObject = target ? target.displayObject : null;
				if (_this)
				{
					// D.eval内部直接访问对象的prototype属性，会导致运行出错。这个用于修正这个错误。
					_this["constructor"].prototype.prototype = null;
				}
				D.eval(panel.input, null, _this);
			}
			else
			{
				D.eval(panel.input, null, null);
			}
		}

		/**
		 * 单击面板的关闭按钮时
		 */
		private function closePanelHandler(event : Event) : void
		{
			// 取消激活使用该插件
			this._inspector.pluginManager.unactivePlugin(this.getPluginId());
		}
	}
}
