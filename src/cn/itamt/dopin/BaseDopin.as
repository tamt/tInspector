package cn.itamt.dopin {
	import OP.ObjectPool;

	import cn.itamt.dopin.DopinCanvas;
	import cn.itamt.dopin.DopinData;
	import cn.itamt.dopin.events.DopinEvent;
	import cn.itamt.dopin.events.DopinMouseEvent;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;		

	/**
	 * TODO:通过Bmd的getPixel方法来实现响应鼠标. 给每个Dopin分配一个不同的唯一的颜色.
	 * Dopin类, 位图数据类. DopinEngine的核心.
	 * @author tamt
	 */
	public class BaseDopin extends DopinEventDispatcher {
		private static var instanceNum : uint;
		private var _id : uint;

		public function get id() : uint {
			return _id;
		}

		//-----------------------------------
		protected var _x : int;

		public function set x(value : int) : void {
			_x = value;
			invalidate();
		}

		public function get x() : int {
			return _x;
		}

		protected var _y : int;

		public function set y(value : int) : void {
			_y = value;
			invalidate();
		}

		public function get y() : int {
			return _y;
		}

		protected var _rotation : Number = 0;

		//设置旋转角度
		public function set rotation(value : Number) : void {
			this._rotation = value;
			invalidate();
		}

		//返回旋转角度
		public function get rotation() : Number {
			return this._rotation;
		}

		protected var _parent : BaseDopin;

		internal function set parent(value : BaseDopin) : void {
			_parent = value;
		}

		internal function get parent() : BaseDopin {
			return _parent;
		}

		internal var bounds : Rectangle = new Rectangle;

		/**
		 * 计算矩形区域，该矩形定义相对于DopinCanvas对象坐标系的显示对象区域, 包括可能由于滤镜产生的区域(比如:发光滤镜).
		 */
		public function caculateBounds() : void {
			bounds.x = _x - _regX;
			bounds.y = _y - _regY;
			bounds.width = data.width;
			bounds.height = data.height;
		}

		/**
		 * 返回一个矩形，该矩形定义相对于DopinCanvas对象坐标系的显示对象区域, 包括可能由于滤镜产生的区域(比如:发光滤镜).
		 */
		public function getBounds() : Rectangle {
			return bounds;
		}

		/**
		 * 返回一个矩形，该矩形根据 targetCoordinateSpace 参数定义的坐标系定义显示对象的边界.
		 */
		public function getRect() : Rectangle {
			return new Rectangle(_x, _y, data.originalBmd.width, data.originalBmd.height);
		}

		protected var _regX : int;

		//注册点X.
		public function get regX() : int {
			return _regX;
		}

		protected var _regY : int;

		//注册点Y.
		public function get regY() : int {
			return _regY;
		}

		//根容器, 应该是DopinCanvas
		private var _root : DopinCanvas;

		public function get root() : DopinCanvas {
			return _root;
		}

		public function set root(canvas : DopinCanvas) : void {
			this._root = canvas;
		}

		//滤镜数组
		protected var _filters : Array;

		//设置滤镜
		public function set filters(value : Array) : void {
			_filters = value;
				
			this.data.applyFilters(_filters);
			this._regX = this.data.offsetX;
			this._regY = this.data.offsetY;
			
			invalidate();
		}

		public function get filters() : Array {
			return this._filters;
		}

		/**
		 * 按钮模式
		 */
		private var _buttonMode : Boolean;

		public function set buttonMode(value : Boolean) : void {
			_buttonMode = value;
		}

		public function get buttonMode() : Boolean {
			return _buttonMode;
		}

		/**
		 * 鼠标可用
		 */
		private var _mouseEnabled : Boolean;

		public function set mouseEnabled(value : Boolean) : void {
			_mouseEnabled = value;
		}

		public function get mouseEnabled() : Boolean {
			return _mouseEnabled;
		}

		/**
		 * 子对象鼠标可用
		 */
		private var _mouseChildren : Boolean;

		public function set mouseChildren(value : Boolean) : void {
			_mouseChildren = value;
		}

		public function get mouseChildren() : Boolean {
			return _mouseChildren;
		}

		//-----------------------------------

		internal var data : DopinData;
		internal var oldState : DopinState;

		public function BaseDopin(dopinData : DopinData) : void {
			data = dopinData;
			childs = new Vector.<BaseDopin>;
			
			_id = ++instanceNum;
			
			this.mouseChildren = true;
			this.mouseEnabled = false;
			
			//初始化一些参数
			this.overEvent = new DopinMouseEvent(this, MouseEvent.ROLL_OVER, false, true);			this.outEvent = new DopinMouseEvent(this, MouseEvent.ROLL_OUT, false, true);			this.clickEvent = new DopinMouseEvent(this, MouseEvent.CLICK, false, true);			this.moveEvent = new DopinMouseEvent(this, MouseEvent.MOUSE_MOVE, false, true);
		}

		private var childs : Vector.<BaseDopin>;
		private var _numChildren : uint;

		public function get numChildren() : uint {
			return this._numChildren;
		}

		/**
		 * 往dopin里添加另外一张dopin
		 */
		public function addChild(child : BaseDopin) : BaseDopin {
			if(childs.indexOf(child) < 0) {
				addChilddAt(child, _numChildren);
			}
			
			return child;
		}

		/**
		 * 从dopin中删除一张dopin
		 */
		public function removeChild(child : BaseDopin) : BaseDopin {
			var index : int = childs.indexOf(child);
			if(index >= 0) {
				this.removeChildAt(index);
			}
			
			return child;
		}

		public function addChilddAt(child : BaseDopin, index : uint) : BaseDopin {
			if(index > _numChildren) {
				throw new Error('超出childs的索引范围');
			} else {
				childs.splice(index, 0, child);
				_numChildren = childs.length;
				child.parent = this;
				child.root = this.root;
				if(child.root)child.onAddedStage();
				
				invalidate();
			}
			return child;
		}

		public function removeChildAt(index : uint) : BaseDopin {
			if(index >= _numChildren) {
				throw new Error('超出childs的索引范围');
				return null;
			} else {
				var child : BaseDopin = childs[index];
				childs.splice(index, 1);
				_numChildren = childs.length;
				child.onRemove();
				child.parent = null;
				child.root = null;
				child.onRemovedStage();
				return child;
			}
		}

		//第一种渲染模式, version:机制:只擦除/重绘有更新的区域, 方法没错, 但效率底下.
		internal function smartRender(child : BaseDopin = null) : void {
			if(child == null)child = this;
			if(this._parent) {
				this._parent.smartRender(child);
			} else {
				data.bmd.lock();
				var nextChild : BaseDopin;
				var i : int = 0;
				for each(var dopin : BaseDopin in childs) {
					if(!dopin.needRender)continue;
					var rect : Rectangle = ObjectPool.getObject(Rectangle);
							
					//清除旧有的绘制.
					if(dopin.needClearWhenRender) {
						if(dopin.oldState) {
							data.bmd.copyPixels(data.originalBmd, dopin.oldState.bounds, dopin.oldState.bounds.topLeft);
							for( i = 0;i < _numChildren; i++) {
								nextChild = childs[i];
								if(nextChild != child) {
									rect.x = dopin.oldState.bounds.x;									rect.y = dopin.oldState.bounds.y;									rect.width = dopin.oldState.bounds.width;									rect.height = dopin.oldState.bounds.height;
									//需要旋转的
									if(dopin.rotation != 0) {
										//	data.bmd.unlock();
										//										var rotateBmd : BitmapData = new BitmapData(50,50);
										//										var matrix:Matrix = new Matrix();
										//										matrix.rotate(dopin.rotation);
										//										data.bmd.draw(data.bmd);
										////										data.bmd.
										//										//data.setBmd(rotateBmd);
										//										data.bmd.lock();
										var bmp : Bitmap = new Bitmap(data.bmd);
										bmp.rotation = dopin.rotation;
										data.setBmd(bmp.bitmapData);
									}
									//								data.bmd.copyPixels(nextChild.data.bmd, nextChild.parentToLocalRect(rect), rect.topLeft, null, null, true);									data.bmd.copyPixels(nextChild.data.bmd, nextChild.parentToLocalRect(rect), dopin.oldState.bounds.topLeft, null, null, true);
								}
							}
						}
					}
							
					//绘制
					dopin.caculateBounds();
					data.bmd.copyPixels(data.originalBmd, dopin.bounds, dopin.bounds.topLeft);
					for(i = 0;i < _numChildren; i++) {
						nextChild = childs[i];
								
						rect.x = dopin.bounds.x;
						rect.y = dopin.bounds.y;
						rect.width = dopin.bounds.width;
						rect.height = dopin.bounds.height;
						
						data.bmd.copyPixels(nextChild.data.bmd, nextChild.parentToLocalRect(rect), dopin.bounds.topLeft, null, null, true);
					}
					
					ObjectPool.disposeObject(rect, Rectangle);
					//
					dopin.updateOldState();
					dopin.needRender = false;
					dopin.needClearWhenRender = true;
				}
				data.bmd.unlock();
			}
		}

		//第二种渲染模式, version:机制:只要某个dopin有更新,即重绘整张位图.
		internal function totalRender(child : BaseDopin = null) : void {
			if(child == null)child = this;
			if(this._parent) {
				this._parent.totalRender(child);
			} else {
				for each(var dopin : BaseDopin in childs) {
					if(dopin.needRender) {
						data.bmd.lock();
								
						var rect : Rectangle = ObjectPool.getObject(Rectangle);
								
						//清除前面的绘制
						data.bmd.copyPixels(data.originalBmd, data.originalBmd.rect, data.originalBmd.rect.topLeft);
							
						//重新绘制.
						var nextChild : BaseDopin;
						for(var i : int = 0;i < _numChildren; i++) {
							nextChild = childs[i];
							nextChild.caculateBounds();
							rect.x = nextChild.bounds.x;
							rect.y = nextChild.bounds.y;
							rect.width = nextChild.bounds.width;
							rect.height = nextChild.bounds.height;
							data.bmd.copyPixels(nextChild.data.bmd, nextChild.parentToLocalRect(rect), nextChild.bounds.topLeft, null, null, true);
							nextChild.updateOldState();
							nextChild.needRender = false;
						}
							
						ObjectPool.disposeObject(rect, Rectangle);
						data.bmd.unlock();
		
						break;
					}
				}
			}
		}

		public function parentToLocalRect(rect : Rectangle) : Rectangle {
			rect.x = rect.x - (x - regX);
			rect.y = rect.y - (y - regY);
			return rect;
//			return new Rectangle(rect.x - (x - regX), rect.y - (y - regY), rect.width, rect.height);
		}

		public function parentToLocal(pt : Point) : Point {
			return new Point(pt.x - (x - regX), pt.y - (y - regY));
		}

		public function dispose() : void {
			data.dispose();
			
			this.dispose();
		}

		public function updateOldState() : void {
			if(oldState == null) {
				oldState = new DopinState();
			}
			oldState.copyFrom(this);
		}

		internal var needRender : Boolean = false;
		internal var needClearWhenRender : Boolean = true;

		/**
		 * 需要重新渲染.
		 * @param clear		是否需要精确清除之前的绘制, 一些没有变形或位移的更新并不需要精确清除之前的绘制, 例如, 只是对Dopin应用了灰度滤镜(没有改变duopin的大小,位置).
		 */
		protected function invalidate(clear : Boolean = true) : void {
			if(needRender)return;
			needRender = true;
			needClearWhenRender = clear;
			if(this.root) {
				this.root.invalidate();
			}
		}

		
		
		
		
		//-------------------------------------
		//--------------显示对象事件----------------
		//-------------------------------------
		internal function checkAddedStage(evt : Event = null) : void {
			this._root = evt.target as DopinCanvas;
			if(this.numChildren) {
				for each(var child : BaseDopin in childs) {
					child._root = this._root;
					child.invalidate();
					child.onAddedStage(evt);
				}
			} else {
				this.invalidate();
			}
			this.onAddedStage(evt);
		}

		internal function onAddedStage(evt : Event = null) : void {
			dispatchEvent(new DopinEvent(this, Event.ADDED_TO_STAGE));
		}

		internal function checkRemovedStage(evt : Event = null) : void {
			this._root = null;
			for each(var child : BaseDopin in childs) {
				child._root = null;
				child.onRemovedStage(evt);
			}
			this.onRemovedStage(evt);
		}

		internal function onRemovedStage(evt : Event = null) : void {
			dispatchEvent(new DopinEvent(this, Event.REMOVED_FROM_STAGE));
		}

		/**
		 * 被删除处Dopin显示列表之前.
		 */
		internal function onRemove(evt : Event = null) : void {
		}

		/**
		 * 相当于onEnterFrame事件.
		 */
		internal function onTick(evt : Event) : void {
		}

		//-------------------------------------
		//-------------------------------------
		
		
		
		
		
		
		
		
		//-------------------------------------
		//--------------鼠标事件------------------
		//-------------------------------------

		internal function checkMouseMove(evt : MouseEvent) : void {
			var root : DopinCanvas = evt.target as DopinCanvas;
			if(this._mouseChildren) {
				var child : BaseDopin;
				var i : int = numChildren;
				while(i--) {
					child = childs[i];
					if(child._mouseEnabled && child.getRect().contains(evt.localX, evt.localY)) {
						child.onMouseMove(evt);
						if(child != root.curMouseOn) {
							if(root.curMouseOn) {
								root.curMouseOn.onRollOut(evt);
							}
							root.curMouseOn = child;
							root.curMouseOn.onRollOver(evt);
						}
						return;
						break;
					}
				}
			}
			
			if(this.getRect().contains(evt.localX, evt.localY)) {
				if(this._mouseEnabled) { 
					onMouseMove(evt);
					if(this != root.curMouseOn) {
						if(root.curMouseOn)root.curMouseOn.onRollOut(evt);
						root.curMouseOn = this;
						root.curMouseOn.onRollOver(evt);
					}
				} else {
					if(root.curMouseOn) {
						root.curMouseOn.onRollOut(evt);
						root.curMouseOn = null;
					}
				}
			}
		}

		internal function checkRollOver(evt : MouseEvent) : void {
			this.onRollOver(evt);
		}

		internal function checkRollOut(evt : MouseEvent) : void {
			this.onRollOut(evt);
		}

		internal function checkClick(evt : MouseEvent) : void {
			if(this._mouseChildren) {
				for each(var child : BaseDopin in childs) {
					if(child._mouseEnabled && child.getRect().contains(evt.localX, evt.localY)) {
						child.onClick(evt);
						return;
						break;
					}
				}
			}
			
			if(this._mouseEnabled && this.getRect().contains(evt.localX, evt.localY)) {
				this.onClick(evt);
			}
		}

		private var moveEvent : DopinMouseEvent;

		internal function onMouseMove(evt : MouseEvent) : void {
			moveEvent = new DopinMouseEvent(this, MouseEvent.MOUSE_MOVE);
			moveEvent.copyPropertiesFrom(evt);
			dispatchEvent(moveEvent);
		}

		private var overEvent : DopinMouseEvent;

		internal function onRollOver(evt : MouseEvent) : void {
			if(this._buttonMode) {
				Mouse.cursor = MouseCursor.BUTTON;
			}
			overEvent = new DopinMouseEvent(this, MouseEvent.ROLL_OVER);
			overEvent.copyPropertiesFrom(evt);
			dispatchEvent(overEvent as DopinMouseEvent);
		}

		private var outEvent : DopinMouseEvent;

		internal function onRollOut(evt : MouseEvent) : void {
			if(this._buttonMode) {
				Mouse.cursor = MouseCursor.AUTO;
			}
			outEvent = new DopinMouseEvent(this, MouseEvent.ROLL_OUT);
			outEvent.copyPropertiesFrom(evt);

			dispatchEvent(outEvent as DopinMouseEvent);
		}

		private var clickEvent : DopinMouseEvent;

		internal function onClick(evt : MouseEvent) : void {
			clickEvent = new DopinMouseEvent(this, MouseEvent.CLICK);
			clickEvent.copyPropertiesFrom(evt);
			dispatchEvent(clickEvent);
		}

		//-------------------------------------
		
		
		
		//-------------------------------------
		//----------------[扩展功能, 方便外部操作]---------------
		//-------------------------------------

		/**
		 * 把所有的子Dopin的位置摆乱.		 * 主要用于测试.
		 */
		public function litterDopins() : void {
			for(var i : int = 0;i < numChildren; i++) {
				childs[i].x = Math.random() * this.data.width;
				childs[i].y = Math.random() * this.data.height;
			}
		}
	}
}
