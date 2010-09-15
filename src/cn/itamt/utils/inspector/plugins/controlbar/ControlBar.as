package cn.itamt.utils.inspector.plugins.controlbar {
	import cn.itamt.utils.inspector.core.InspectTarget;
	import cn.itamt.utils.inspector.core.IInspectorPlugin;
	import cn.itamt.utils.inspector.core.IInspector;
	import cn.itamt.utils.inspector.popup.InspectorPopupManager;
	import cn.itamt.utils.inspector.popup.PopupAlignMode;
	import cn.itamt.utils.inspector.ui.InspectorButton;
	import cn.itamt.utils.inspector.ui.InspectorStageReference;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author itamt@qq.com
	 */
	public class ControlBar extends Sprite implements IInspectorPlugin {
		private var _onOffBtn : InspectorOnOffButton;
		private var _inspector : IInspector;
		private var _active : Boolean;

		private var _id : String = 'inspector_control_bar';

		public function ControlBar() {
		}

		//////////////////////////////////////
		//////////private functions///////////
		//////////////////////////////////////

		private function onClickBtn(evt : MouseEvent) : void {
			switch(evt.target) {
				case _onOffBtn:
					if(this._inspector.isOn) {
						this._inspector.turnOff();
					} else {
						this._inspector.turnOn();
						if(!this._active)this._inspector.activePlugin(this.getPluginId());
					}
					break;
			}
		}

		private function keepTopest(event : Event) : void {
			if(this.parent) {
				if(this.parent.getChildIndex(this) != this.parent.numChildren - 1) {
					this.parent.setChildIndex(this, this.parent.numChildren - 1);
				}
			}
		}

		//////////////////////////////////////
		////////实现接口：IInspectorPlugin/////
		//////////////////////////////////////
		/**
		 * get this plugin's id
		 */
		public function getPluginId() : String {
			return _id;
		}

		public function getPluginIcon() : DisplayObject {
			return null;
		}

		/**
		 * get this plugin's version
		 */
		public function getPluginVersion() : String {
			return "1.0";
		}

		override public function contains(child : DisplayObject) : Boolean {
			return this == child || super.contains(child);
		}

		public function onRegister(inspector : IInspector) : void {
			_inspector = inspector;
			this.addChild(_onOffBtn = new InspectorOnOffButton());
			this.addEventListener(MouseEvent.CLICK, onClickBtn);
			
			InspectorPopupManager.popup(this, PopupAlignMode.TL);
			InspectorStageReference.addEventListener(Event.ENTER_FRAME, keepTopest);
		}

		public function onUnRegister(inspector : IInspector) : void {
			this.removeEventListener(MouseEvent.CLICK, onClickBtn);
			
			InspectorPopupManager.remove(this);
		}

		public function onRegisterPlugin(pluginId : String) : void {
		}

		public function onUnRegisterPlugin(pluginId : String) : void {
		}

		public function onActive() : void {
			_active = true;
		}

		public function onUnActive() : void {
			_active = false;
		}

		public function onTurnOn() : void {			
			var arr : Array = this._inspector.getPlugins();
			for(var i : int = 0;i < arr.length;i++) {
				this.addChild(arr[i].getPluginIcon());	
			}
		}

		public function onTurnOff() : void {
			var arr : Array = this._inspector.getPlugins();
			for each (var plugin : IInspectorPlugin in arr) {
				this.removeChild(plugin.getPluginIcon());
			}
		}

		public function onInspect(target : InspectTarget) : void {
		}

		public function onLiveInspect(target : InspectTarget) : void {
		}

		public function onStopLiveInspect() : void {
		}

		public function onStartLiveInspect() : void {
		}

		public function onUpdate(target : InspectTarget = null) : void {
		}

		public function onInspectMode(clazz : Class) : void {
		}

		public function onActivePlugin(pluginId : String) : void {
			var btn : InspectorButton = this._inspector.getPluginById(pluginId) as InspectorButton;
			if(btn) {
				btn.active = true;
			}
		}

		public function onUnActivePlugin(pluginId : String) : void {
			var btn : InspectorButton = this._inspector.getPluginById(pluginId) as InspectorButton;
			if(btn) {
				btn.active = false;
			}
		}

		public function get isActive() : Boolean {
			return _active;
		}

		//////////////////////////////////////
		////////////override funcions/////////
		//////////////////////////////////////
		override public function addChild(child : DisplayObject) : DisplayObject {
			if(child != null && !contains(child)) {
				if(numChildren > 0) {
					child.x = getChildAt(numChildren - 1).x + getChildAt(numChildren - 1).width;
//					child.y = 5;
				} else {
//					child.x = 5;
//					child.y = 5;
				}
				
				this.graphics.clear();
				this.graphics.beginFill(0x000000, .5);
				this.graphics.drawRoundRectComplex(0, 0, child.x + child.width/* + 5*/, child.height, 0, 0, 6, 6);
				this.graphics.endFill();
				
				return super.addChild(child);
			}
			return null;
		}

		override public function removeChild(child : DisplayObject) : DisplayObject {
			if(child != null && contains(child)) {
				var t : int = this.getChildIndex(child);
				for(var i : int = t + 1;i < this.numChildren;i++) {
					this.getChildAt(t).x -= child.width;
				}
				
				super.removeChild(child);
				
				if(this.numChildren) {
					var last : DisplayObject = this.getChildAt(this.numChildren - 1);
					this.graphics.clear();
					this.graphics.beginFill(0x000000, .5);
					this.graphics.drawRoundRectComplex(0, 0, last.x + last.width/* + 5*/, last.height, 0, 0, 6, 6);
					this.graphics.endFill();
				}
				
				return child;
			}
			return null;
		}
	}
}
