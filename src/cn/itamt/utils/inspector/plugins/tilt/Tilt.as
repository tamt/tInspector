package cn.itamt.utils.inspector.plugins.tilt
{
	import cn.itamt.utils.inspector.core.BaseInspectorPlugin;
	import cn.itamt.utils.inspector.plugins.deval.DEvalButton;

	/**
	 * @author tamt
	 */
	public class Tilt extends BaseInspectorPlugin
	{
		public function Tilt()
		{
			_icon = new DEvalButton();
		}
		
		
		override public function onActive() : void
		{
			super.onActive();
		}
		
		override public function onUnActive() : void
		{
			super.onUnActive();
			
			
		}
		
		override public function getPluginId() : String
		{
			return "tilt";
		}

		override public function getPluginName(lang : String) : String
		{
			switch(lang)
			{
				case "cn":
					return "Tilt";
					break;
			}
			return "Tilt";
		}
	}
}
