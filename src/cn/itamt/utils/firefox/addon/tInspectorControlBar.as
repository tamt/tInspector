package cn.itamt.utils.firefox.addon {
	import cn.itamt.utils.Debug;
	import cn.itamt.utils.inspector.consts.InspectorViewID;
	import cn.itamt.utils.inspector.data.InspectTarget;
	import cn.itamt.utils.inspector.events.InspectEvent;
	import cn.itamt.utils.inspector.interfaces.IInspector;
	import cn.itamt.utils.inspector.interfaces.IInspectorView;
	import cn.itamt.utils.inspector.plugins.gerrorkeeper.GlobalErrorKeeperButton;
	import cn.itamt.utils.inspector.plugins.gerrorkeeper.GlobalErrorsHistoryButton;
	import cn.itamt.utils.inspector.ui.InspectorAppStatsButton;
	import cn.itamt.utils.inspector.ui.InspectorFilterClassButton;
	import cn.itamt.utils.inspector.ui.InspectorFullScreenButton;
	import cn.itamt.utils.inspector.ui.InspectorMouseInspectButton;
	import cn.itamt.utils.inspector.ui.InspectorOnOffButton;
	import cn.itamt.utils.inspector.ui.InspectorReloadButton;
	import cn.itamt.utils.inspector.ui.InspectorSwfInfoButton;
	import cn.itamt.utils.inspector.ui.InspectorViewInfoButton;
	import cn.itamt.utils.inspector.ui.InspectorViewOperationButton;
	import cn.itamt.utils.inspector.ui.InspectorViewStructureButton;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.FullScreenEvent;
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
		//重载swf
		private var _reloadBtn : InspectorReloadButton;
		//控制显示AppStats的按钮
		private var _statsBtn : InspectorAppStatsButton;
		//显示swf信息的按钮
		private var _swfInfoBtn : InspectorSwfInfoButton;
		//全局处理错误
		private var _gerrorBtn : GlobalErrorKeeperButton;
		//错误历史按钮
		private var _gerrorHistoryBtn : GlobalErrorsHistoryButton;

		//tinspector.
		private var _inspector : IInspector;
		private var _active : Boolean;

		private var _id : String = 'inspector_control_bar';

		public function get id() : String {
			return _id;
		}

		public function tInspectorControlBar() {
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
//						_screenBtn.active = false;
					} else {
						this.stage.displayState = StageDisplayState.FULL_SCREEN;
//						_screenBtn.active = true;
					}
					break;
				case _reloadBtn:
					this.dispatchEvent(new InspectEvent(InspectEvent.RELOAD, _inspector.root));
					break;
				case _statsBtn:
					if(_inspector.getViewByID(InspectorViewID.APPSTATS_VIEW).isActive) {
						_inspector.unactiveView(InspectorViewID.APPSTATS_VIEW);
					} else {
						_inspector.activeView(InspectorViewID.APPSTATS_VIEW);
					}
					break;
				case _swfInfoBtn:
					if(_inspector.getViewByID(InspectorViewID.SWFINFO_VIEW).isActive) {
						_inspector.unactiveView(InspectorViewID.SWFINFO_VIEW);
					} else {
						_inspector.activeView(InspectorViewID.SWFINFO_VIEW);
					}
					break;
				case _gerrorBtn:
					Debug.trace('[tInspectorControlBar][onClickBtn]' + _inspector.getViewByID(InspectorViewID.GLOBAL_ERROR_KEEPER).isActive);
					if(_inspector.getViewByID(InspectorViewID.GLOBAL_ERROR_KEEPER).isActive) {
						_inspector.unactiveView(InspectorViewID.GLOBAL_ERROR_KEEPER);
					} else {
						_inspector.activeView(InspectorViewID.GLOBAL_ERROR_KEEPER);
					}
					break;
				case _gerrorHistoryBtn:
					if(_inspector.getViewByID(InspectorViewID.GLOBAL_ERROR_KEEPER).isActive) {
						_inspector.getViewByID(InspectorViewID.GLOBAL_ERROR_KEEPER)['toggleHistoryPanel']();
					}
					break;
				case _onOffBtn:
					if(this._inspector.isOn) {
						this._inspector.turnOff();
					} else {
						this._inspector.turnOn();
						if(!this._active)this._inspector.activeView(this.id);
					}
					break;
			}
		}

		private function getBtnById(viewClassId : String) : InspectorViewOperationButton {
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
				case InspectorViewID.APPSTATS_VIEW:
					return (_statsBtn == null) ? (_statsBtn = new InspectorAppStatsButton()) : _statsBtn;
					break;
				case InspectorViewID.SWFINFO_VIEW:
					return (_swfInfoBtn == null) ? (_swfInfoBtn = new InspectorSwfInfoButton()) : _swfInfoBtn;
					break;
				case InspectorViewID.GLOBAL_ERROR_KEEPER:
					return (_gerrorBtn == null) ? (_gerrorBtn = new GlobalErrorKeeperButton()) : _gerrorBtn;
					break;
				case InspectorViewID.GLOBAL_ERROR_HISTORY:
					return (_gerrorHistoryBtn == null) ? (_gerrorHistoryBtn = new GlobalErrorsHistoryButton()) : _gerrorHistoryBtn;
					break;
				case 'tInspector':
					return (_onOffBtn == null) ? (_onOffBtn = new InspectorOnOffButton()) : _onOffBtn;
					break;
				case 'fullScreen':
					return (_screenBtn == null) ? (_screenBtn = new InspectorFullScreenButton()) : _screenBtn;
					break;
				case 'ReloadSwf':
					return (_reloadBtn == null) ? (_reloadBtn = new InspectorReloadButton()) : _reloadBtn;
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
			_inspector.stage.removeEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
		}

		private function onFullScreen(evt : FullScreenEvent) : void {
			this.getBtnById("fullScreen").active = evt.fullScreen;
//			this._screenBtn.active = 
		}

		public function onRegisterView(viewClassId : String) : void {
//			Debug.trace('[tInspectorControlBar][onRegisterView]' + viewClassId);
//			this.addChild(getBtnById(viewClassId));
		}

		public function onUnRegisterView(viewClassId : String) : void {
		}

		public function onActive() : void {
			Debug.trace('[tInspectorControlBar][onActive]');
			_active = true;
		}

		public function onUnActive() : void {
			Debug.trace('[tInspectorControlBar][onUnActive]');
			_active = false;
		}

		public function onTurnOn() : void {
			this.addChild(getBtnById(InspectorViewID.STRUCT_VIEW));			this.addChild(getBtnById(InspectorViewID.PROPER_VIEW));			this.addChild(getBtnById(InspectorViewID.LIVE_VIEW));			this.addChild(getBtnById(InspectorViewID.FILTER_VIEW));			this.addChild(getBtnById(InspectorViewID.APPSTATS_VIEW));			this.addChild(getBtnById(InspectorViewID.SWFINFO_VIEW));			this.addChild(getBtnById(InspectorViewID.GLOBAL_ERROR_KEEPER));			this.addChild(getBtnById(InspectorViewID.GLOBAL_ERROR_HISTORY));
			//检测是否允许设置全屏
			/*if(FlashPlayerEnvironment.getAllowFullScreen())*/

			this.addChild(getBtnById('fullScreen'));			this.addChild(getBtnById('ReloadSwf'));
			
			getBtnById(InspectorViewID.STRUCT_VIEW).active = _inspector.getViewByID(InspectorViewID.STRUCT_VIEW) && _inspector.getViewByID(InspectorViewID.STRUCT_VIEW).isActive;         
			getBtnById(InspectorViewID.PROPER_VIEW).active = _inspector.getViewByID(InspectorViewID.PROPER_VIEW) && _inspector.getViewByID(InspectorViewID.PROPER_VIEW).isActive;
			getBtnById(InspectorViewID.LIVE_VIEW).active = _inspector.getViewByID(InspectorViewID.LIVE_VIEW) && _inspector.getViewByID(InspectorViewID.LIVE_VIEW).isActive;
			getBtnById(InspectorViewID.FILTER_VIEW).active = _inspector.getViewByID(InspectorViewID.FILTER_VIEW) && _inspector.getViewByID(InspectorViewID.FILTER_VIEW).isActive;    
			getBtnById(InspectorViewID.APPSTATS_VIEW).active = _inspector.getViewByID(InspectorViewID.APPSTATS_VIEW) && _inspector.getViewByID(InspectorViewID.APPSTATS_VIEW).isActive;  
			getBtnById(InspectorViewID.SWFINFO_VIEW).active = _inspector.getViewByID(InspectorViewID.SWFINFO_VIEW) && _inspector.getViewByID(InspectorViewID.SWFINFO_VIEW).isActive;
			getBtnById(InspectorViewID.GLOBAL_ERROR_KEEPER).active = _inspector.getViewByID(InspectorViewID.GLOBAL_ERROR_KEEPER) && _inspector.getViewByID(InspectorViewID.GLOBAL_ERROR_KEEPER).isActive; 
		}

		public function onTurnOff() : void {
			this.removeChild(getBtnById(InspectorViewID.STRUCT_VIEW));			this.removeChild(getBtnById(InspectorViewID.PROPER_VIEW));			this.removeChild(getBtnById(InspectorViewID.LIVE_VIEW));			this.removeChild(getBtnById(InspectorViewID.FILTER_VIEW));			this.removeChild(getBtnById(InspectorViewID.APPSTATS_VIEW));			this.removeChild(getBtnById(InspectorViewID.SWFINFO_VIEW));			this.removeChild(getBtnById(InspectorViewID.GLOBAL_ERROR_KEEPER));			this.removeChild(getBtnById(InspectorViewID.GLOBAL_ERROR_HISTORY));
			//
			/*if(FlashPlayerEnvironment.getAllowFullScreen())*/

			this.removeChild(getBtnById('fullScreen'));
			this.removeChild(getBtnById('ReloadSwf'));
			
//			this._onOffBtn.active = false;
//			this._filterBtn.active = false;
//			this._liveBtn.active = false;
//			this._propBtn.active = false;
//			this._reloadBtn.active = false;
//			this._screenBtn.active = false;
//			this._statsBtn.active = false;
//			this._structBtn.active = false;
//			this._swfInfoBtn.active = false;
//			this._gerrorBtn.active = false;
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
			Debug.trace('[tInspectorControlBar][onActiveView]' + viewClassId);
			var btn : InspectorViewOperationButton = this.getBtnById(viewClassId) as InspectorViewOperationButton;
			if(btn) {
				btn.active = true;
			}
			_inspector.stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
		}

		public function onUnActiveView(viewClassId : String) : void {
			Debug.trace('[tInspectorControlBar][onUnActiveView]' + viewClassId);
			var btn : InspectorViewOperationButton = this.getBtnById(viewClassId) as InspectorViewOperationButton;
			if(btn) {
				btn.active = false;
			}
			_inspector.stage.removeEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
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
