package cn.itamt.utils.inspector.firefox.firebug 
{
	import cn.itamt.utils.Debug;
	import cn.itamt.utils.DisplayObjectTool;
	import cn.itamt.utils.inspector.core.BaseInspectorPlugin;
	import cn.itamt.utils.inspector.core.IInspector;
	import cn.itamt.utils.inspector.core.InspectTarget;
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.plugins.InspectorPluginId;
	import cn.itamt.utils.inspector.ui.InspectorIconButton;
	import cn.itamt.utils.inspector.ui.InspectorSymbolIcon;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
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
		//
		private var _targetRectContainer:Sprite;
		
		public function FlashFirebug() 
		{
			super();
		}
		
		override public function contains(child:DisplayObject) : Boolean {
			if (child == null) return false;
			if (Firebug.overlay) {
				return Firebug.overlay == child || Firebug.overlay.contains(child);
			} else {
				return super.contains(child);
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
			
			if(viewContainer == null){
				viewContainer = new Sprite();
				viewContainer.mouseChildren = viewContainer.mouseEnabled = false;
			}
			
			_inspector.stage.addChild(viewContainer);
			
			if (_targetRectContainer == null) {
				_targetRectContainer = new Sprite();
				_targetRectContainer.mouseChildren = _targetRectContainer.mouseEnabled = false;
			}
			viewContainer.addChild(_targetRectContainer);
		}

		override public function onUnActive() : void {
			super.onUnActive();
			
			keepStatic = false;
			_connected = false;
			
			_target = null;
			
			if (viewContainer) {
				viewContainer.graphics.clear();
				if (viewContainer.parent) viewContainer.parent.removeChild(viewContainer);
				viewContainer = null;
			}
		}
		
		/**
		 * 查看对象时
		 */		
		override public function onInspect(target : InspectTarget) : void {
			super.onInspect(target);
			
			this.clearTargetRect();
			this.alertTargetRect();
			
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
			clearTargetRect();
			if (ele != _inspector.getCurInspectTarget()) {
				this.drawTargetRect(viewContainer, ele);
				this.drawTargetRect(viewContainer, _inspector.getCurInspectTarget());
			}else {
				this.drawTargetRect(viewContainer, ele);
			}
		}

		/**
		 * 当Inspector鼠标查看某个目标显示对象时
		 */
		override public function onStopLiveInspect() : void {
			this.clearTargetRect();
		}

		/**
		 * 当该InspectorView注册到Inspector时.
		 */
		override public function onActivePlugin(pluginId : String) : void {
			if (isActive && pluginId == InspectorPluginId.LIVE_VIEW) {
				this.clearTargetRect();
			}
		}

		/**
		 * 当该InspectorView从Inspector删除注册时
		 */
		override public function onUnActivePlugin(pluginId : String) : void {
			if (isActive && pluginId == InspectorPluginId.LIVE_VIEW) {
				//this.drawTargetRect(viewContainer);
				alertTargetRect();
			}
		}
		
		private function drawTargetRect(drawOn:Sprite, ele:InspectTarget = null):void {
			if (_inspector.pluginManager.getPluginById(InspectorPluginId.LIVE_VIEW).isActive) return;
			
			var color:uint = 0xff0000;
			if (ele == null) {
				ele = _inspector.getCurInspectTarget();
			}
			
			//if(ele && ele==_inspector.getCurInspectTarget())color = 0x636C02;
			if(ele && ele==_inspector.getCurInspectTarget())color = 0x0000ff;
			
			if (ele && ele.displayObject) {
				var rect:Rectangle = ele.displayObject.getBounds(viewContainer);
				
				drawOn.graphics.lineStyle(4, color, 1);
				drawOn.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
				
				if (ele == _inspector.getCurInspectTarget()) drawOn.graphics.beginFill(color, .3);
				drawOn.graphics.lineStyle(1, 0x0, 1);
				drawOn.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
				drawOn.graphics.endFill();
				
				DisplayObjectTool.swapToTop(viewContainer);
			}
		}
		
		private function alertTargetRect():void 
		{
			DisplayObjectTool.callLater(
				function() {
					drawAlertTargetRect();
					DisplayObjectTool.callLater(
						function() {
							drawAlertTargetRect();
							DisplayObjectTool.callLater(
								function() {
									drawAlertTargetRect();
									DisplayObjectTool.callLater(
										function() {
											drawAlertTargetRect();
										}, null, 8);
								}, null, 8)
						}, null, 8);
				}, null, 8);
		}
		
		private function drawAlertTargetRect():void {
			_targetRectContainer.graphics.clear();
			if (_inspector.getCurInspectTarget()) {
				drawTargetRect(_targetRectContainer, _inspector.getCurInspectTarget());
				DisplayObjectTool.callLater(function():void { _targetRectContainer.graphics.clear();}, null, 2);
			}
		}
		
		private function clearTargetRect():void {
			if (viewContainer) {
				viewContainer.graphics.clear();
			}
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