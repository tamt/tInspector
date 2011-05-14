package cn.itamt.utils.inspector.plugins.deval
{
	import r1.deval.D;
	import cn.itamt.utils.inspector.core.BaseInspectorPlugin;
	import cn.itamt.utils.inspector.popup.InspectorPopupManager;
	import cn.itamt.utils.inspector.popup.PopupAlignMode;

	import flash.events.Event;

	/**
	 * D.eval插件，在as3中实现eval方法。可以动态运行代码。
	 * @author tamt
	 * @see		http://www.riaone.com/products/deval/
	 */
	public class DEval extends BaseInspectorPlugin
	{
		/**
		 * 是否在插件使用时显示面板（用于输入代码）
		 */
		protected var _isShowPanel:Boolean = true;
		//主要面板
		protected var panel:DEvalPanel;
		
		public function DEval()
		{
			super();

			//设定插件图标按钮
			_icon = new DEvalButton();
		}
		
		/**
		 * 插件id，tInspector通过plugin id来管理各个插件。
		 */
		override public function getPluginId():String{
			return "DEval";
		}
		
		/**
		 * 插件被激活使用
		 */	
		override public function onActive() : void
		{
			super.onActive();	
			
			//根据默认值，显示面板			
			this.isShowPanel = _isShowPanel;
		}
		
		/**
		 * 插件被取消激活使用
		 */
		override public function onUnActive() : void
		{
			super.onUnActive();
			
			if(isShowPanel){
				InspectorPopupManager.remove(panel);
				panel = null;
			}
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
			if(_isShowPanel){
				if(panel == null){
					panel = new DEvalPanel();
					panel.addEventListener(Event.CLOSE, closePanelHandler);
					panel.addEventListener("click run", clickRunHandler);
				}
				InspectorPopupManager.popup(panel, PopupAlignMode.CENTER);
			}else{
				if(panel){
					if(panel.parent)panel.parent.removeChild(panel);
					panel = null;
				}
			}
		}
		
		/**
		 * 单击面的“运行”按钮时
		 */
		private function clickRunHandler(evt:Event) : void
		{
			D.eval(panel.input);	
		}

		/**
		 * 单击面板的关闭按钮时
		 */
		private function closePanelHandler(event : Event) : void
		{
			//取消激活使用该插件
			this._inspector.pluginManager.unactivePlugin(this.getPluginId());
		}
		
					
	}
}
