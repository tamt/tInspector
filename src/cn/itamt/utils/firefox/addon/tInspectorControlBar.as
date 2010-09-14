package cn.itamt.utils.firefox.addon {
	import cn.itamt.utils.Debug;
	import cn.itamt.utils.inspector.consts.InspectorPluginId;
	import cn.itamt.utils.inspector.data.InspectTarget;
	import cn.itamt.utils.inspector.events.InspectEvent;
	import cn.itamt.utils.inspector.interfaces.IInspector;
	import cn.itamt.utils.inspector.interfaces.IInspectorPlugin;
	import cn.itamt.utils.inspector.plugins.gerrorkeeper.GlobalErrorKeeperButton;
	import cn.itamt.utils.inspector.plugins.gerrorkeeper.GlobalErrorsHistoryButton;
	import cn.itamt.utils.inspector.ui.AppStatsButton;
	import cn.itamt.utils.inspector.ui.FilterManagerButton;
	import cn.itamt.utils.inspector.ui.InspectorButton;
	import cn.itamt.utils.inspector.ui.InspectorFullScreenButton;
	import cn.itamt.utils.inspector.ui.InspectorOnOffButton;
	import cn.itamt.utils.inspector.ui.InspectorReloadButton;
	import cn.itamt.utils.inspector.ui.LiveInspectButton;
	import cn.itamt.utils.inspector.ui.PropertiesViewButton;
	import cn.itamt.utils.inspector.ui.StructureViewButton;
	import cn.itamt.utils.inspector.ui.SwfInfoButton;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;

	/**
	 * @author itamt@qq.com
	 */
	public class tInspectorControlBar extends Sprite implements IInspectorPlugin {
		private var _onOffBtn : InspectorOnOffButton;
		private var _liveBtn : LiveInspectButton;
		private var _structBtn : StructureViewButton;
		private var _propBtn : PropertiesViewButton;
		private var _filterBtn : FilterManagerButton;
		//控制全屏切换的按钮
		private var _screenBtn : InspectorFullScreenButton;
		//重载swf
		private var _reloadBtn : InspectorReloadButton;
		//控制显示AppStats的按钮
		private var _statsBtn : AppStatsButton;
		//显示swf信息的按钮
		private var _swfInfoBtn : SwfInfoButton;
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
					if(_inspector.getPluginById(InspectorPluginId.LIVE_VIEW).isActive) {
						_inspector.unactivePlugin(InspectorPluginId.LIVE_VIEW);
					} else {
						_inspector.activePlugin(InspectorPluginId.LIVE_VIEW);
					}
					break;
				case _propBtn:
					if(_inspector.getPluginById(InspectorPluginId.PROPER_VIEW).isActive) {
						_inspector.unactivePlugin(InspectorPluginId.PROPER_VIEW);
					} else {
						_inspector.activePlugin(InspectorPluginId.PROPER_VIEW);
					}
					break;
				case _structBtn:
					if(_inspector.getPluginById(InspectorPluginId.STRUCT_VIEW).isActive) {
						_inspector.unactivePlugin(InspectorPluginId.STRUCT_VIEW);
					} else {
						_inspector.activePlugin(InspectorPluginId.STRUCT_VIEW);
					}
					break;
				case _filterBtn:
					if(_inspector.getPluginById(InspectorPluginId.FILTER_VIEW).isActive) {
						_inspector.unactivePlugin(InspectorPluginId.FILTER_VIEW);
					} else {
						_inspector.activePlugin(InspectorPluginId.FILTER_VIEW);
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
					if(_inspector.getPluginById(InspectorPluginId.APPSTATS_VIEW).isActive) {
						_inspector.unactivePlugin(InspectorPluginId.APPSTATS_VIEW);
					} else {
						_inspector.activePlugin(InspectorPluginId.APPSTATS_VIEW);
					}
					break;
				case _swfInfoBtn:
					if(_inspector.getPluginById(InspectorPluginId.SWFINFO_VIEW).isActive) {
						_inspector.unactivePlugin(InspectorPluginId.SWFINFO_VIEW);
					} else {
						_inspector.activePlugin(InspectorPluginId.SWFINFO_VIEW);
					}
					break;
				case _gerrorBtn:
					Debug.trace('[tInspectorControlBar][onClickBtn]' + _inspector.getPluginById(InspectorPluginId.GLOBAL_ERROR_KEEPER).isActive);
					if(_inspector.getPluginById(InspectorPluginId.GLOBAL_ERROR_KEEPER).isActive) {
						_inspector.unactivePlugin(InspectorPluginId.GLOBAL_ERROR_KEEPER);
					} else {
						_inspector.activePlugin(InspectorPluginId.GLOBAL_ERROR_KEEPER);
					}
					break;
				case _gerrorHistoryBtn:
					if(_inspector.getPluginById(InspectorPluginId.GLOBAL_ERROR_KEEPER).isActive) {
						_inspector.getPluginById(InspectorPluginId.GLOBAL_ERROR_KEEPER)['toggleHistoryPanel']();
					}
					break;
				case _onOffBtn:
					if(this._inspector.isOn) {
						this._inspector.turnOff();
					} else {
						this._inspector.turnOn();
						if(!this._active)this._inspector.activePlugin(this.id);
					}
					break;
			}
		}

		private function getBtnById(pluginId : String) : InspectorButton {
			switch(pluginId) {
				case InspectorPluginId.FILTER_VIEW:
					return (_filterBtn == null) ? (_filterBtn = new FilterManagerButton()) : _filterBtn;
					break;
				case InspectorPluginId.STRUCT_VIEW:
					return (_structBtn == null) ? (_structBtn = new StructureViewButton()) : _structBtn;
					break;
				case InspectorPluginId.PROPER_VIEW:
					return (_propBtn == null) ? (_propBtn = new PropertiesViewButton()) : _propBtn;
					break;
				case InspectorPluginId.LIVE_VIEW:
					return (_liveBtn == null) ? (_liveBtn = new LiveInspectButton()) : _liveBtn;
					break;
				case InspectorPluginId.APPSTATS_VIEW:
					return (_statsBtn == null) ? (_statsBtn = new AppStatsButton()) : _statsBtn;
					break;
				case InspectorPluginId.SWFINFO_VIEW:
					return (_swfInfoBtn == null) ? (_swfInfoBtn = new SwfInfoButton()) : _swfInfoBtn;
					break;
				case InspectorPluginId.GLOBAL_ERROR_KEEPER:
					return (_gerrorBtn == null) ? (_gerrorBtn = new GlobalErrorKeeperButton()) : _gerrorBtn;
					break;
				case InspectorPluginId.GLOBAL_ERROR_HISTORY:
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
		}

		public function onRegisterPlugin(pluginId : String) : void {
//			Debug.trace('[tInspectorControlBar][onRegisterView]' + pluginId);
//			this.addChild(getBtnById(pluginId));
		}

		public function onUnRegisterPlugin(pluginId : String) : void {
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
			this.addChild(getBtnById(InspectorPluginId.STRUCT_VIEW));			this.addChild(getBtnById(InspectorPluginId.PROPER_VIEW));			this.addChild(getBtnById(InspectorPluginId.LIVE_VIEW));			this.addChild(getBtnById(InspectorPluginId.FILTER_VIEW));			this.addChild(getBtnById(InspectorPluginId.APPSTATS_VIEW));			this.addChild(getBtnById(InspectorPluginId.SWFINFO_VIEW));			this.addChild(getBtnById(InspectorPluginId.GLOBAL_ERROR_KEEPER));			this.addChild(getBtnById(InspectorPluginId.GLOBAL_ERROR_HISTORY));

			this.addChild(getBtnById('fullScreen'));			this.addChild(getBtnById('ReloadSwf'));
			
			getBtnById(InspectorPluginId.STRUCT_VIEW).active = _inspector.getPluginById(InspectorPluginId.STRUCT_VIEW) && _inspector.getPluginById(InspectorPluginId.STRUCT_VIEW).isActive;         
			getBtnById(InspectorPluginId.PROPER_VIEW).active = _inspector.getPluginById(InspectorPluginId.PROPER_VIEW) && _inspector.getPluginById(InspectorPluginId.PROPER_VIEW).isActive;
			getBtnById(InspectorPluginId.LIVE_VIEW).active = _inspector.getPluginById(InspectorPluginId.LIVE_VIEW) && _inspector.getPluginById(InspectorPluginId.LIVE_VIEW).isActive;
			getBtnById(InspectorPluginId.FILTER_VIEW).active = _inspector.getPluginById(InspectorPluginId.FILTER_VIEW) && _inspector.getPluginById(InspectorPluginId.FILTER_VIEW).isActive;    
			getBtnById(InspectorPluginId.APPSTATS_VIEW).active = _inspector.getPluginById(InspectorPluginId.APPSTATS_VIEW) && _inspector.getPluginById(InspectorPluginId.APPSTATS_VIEW).isActive;  
			getBtnById(InspectorPluginId.SWFINFO_VIEW).active = _inspector.getPluginById(InspectorPluginId.SWFINFO_VIEW) && _inspector.getPluginById(InspectorPluginId.SWFINFO_VIEW).isActive;
			getBtnById(InspectorPluginId.GLOBAL_ERROR_KEEPER).active = _inspector.getPluginById(InspectorPluginId.GLOBAL_ERROR_KEEPER) && _inspector.getPluginById(InspectorPluginId.GLOBAL_ERROR_KEEPER).isActive; 
		}

		public function onTurnOff() : void {
			this.removeChild(getBtnById(InspectorPluginId.STRUCT_VIEW));			this.removeChild(getBtnById(InspectorPluginId.PROPER_VIEW));			this.removeChild(getBtnById(InspectorPluginId.LIVE_VIEW));			this.removeChild(getBtnById(InspectorPluginId.FILTER_VIEW));			this.removeChild(getBtnById(InspectorPluginId.APPSTATS_VIEW));			this.removeChild(getBtnById(InspectorPluginId.SWFINFO_VIEW));			this.removeChild(getBtnById(InspectorPluginId.GLOBAL_ERROR_KEEPER));			this.removeChild(getBtnById(InspectorPluginId.GLOBAL_ERROR_HISTORY));

			this.removeChild(getBtnById('fullScreen'));
			this.removeChild(getBtnById('ReloadSwf'));
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
			Debug.trace('[tInspectorControlBar][onActiveView]' + pluginId);
			var btn : InspectorButton = this.getBtnById(pluginId) as InspectorButton;
			if(btn) {
				btn.active = true;
			}
			_inspector.stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
		}

		public function onUnActivePlugin(pluginId : String) : void {
			Debug.trace('[tInspectorControlBar][onUnActiveView]' + pluginId);
			var btn : InspectorButton = this.getBtnById(pluginId) as InspectorButton;
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
