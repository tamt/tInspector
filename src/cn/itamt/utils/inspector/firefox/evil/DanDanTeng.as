package cn.itamt.utils.inspector.firefox.evil 
{
	import cn.itamt.utils.ClassTool;
	import cn.itamt.utils.Debug;
	import cn.itamt.utils.inspector.core.BaseInspectorPlugin;
	import cn.itamt.utils.inspector.core.IInspector;
	import cn.itamt.utils.inspector.core.inspectfilter.InspectorFilterManager;
	import cn.itamt.utils.inspector.plugins.InspectorPluginId;
	import cn.itamt.utils.inspector.plugins.tfm3d.TransformToolButton;
	import cn.itamt.utils.inspector.popup.InspectorPopupManager;
	import cn.itamt.utils.inspector.popup.PopupAlignMode;
	import cn.itamt.utils.inspector.ui.InspectorButton;
	import cn.itamt.utils.inspector.ui.InspectorIconButton;
	import cn.itamt.utils.inspector.ui.InspectorSymbolIcon;
	import flash.display.DisplayObject;
	import cn.itamt.utils.inspector.firefox.evil.DanDanTengIcon;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	
	/**
	 * 弹弹堂外挂
	 * @author tamt
	 */
	public class DanDanTeng extends BaseInspectorPlugin 
	{
		
		private var _panel:DanDanTengPanel;
		
		private var _playerClass:Class;
		private var _playerClassName:String = "game.objects.GamePlayer";
		private var _localPlayerClass:Class;
		private var _localPlayerClassName:String = "game.objects.GameLocalPlayer";
		private var _playersContainer:DisplayObjectContainer;
		
		private var _players:Array;
		private var _localPlayer:*;
		
		public function DanDanTeng() 
		{
		}
		
		override public function contains(child:DisplayObject) : Boolean {
			if(_panel) {
				return _panel == child || _panel.contains(child);
			} else {
				return false;
			}
		}
		
		override public function onRegister(inspector : IInspector):void {
			super.onRegister(inspector);
			
			var iconBtn:InspectorIconButton = new InspectorIconButton(new DanDanTengIcon(0, 0));
			iconBtn.setSize(iconBtn.width, 23);
			_icon = iconBtn;
		}
		
		/**
		 * get this plugin's id
		 */
		override public function getPluginId() : String {
			return "DanDanTeng";
		}
		
		override public function onActive():void {
			if (_actived) return;
			super.onActive();
			
			Debug.trace("启动外挂");
			_panel = new DanDanTengPanel();
			_panel.addEventListener(Event.CLOSE, unactiveThisPlugin);
			_panel.addEventListener(Event.SELECT, onSelectPlayer);
			_panel.addEventListener("anti_invisible", onAntiInvisible);
			
			_playersContainer = findPlayerContainer();
			if (_playersContainer) {
				Debug.trace("查找GamePlayer所在容器:成功");
				this.findPlayers();
				this.updatePanel();
			}else {
				Debug.trace("查找GamePlayer所在容器:失败");
			}
			
			InspectorPopupManager.popup(_panel, PopupAlignMode.TOP);
		}
		
		/**
		 * 消除玩家的隐身
		 * @param	e
		 */
		private function onAntiInvisible(e:Event):void 
		{
			Debug.trace("消除玩家隐身");
			if(_players){
				for (var i:int = 0; i < _players.length; i++) {
					if (!(_players[i] as DisplayObject).visible) {
						Debug.trace("找到一个玩家隐身");
						(_players[i] as DisplayObject).visible = true;
					}
				}
			}
		}
		
		/**
		 * 选择攻击一个玩家
		 * @param	e
		 */
		private function onSelectPlayer(e:Event):void 
		{
			Debug.trace("选择玩家: " + (e.target as DanDanTengPlayerItemRenderer).label);
			var player:Sprite = (e.target as DanDanTengPlayerItemRenderer).data;
			Debug.trace("对方位置:" + player.x + ", " + player.y);
			Debug.trace("你的位置:" + (_localPlayer as Sprite).x + ", " + (_localPlayer as Sprite).y);
		}
		
		private function updatePanel():void 
		{
			_panel.status = "共有" + (_players.length + 1) + "个玩家";
			_panel.setListData(_players);
		}
		
		override public function onUnActive():void {
			super.onUnActive();
			
			Debug.trace("关闭外挂");
			_panel.removeEventListener(Event.CLOSE, unactiveThisPlugin);
			_panel.removeEventListener(Event.SELECT, onSelectPlayer);
			_panel.removeEventListener("anti_invisible", onAntiInvisible);
			
			InspectorPopupManager.remove(_panel);
			_panel = null;
		}
		
		private function unactiveThisPlugin(e:Event):void 
		{
			_inspector.pluginManager.unactivePlugin(this.getPluginId());
		}
		
		/*
		private function findLocalPlayer():* {
			
		}
		*/
		
		private function findPlayers():void {
			Debug.trace("查找GamePlayer");
			//注意显示调整visible
			_players = new Array();
			for (var i:int = 0; i < this._playersContainer.numChildren; i++) {
				if (this._playersContainer.getChildAt(i) is _localPlayerClass) {
					_localPlayer = this._playersContainer.getChildAt(i) as _localPlayerClass
				}else if (this._playersContainer.getChildAt(i) is _playerClass) {
					_players.push(this._playersContainer.getChildAt(i));
				}
			}
			Debug.trace("查找到GamePlayer数目:" + _players.length + " + 1");
		}
		
		private function findPlayerContainer():DisplayObjectContainer {
			_playerClass = null;
			
			for (var i:int = 0; i < _inspector.stage.numChildren; i++) {
				var domain:ApplicationDomain = _inspector.stage.getChildAt(i).loaderInfo.applicationDomain;
				if (domain.hasDefinition(this._playerClassName)) {
					Debug.trace("找到了GamePlayer所在的程序域!");
					_playerClass = domain.getDefinition(this._playerClassName) as Class;
					_localPlayerClass = domain.getDefinition(this._localPlayerClassName) as Class;
					var scope:DisplayObjectContainer = findPlayerScopeCore(_inspector.stage.getChildAt(i) as DisplayObjectContainer);
					if (scope)return scope;
					break;
				}
			}
			
			return findPlayerScopeCore(_inspector.stage);
		}
		
		private function findPlayerScopeCore(container:DisplayObjectContainer):DisplayObjectContainer{
			var num : int = container.numChildren;
			for (var i : int = 0; i < num; i++) {
				if(_playerClass){
					if (container.getChildAt(i) is _playerClass) {
						return container;
					}else if (container.getChildAt(i) is DisplayObjectContainer) {
						var scope:DisplayObjectContainer = findPlayerScopeCore(container.getChildAt(i) as DisplayObjectContainer);
						if (scope)return scope;
					}
				}else {
					if (ClassTool.getShortClassName(container.getChildAt(i)) == "GamePlayer") {
						return container;
					}else if (container.getChildAt(i) is DisplayObjectContainer) {
						var scope:DisplayObjectContainer = findPlayerScopeCore(container.getChildAt(i) as DisplayObjectContainer);
						if (scope)return scope;
					}
				}
			}
			return null;
		}
		
		/**
		 * 小地图上的玩家位置
		 */
		private function findSmallPlayers():void {
			//SmallMapView
			//SmallPlayer
		}
	}

}