package cn.itamt.utils.inspector.plugins.console {
	import cn.itamt.utils.inspector.core.BaseInspectorPlugin;
	import cn.itamt.utils.inspector.core.IInspector;
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.popup.InspectorPopupManager;
	import cn.itamt.utils.inspector.popup.PopupAlignMode;
	import cn.itamt.utils.inspector.ui.InspectorIconButton;
	import cn.itamt.utils.inspector.ui.InspectorStageReference;
	import cn.itamt.utils.inspector.ui.InspectorSymbolIcon;

	import com.junkbyte.console.Cc;

	import flash.display.DisplayObject;
	import flash.events.Event;

    /**
     * tInspector's Flash Console plugin
     */
    public class FlashConsole extends BaseInspectorPlugin{

        public function FlashConsole():void{
			var iconBtn:InspectorIconButton = new InspectorIconButton(InspectorSymbolIcon.CONSOLE);
			iconBtn.setSize(23, 23);
			this._icon = iconBtn;
			this._icon.tip = InspectorLanguageManager.getStr("FlashConsole");
        }
        
		override public function contains(child : DisplayObject) : Boolean {
			if(super.contains(child))return true;
			if(this._icon == child)return true;
			if(Cc.instance){
				return Cc.instance == child || Cc.instance.contains(child);
			}else{
				return false;
			}
		}
		
		override public function onRegister(inspector : IInspector) : void {
			_inspector = inspector;
			_inspector.stage.addChild(_icon);

			InspectorPopupManager.popup(_icon, PopupAlignMode.TL);
			InspectorStageReference.addEventListener(Event.ENTER_FRAME, keepTopest);
		}

		override public function onUnRegister(inspector : IInspector) : void {
			InspectorPopupManager.remove(_icon);
			
			super.onUnRegister(inspector);
		}

		private function keepTopest(event : Event) : void {
			if (_icon.stage == null) return;
			_icon.stage.invalidate();
			var me : DisplayObject = _icon;
			_icon.addEventListener(Event.RENDER, function(evt : Event):void {
				_icon.removeEventListener(Event.RENDER, arguments.callee);
				if(_icon.parent) {
					if(_icon.parent.getChildIndex(me) != me.parent.numChildren - 1) {
						_icon.parent.setChildIndex(me, me.parent.numChildren - 1);
					}
				}
			});

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
			Cc.width = _inspector.stage.stageWidth;
			Cc.y = InspectorStageReference.getStageBounds().bottom - Cc.height;
        	
        	Cc.instance.panels.mainPanel.addEventListener(Event.CLOSE, removeFromStageHandler);
        	_inspector.stage.addEventListener(Event.RESIZE, stageResizeHandler);
		}

		private function stageResizeHandler(event : Event) : void {
			Cc.width = _inspector.stage.stageWidth;
			Cc.height = _inspector.stage.stageHeight;
		}

		private function removeFromStageHandler(event : Event) : void {
			_inspector.pluginManager.unactivePlugin(this.getPluginId());
		}
        
        override public function onUnActive():void{
        	Cc.instance.panels.mainPanel.removeEventListener(Event.CLOSE, removeFromStageHandler);
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
