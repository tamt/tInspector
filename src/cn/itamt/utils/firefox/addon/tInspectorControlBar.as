package cn.itamt.utils.firefox.addon {
	import cn.itamt.utils.Debug;
	import cn.itamt.utils.inspector.consts.InspectorViewID;
	import cn.itamt.utils.inspector.data.InspectTarget;
	import cn.itamt.utils.inspector.interfaces.IInspector;
	import cn.itamt.utils.inspector.interfaces.IInspectorView;
	import cn.itamt.utils.inspector.ui.InspectorFilterClassButton;
	import cn.itamt.utils.inspector.ui.InspectorFullScreenButton;
	import cn.itamt.utils.inspector.ui.InspectorMouseInspectButton;
	import cn.itamt.utils.inspector.ui.InspectorOnOffButton;
	import cn.itamt.utils.inspector.ui.InspectorViewInfoButton;
	import cn.itamt.utils.inspector.ui.InspectorViewStructureButton;

	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;

	/**
	 * @author itamt@qq.com
	 */
	public class tInspectorControlBar extends Sprite implements IInspectorView {
		private var _onOffBtn : InspectorOnOffButton;
		private var _liveBtn : InspectorMouseInspectButton;
		private var _structBtn : InspectorViewStructureButton;
		private var _propBtn : InspectorViewInfoButton;
		private var _filterBtn : InspectorFilterClassButton;
		//控制全屏切换的按钮
		private var _screenBtn : InspectorFullScreenButton;

		private var _inspector : IInspector;
		private var _active : Boolean;

		private var _id : String = 'inspector_control_bar';

		public function get id() : String {
			return _id;
		}

		public function tInspectorControlBar() {
//			this.graphics.clear();
//			this.graphics.beginFill(0x000000, .5);
//			this.graphics.drawRoundRectComplex(0, 0, 24, 24, 0, 0, 6, 6);
//			this.graphics.endFill();
		}

		//////////////////////////////////////
		//////////private functions///////////
		//////////////////////////////////////

		private function onClickBtn(evt : MouseEvent) : void {
			switch(evt.target) {
				case _liveBtn:
					if(_inspector.getViewByID(InspectorViewID.LIVE_VIEW).isActive) {
						_inspector.unactiveView(InspectorViewID.LIVE_VIEW);
					} else {
						_inspector.activeView(InspectorViewID.LIVE_VIEW);
					}
					break;
				case _propBtn:
					if(_inspector.getViewByID(InspectorViewID.PROPER_VIEW).isActive) {
						_inspector.unactiveView(InspectorViewID.PROPER_VIEW);
					} else {
						_inspector.activeView(InspectorViewID.PROPER_VIEW);
					}
					break;
				case _structBtn:
					if(_inspector.getViewByID(InspectorViewID.STRUCT_VIEW).isActive) {
						_inspector.unactiveView(InspectorViewID.STRUCT_VIEW);
					} else {
						_inspector.activeView(InspectorViewID.STRUCT_VIEW);
					}
					break;
				case _filterBtn:
					if(_inspector.getViewByID(InspectorViewID.FILTER_VIEW).isActive) {
						_inspector.unactiveView(InspectorViewID.FILTER_VIEW);
					} else {
						_inspector.activeView(InspectorViewID.FILTER_VIEW);
					}
					break;
				case _screenBtn:
					if(this.stage.displayState != StageDisplayState.NORMAL) {
						this.stage.displayState = StageDisplayState.NORMAL;
					} else {
						this.stage.displayState = StageDisplayState.FULL_SCREEN;
					}
					break;
				case _onOffBtn:
					if(this._inspector.isOn) {
						this._inspector.turnOff();
					} else {
						this._inspector.turnOn();
					}
					break;
			}
		}

		private function getBtnById(viewClassId : String) : SimpleButton {
			switch(viewClassId) {
				case InspectorViewID.FILTER_VIEW:
					return (_filterBtn == null) ? (_filterBtn = new InspectorFilterClassButton()) : _filterBtn;
					break;
				case InspectorViewID.STRUCT_VIEW:
					return (_structBtn == null) ? (_structBtn = new InspectorViewStructureButton()) : _structBtn;
					break;
				case InspectorViewID.PROPER_VIEW:
					return (_propBtn == null) ? (_propBtn = new InspectorViewInfoButton()) : _propBtn;
					break;
				case InspectorViewID.LIVE_VIEW:
					return (_liveBtn == null) ? (_liveBtn = new InspectorMouseInspectButton()) : _liveBtn;
					break;
				case 'tInspector':
					return (_onOffBtn == null) ? (_onOffBtn = new InspectorOnOffButton()) : _onOffBtn;
					break;
				case 'fullScreen':
					return (_screenBtn == null) ? (_screenBtn = new InspectorFullScreenButton()) : _screenBtn;
					break;
			}
			
			return null;
		}

		//////////////////////////////////////
		//////////实现接口：IInspectorView////////
		//////////////////////////////////////

		override public function contains(child : DisplayObject) : Boolean {
			return this == child || super.contains(child);
		}

		public function onRegister(inspector : IInspector) : void {
			Debug.trace('[tInspectorControlBar][onRegister]');
			_inspector = inspector;
			this.addChild(getBtnById('tInspector'));

			this.addEventListener(MouseEvent.CLICK, onClickBtn);
		}

		public function onUnRegister(inspector : IInspector) : void {
			this.removeEventListener(MouseEvent.CLICK, onClickBtn);
		}

		public function onRegisterView(viewClassId : String) : void {
//			Debug.trace('[tInspectorControlBar][onRegisterView]' + viewClassId);
//			this.addChild(getBtnById(viewClassId));
		}

		public function onUnRegisterView(viewClassId : String) : void {
		}

		public function onActive() : void {
			_active = true;
		}

		public function onUnActive() : void {
			_active = false;
		}

		public function onTurnOn() : void {
			this.addChild(getBtnById(InspectorViewID.STRUCT_VIEW));			this.addChild(getBtnById(InspectorViewID.PROPER_VIEW));			this.addChild(getBtnById(InspectorViewID.LIVE_VIEW));			this.addChild(getBtnById(InspectorViewID.FILTER_VIEW));
			//检测是否允许设置全屏
			if(FlashPlayerEnvironment.getAllowFullScreen())this.addChild(getBtnById('fullScreen'));
		}

		public function onTurnOff() : void {
			this.removeChild(getBtnById(InspectorViewID.STRUCT_VIEW));			this.removeChild(getBtnById(InspectorViewID.PROPER_VIEW));			this.removeChild(getBtnById(InspectorViewID.LIVE_VIEW));			this.removeChild(getBtnById(InspectorViewID.FILTER_VIEW));
			//
			if(FlashPlayerEnvironment.getAllowFullScreen())this.removeChild(getBtnById('fullScreen'));
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

		public function onActiveView(viewClassId : String) : void {
		}

		public function onUnActiveView(viewClassId : String) : void {
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
