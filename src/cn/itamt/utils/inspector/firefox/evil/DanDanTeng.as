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
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import cn.itamt.utils.inspector.firefox.evil.DanDanTengIcon;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import msc.input.KeyCode;
	
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
		private var _localPlayer:Sprite;
		//当前风力值
		private var _wind:Number;
		//风向, -1 <- . -> 1
		private var _windDirection:int;
		//发射角度
		private var _angle:Number;
		
		private var _windRatios:Array = new Array;
		private var _gs:Array = new Array;
		
		public function DanDanTeng() 
		{
		}
		
		override public function contains(child:DisplayObject) : Boolean {
			if (super.contains(child)) {
				return true;
			}
			
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
				
				_panel.setListData(_players);
				this.updatePanel();
			}else {
				Debug.trace("查找GamePlayer所在容器:失败");
			}
			
			InspectorPopupManager.popup(_panel, PopupAlignMode.CENTER);
			
			//轨迹线容器
			this.viewContainer = new Sprite();
			//_inspector.stage.addChild(this.viewContainer);
			
			//侦听键盘事件
			_inspector.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, int.MIN_VALUE);
		}
		
		/**
		 * 侦听键盘事件
		 * @param	e
		 */
		private function onKeyUp(e:KeyboardEvent):void 
		{
			//释放空格键时
			if (e.keyCode == KeyCode.SPACEBAR) {
				//
				var energy:Number = findEnergyValue();
				Debug.trace("力度值: " + energy);
				//重新取得风力及角度
				this.findVaneValue();
				this.findAngleValue();
				//画出轨迹线
				//this.drawTrajectory(new Point(_localPlayer.x, _localPlayer.y), new Point(player.x, player.y));
				
				this.updatePanel();
				
				var time:int = getTimer();
				_inspector.stage.addEventListener(MouseEvent.MOUSE_UP, function(evt:MouseEvent) {
						_inspector.stage.removeEventListener(MouseEvent.MOUSE_UP, arguments.callee);
						//
						//var t:Number = ((getTimer() - time) / 1000);
						var t:Number = getTimer() - time;
						Debug.trace("时间:" + t);
						var bomb:DisplayObject = ClassTool.findDisplayObjectInstaceByClassName(_inspector.stage, "SimpleBomb");
						if (bomb) {
							var bombPos:Point = bomb.localToGlobal(new Point());
							var localPos:Point = _localPlayer.localToGlobal(new Point());
							//var dx:Number = (bomb.x - _localPlayer.x);
							//var dy:Number = (bomb.y - _localPlayer.y);
							var dx:Number = (bombPos.x - localPos.x);
							var dy:Number = (bombPos.y - localPos.y);
							
							var theta:Number = (_direction == -1?_angle:(180 - _angle)) * Math.PI / 180;
							Debug.trace("炸弹位移: " + dx + ", " + dy);
							
							//计算这次采样取得的风力乘值.
							var windRatio:Number = 2 * (dx - energy * Math.cos(theta) * t) / (_wind * _windDirection * t * t);
							//计算所有采样风力乘值的平均值.
							_windRatios.push(windRatio);
							var wrSum:Number = 0;
							for each(var num:Number in _windRatios) {
								wrSum += num;
							}
							//Debug.trace("风力乘值: " + wrSum / _windRatios.length);
							Debug.trace("风力乘值: " + windRatio);
							
							var g:Number = 2 * (dy + energy * Math.sin(theta) * t) / (t * t);
							_gs.push(g);
							var gSum:Number = 0;
							for each(var gNum:Number in _gs) {
								gSum += gNum;
							}
							//Debug.trace("重力加速度: " + gSum / _gs.length);
							Debug.trace("重力加速度: " + g);
						}
					} );
			}
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
			
			if (player) {
				Debug.trace("对方位置:" + player.x + ", " + player.y);
				Debug.trace("你的位置:" + _localPlayer.x + ", " + _localPlayer.y);
				
				//重新取得风力及角度
				this.findVaneValue();
				this.findAngleValue();
				//画出轨迹线
				this.drawTrajectory(new Point(_localPlayer.x, _localPlayer.y), new Point(player.x, player.y));
			}
		}
		
		/**
		 * 画弹道
		 */
		private function drawTrajectory(startPt:Point, endPt:Point):void 
		{
			if (!_localPlayer.parent.contains(viewContainer))_localPlayer.parent.addChild(viewContainer);
			_localPlayer.parent.setChildIndex(viewContainer, _localPlayer.parent.numChildren - 1);
			
			viewContainer.graphics.clear();
			viewContainer.graphics.lineStyle(5, 0x99cc00, 1);
			viewContainer.graphics.moveTo(startPt.x, startPt.y);
			
			//推算初始速度值
			var theta:Number = (_direction == -1?_angle:(180 - _angle)) * Math.PI / 180;
			var f:Number = _windDirection * _wind / 4;
			var g:Number = 0.15;
			var A:Number = endPt.x - startPt.x;
			var B:Number = endPt.y - startPt.y;
			var C:Number = Math.cos(theta);
			var D:Number = -Math.sin(theta);
			var E:Number = .5 * f;
			var F:Number = .5 * g;
			var G:Number = (A * D - B * C) / (B * E-A * F);
			//求出speed的值
			//speed.value = Math.sqrt(A / (C * G + E * G * G));
			var speed:Number = (Math.sqrt(A / (C * G + E * G * G)) + Math.sqrt(B / (D * G + F * G * G))) / 2;
			
			Debug.trace("计算所得的力度:" + speed);
			
			//画线
			var finish:Boolean = false;
			var t:int = 0;
			var topest:Boolean = false;
			var lx:Number, ly:Number;
			while (!finish) {
				var xt:Number = speed * Math.cos(theta) * t + .5 * f * t * t + startPt.x;
				var yt:Number = -speed * Math.sin(theta) * t + .5 * g * t * t + startPt.y;
				//trace(xt, yt);
				
				if (!topest && !isNaN(lx) && !isNaN(ly)) {
					if (yt > ly)topest = true;
				}
				
				t++;
				
				if (t > 200) {
					finish = true;
				}
				
				if (topest && yt>endPt.y) {
					finish = true;
				}
				
				viewContainer.graphics.lineTo(xt, yt);
				
				lx = xt;
				ly = yt;
			}
		}
		
		private function updatePanel():void 
		{
			//_panel.status = "共有" + (_players.length + 1) + "个玩家";
			_panel.status = "风力:" + (_wind * _windDirection) + ",角度:" + (_angle*_direction) + "°";
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
			
			//轨迹线容器
			if(this.viewContainer && this.viewContainer.parent)this.viewContainer.parent.removeChild(this.viewContainer);
			this.viewContainer = null;
			
			//去除键盘事件侦听
			_inspector.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, int.MIN_VALUE);
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
			if (_gameViewClass == null) return null;
			
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
					_localPlayer = this._playersContainer.getChildAt(i) as Sprite;
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
					var gradientText:DisplayObjectContainer = ClassTool.findDisplayObjectInstaceByClassName(vaneView, "GradientText") as DisplayObjectContainer;
					if (gradientText) {
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
					var tmp:DisplayObject = ClassTool.findDisplayObjectInstaceByClassName(vaneView, "vaneAsset");
					if(tmp){
						_windDirection = tmp.scaleX > 0?1: -1;
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
					var gradientText:DisplayObjectContainer = ClassTool.findDisplayObjectInstaceByClassName(arrowView, "GradientText") as DisplayObjectContainer;
					if (gradientText) {
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
		
		private function findEnergyValue():Number {
			var energyView:DisplayObjectContainer = ClassTool.findDisplayObjectInstaceByClassName(_inspector.stage, "EnergyView") as DisplayObjectContainer;
			if (energyView) {
				var bar:DisplayObject = energyView.getChildAt(2);
				if (bar) return bar.width;
			}
			
			return NaN;
		}
	}
}