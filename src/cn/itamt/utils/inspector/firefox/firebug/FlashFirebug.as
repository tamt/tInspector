package cn.itamt.utils.inspector.firefox.firebug 
{
	import cn.itamt.utils.Debug;
	import cn.itamt.utils.inspector.core.BaseInspectorPlugin;
	import cn.itamt.utils.inspector.core.IInspector;
	import cn.itamt.utils.inspector.core.InspectTarget;
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.plugins.InspectorPluginId;
	import cn.itamt.utils.inspector.ui.InspectorIconButton;
	import cn.itamt.utils.inspector.ui.InspectorSymbolIcon;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.external.ExternalInterface;
	import ominds.Firebug;
	
	/**
	 * 该插件可以使FlashInspector与FlashFirebug整合工作!
	 * @author tamt
	 */
	public class FlashFirebug extends BaseInspectorPlugin 
	{
		//only used by FlashFirebug.as
		//这个变量的只能由Firebug.as进行修改,设置.
		public var keepStatic:Boolean;
		//当前查看对象
		private var _target:DisplayObject;
		//
		private var _connected:Boolean = false;
		
		public function FlashFirebug() 
		{
			super();
		}
		
		override public function contains(child:DisplayObject) : Boolean {
			if (child == null) return false;
			if (Firebug.overlay) {
				return Firebug.overlay == child || Firebug.overlay.contains(child);
			} else {
				return false;
			}
		}
		
		override public function getPluginId() : String {
			return InspectorPluginId.FLASH_FIREBUG;
		}

		override public function onRegister(inspector : IInspector) : void {
			super.onRegister(inspector);
			
			_icon = new FlashFirebugButton();
		}
		
		override public function onActive():void {
			super.onActive();
			
			Debug.trace("connect FlashFirebug...");
			if(ExternalInterface.available){
				Firebug.connect(_inspector.root);
				if (Firebug.overlay && Firebug.overlay.parent) Firebug.overlay.parent.removeChild(Firebug.overlay);
			}
		}

		override public function onUnActive() : void {
			super.onUnActive();
			
			keepStatic = false;
			_connected = false;
		}
		
		/**
		 * 查看对象时
		 */		
		override public function onInspect(target : InspectTarget) : void {
			super.onInspect(target);
			
			if (keepStatic) return;
			
			_target = target.displayObject;
			if (target && target.displayObject) {
				//cmd: selectObject, target: 0, id: swf0
				Debug.trace("[FlashFirebug]" + convertToFirebugTargetStr(target.displayObject));
				Firebug.selectObject( { command: "selectObject", target: convertToFirebugTargetStr(target.displayObject), id: Firebug.id, callFromFI:true } );
				///*
				var targetPath:String = convertToFirebugTargetStr(target.displayObject);
				//Firebug.getTree( { target: "root", id: Firebug.id, callFromFI:true} );
				//if (targetPath != "root") {
					//var nameArr:Array = targetPath.split(".");
					//var str:String = "";
					//for (var i:int = 0; i < nameArr.length; i++) {
						//str += nameArr[i];
						//Firebug.getTree( { target: str, id: Firebug.id, callFromFI:true} );
						//str += ".";
					//}
				//}
				//*/
				Firebug.openTree({id:Firebug.id, target:targetPath, callFromFI:true});
			}
		}
		
		override public function onUpdate(target : InspectTarget = null) : void {
			Debug.trace("onUpdate: " + target);
			
			if (keepStatic) return;
			
			if (target == null) return;
			if (_target == target.displayObject){
				super.onUpdate(target);
				
				if(_inspector.getCurInspectTarget() == target){
					if (target && target.displayObject) {
						Firebug.selectObject( { command: "selectObject", target: convertToFirebugTargetStr(target.displayObject), id: Firebug.id, callFromFI:true } );
					}
				}
			}
		}

		/**
		 * 当Inspector鼠标查看某个目标显示对象时
		 */
		override public function onLiveInspect(ele : InspectTarget) : void {
			
		}
		
		private function convertToFirebugTargetStr(target:DisplayObject):String {
			var str:String = "";
			if (target is Stage || target.parent is Stage) {
				str = "root";
				return str;
			}
			if (target.parent) {
				str = target.parent.getChildIndex(target).toString();
				while (target = target.parent) {
					if (target is Stage || target.parent is Stage) {
						break;
					}else {
						if(target.parent){
							str = target.parent.getChildIndex(target) + "." + str;
						}else {
							break;
						}
					}
				}
			}
			return str;
		}
		
		/**
		 * only called by FlashFirebug.as
		 * connect FlashFirebug fail
		 * 连接失败
		 */
		public function onConnectFail(afterTimes:int):void {
			_connected = false;
			_inspector.pluginManager.unactivePlugin(this.getPluginId());
			
			//show connect fail tip
			this._icon.showTempTip(InspectorLanguageManager.getStr("ConnectFFBFail") + afterTimes);
		}
		
		/**
		 * only called by FlashFirebug.as
		 * connect FlashFirebug success
		 * 连接成功
		 */
		public function onConnectSuccess(afterTimes:int):void {
			_connected = true;
		}
	}

}