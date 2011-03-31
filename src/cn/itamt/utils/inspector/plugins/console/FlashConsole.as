package cn.itamt.utils.inspector.plugins.console {
	import flash.events.Event;
	import cn.itamt.utils.inspector.core.BaseInspectorPlugin;
	import cn.itamt.utils.inspector.ui.InspectorIconButton;
	import cn.itamt.utils.inspector.ui.InspectorSymbolIcon;

	import com.junkbyte.console.Cc;

	import flash.display.DisplayObject;

    /**
     * Flash控制台插件
     */
    public class FlashConsole extends BaseInspectorPlugin{

        public function FlashConsole():void{
			var iconBtn:InspectorIconButton = new InspectorIconButton(InspectorSymbolIcon.CONSOLE);
			iconBtn.setSize(23, 23);
			this._icon = iconBtn;
        }
        
		override public function contains(child : DisplayObject) : Boolean {
			if(super.contains(child))return true;
			if(Cc.instance){
				return Cc.instance == child || Cc.instance.contains(child);
			}else{
				return false;
			}
		}
        
        override public function onActive():void{
        	super.onActive();
        	
        	Cc.config.alwaysOnTop = false;
        	Cc.config.commandLineAllowed = true;
        	Cc.config.useObjectLinking = true;
        	Cc.startOnStage(_inspector.stage);
        	
        	Cc.commandLine = true;
        	Cc.displayRoller = false;
        	Cc.fpsMonitor = false;
        	Cc.memoryMonitor = false;
        	
        	Cc.instance.addEventListener(Event.REMOVED, removeFromStageHandler);
		}

		private function removeFromStageHandler(event : Event) : void {
			if(event.target == Cc.instance){
				_inspector.pluginManager.unactivePlugin(this.getPluginId());
			}
		}
        
        override public function onUnActive():void{
        	Cc.remove();
        	
        	super.onUnActive();
        }
        
        override public function getPluginId():String{
        	return "flash_console";
        }
        
        override public function getPluginName(lang:String):String{
        	switch(lang){
        		case "cn":
        			return "控制台";
        			break;
        	}
        	return "Flash Console"; 
        }
    }
}
