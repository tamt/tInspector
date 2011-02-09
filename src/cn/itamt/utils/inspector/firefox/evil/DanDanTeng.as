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
	import flash.text.TextField;
	
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
		
		//风力
		private var _vaneViewClass:Class;
		private var _vaneViewClassName:String = "game.view.VaneView";
		//风向
		private var _vaneDirectClass:Class;
		private var _vaneDirectClassName:String = "asset.game.vaneAsset";
		
		//角度
		private var _arrowViewClass:Class;
		private var _arrowViewClassName:String = "game.view.arrow.ArrowView";
		//发射方向, 1 <- . -> -1
		private var _direction:int;
		
		//游戏主容器, GameView
		private var _gameViewClass:Class;
		private var _gameViewClassName:String = "game.view.GameView";
		private var _gameView:DisplayObjectContainer;
		
		private var _players:Array;
		private var _localPlayer:*;
		//当前风力值
		private var _wind:Number;
		//风向, -1 <- . -> 1
		private var _windDirection:int;
		//发射角度
		private var _angle:Number;
		
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
			
			_gameView = this.findGameView();
			_playersContainer = findPlayerContainer();
			if (_playersContainer) {
				Debug.trace("查找GamePlayer所在容器:成功");
				this.findPlayers();
				this.findVaneValue();
				this.findAngleValue();
				this.updatePanel();
			}else {
				Debug.trace("查找GamePlayer所在容器:失败");
			}
			
			InspectorPopupManager.popup(_panel, PopupAlignMode.CENTER);
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
					(_players[i] as DisplayObject).alpha = 1;
					//if (!(_players[i] as DisplayObject).visible) {
						//Debug.trace("找到一个玩家隐身");
						(_players[i] as DisplayObject).visible = true;
						//查找其字对象中visible为false
						var container:DisplayObjectContainer = (_players[i] as DisplayObjectContainer);
						for (var j:int = 0; j < container.numChildren; j++) {
							container.getChildAt(i).visible = true;
							container.getChildAt(i).alpha = 1;
						}
					//}
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
		private function findGameView():DisplayObjectContainer 
		{
			Debug.trace("查找GameView");
			for (var i:int = 0; i < _inspector.stage.numChildren; i++) {
				var domain:ApplicationDomain = _inspector.stage.getChildAt(i).loaderInfo.applicationDomain;
				if (domain.hasDefinition(this._gameViewClassName)) {
					_gameViewClass = domain.getDefinition(this._gameViewClassName) as Class;
					var scope:DisplayObjectContainer = ClassTool.findDisplayObjectInstaceByClass(_inspector.stage.getChildAt(i) as DisplayObjectContainer, _gameViewClass) as DisplayObjectContainer;
					if (scope)return scope;
					break;
				}
			}
			
			return ClassTool.findDisplayObjectInstaceByClass(_inspector.stage, _gameViewClass) as DisplayObjectContainer;
		}
		
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
					_gameView = _inspector.stage.getChildAt(i) as DisplayObjectContainer;
					Debug.trace("找到游戏的根容器");
					Debug.trace("找到了GamePlayer所在的程序域!");
					_playerClass = domain.getDefinition(this._playerClassName) as Class;
					_localPlayerClass = domain.getDefinition(this._localPlayerClassName) as Class;
					_vaneViewClass = domain.getDefinition(this._vaneViewClassName) as Class;
					_arrowViewClass = domain.getDefinition(this._arrowViewClassName) as Class;
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
		
		/**
		 * 返回当前风力值
		 * @return
		 */
		private function findVaneValue():void {
			_wind = NaN;
			Debug.trace("查找VaneValue");
			if (_gameView) {
				var vaneView:DisplayObjectContainer = ClassTool.findDisplayObjectInstaceByClass(_inspector.stage, _vaneViewClass) as DisplayObjectContainer;
				if (vaneView) {
					Debug.trace("找到VaneView对象");
					var gradientText:DisplayObjectContainer = ClassTool.findDisplayObjectInstaceByClassName(vaneView, "GradientText") as DisplayObjectContainer;
					if (gradientText) {
						Debug.trace("找到VaneView.GradientText对象");
						//var vaneText:DisplayObject = ClassTool.findDisplayObjectInstaceByClassName(vaneView, "FilterFrameText");
						//if (vaneText) {
							//Debug.trace("找到VaneView.GradientText.FilterFrameText对象");
						_wind = Number(gradientText["text"]);
						Debug.trace("当前风力值: " + _wind);
						//}else {
							//Debug.trace("没找到VaneView.GradientText对象");
						//}
					}else {
						Debug.trace("没找到VaneView.GradientText对象");
					}
					
					//取得风向
					var direction:DisplayObject = ClassTool.findDisplayObjectInstaceByClassName(vaneView, "GradientText");
					if(direction){
						_windDirection = direction.scaleX > 0?1: -1;
						Debug.trace("当前风向: " + _windDirection);
					}else {
						Debug.trace("没找到VaneView.vaneAsset对象");
					}
				}else {
					Debug.trace("没找到VaneView对象");
				}
				
			}else {
				Debug.trace("_root为空");
			}
		}
		
		/**
		 * 取得发射角度
		 */
		private function findAngleValue():void {
			_angle = NaN;
			if (_gameView) {
				var arrowView:DisplayObjectContainer = ClassTool.findDisplayObjectInstaceByClass(_inspector.stage, _arrowViewClass) as DisplayObjectContainer;
				if (arrowView) {
					Debug.trace("找到arrowView对象: " + arrowView.name);
					var gradientText:DisplayObjectContainer = ClassTool.findDisplayObjectInstaceByClassName(arrowView, "GradientText") as DisplayObjectContainer;
					if (gradientText) {
						Debug.trace("找到ArrowView.GradientText对象: " + gradientText.name);
						//var vaneText:DisplayObject = ClassTool.findDisplayObjectInstaceByClassName(vaneView, "FilterFrameText");
						//if (vaneText) {
							//Debug.trace("找到VaneView.GradientText.FilterFrameText对象");
						_angle = Number(gradientText["text"]);
						Debug.trace("当前角度值: " + _angle);
						//}else {
							//Debug.trace("没找到VaneView.GradientText对象");
						//}
						
						//取得发射方向
						//_direction
						var character:DisplayObject = ClassTool.findDisplayObjectInstaceByClassName(_localPlayer, "GameCharacter");
						if (character) {
							_direction = character.parent.scaleX;
							Debug.trace("当前发射方向: " + _direction);
						}else {
							Debug.trace("获取发射方向失败");
						}
					}else {
						Debug.trace("没找到ArrowView.GradientText对象");
					}
				}else {
					Debug.trace("没找到ArrowView对象");
				}
			}else {
				Debug.trace("_root为空");
			}
		}
	}
}