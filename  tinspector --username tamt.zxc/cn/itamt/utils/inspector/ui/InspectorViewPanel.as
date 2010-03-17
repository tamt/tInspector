package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.DisplayObjectTool;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;	

	/**
	 * Inspector的ui面板类
	 * @author itamt@qq.com
	 */
	public class InspectorViewPanel extends Sprite {
		protected var _padding : Padding = new Padding(33, 10, 10, 10);
		protected var bg : Sprite;
		protected var _title : TextField;

		protected var _width : Number;
		protected var _height : Number;

		protected var _contentContainer : Sprite;
		protected var _content : DisplayObject;
		protected var _scroller : InspectorScroller;

		protected var closeBtn : InspectorViewCloseButton;
		protected var resizeBtn : InspectorViewResizeButton;

		protected var _resizer : ResizerButton;
		protected var _virtualResizer : Sprite;

		private var autoDispose : Boolean;

		//最小尺寸
		protected var _minW : Number = 180, _minH : Number = 160;

		public function InspectorViewPanel(title : String = '面板', w : Number = 200, h : Number = 200, autoDisposeWhenRemove : Boolean = true) {
			autoDispose = autoDisposeWhenRemove;
			
			bg = new Sprite();
			addChild(bg);
			
			bg.filters = [new GlowFilter(0x0, 1, 16, 16, 1)];			//			bg.filters = [new GlowFilter(0x333333, 1, 16, 16, 1)];

			_virtualResizer = new Sprite();
			_resizer = new ResizerButton(15, 15);
			addChild(_resizer);
			
			_title = InspectorTextField.create(title, 0x99cc00, 12);
			//			_title.textColor = 0x999999;
			//			_title.htmlText = '<font size="16">' + title + '</font>';
			_title.selectable = false;
			_title.height = 20;
			addChild(_title);
			
			_contentContainer = new Sprite();
			addChild(_contentContainer);
			
			closeBtn = new InspectorViewCloseButton();
			closeBtn.addEventListener(MouseEvent.CLICK, onClickClose);
			addChild(closeBtn);
			
			resizeBtn = new InspectorViewResizeButton();
			resizeBtn.addEventListener(MouseEvent.CLICK, onClickResize);
			addChild(resizeBtn);
			
			_width = w > _minW ? w : _minW;
			_height = h > _minH ? h : _minH;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}

		private var inited : Boolean;

		private function onAdded(evt : Event) : void {
			if(evt.target == this) {
				if(inited)return;
				inited = true;
				bg.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseup);
				
				this._resizer.addEventListener(MouseEvent.MOUSE_DOWN, onDownResizer);
				
				this.relayout();
			}
		}

		private function onRemoved(evt : Event) : void {
			if(evt.target == this) {
				inited = false;
				bg.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);		
				this.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseup);		
				
				this._resizer.removeEventListener(MouseEvent.MOUSE_DOWN, onDownResizer);
				this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMoveResizer);
				
				this.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
				
				if(autoDispose) {
					this.dispose();
				}
			}
		}

		private function onDownResizer(evt : MouseEvent) : void {
			this._virtualResizer.x = mouseX;
			this._virtualResizer.y = mouseY;
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMoveResizer);
			this._virtualResizer.startDrag(false);
		}

		protected function onMoveResizer(evt : MouseEvent) : void {
			this.resize(this._virtualResizer.x, this._virtualResizer.y);
		}

		protected function onMouseDown(evt : MouseEvent) : void {
			this.cacheAsBitmap = true;
			this.startDrag(false);
			
			DisplayObjectTool.swapToTop(this);
		}

		protected function onMouseup(evt : MouseEvent) : void {
			this.cacheAsBitmap = false;
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMoveResizer);
			this.stopDrag();
			this._virtualResizer.stopDrag();
		}

		/**
		 * 设置面板的显示内容
		 */
		public function setContent(content : DisplayObject) : void {
			if(content == _content) {
				if(inited)this.relayout();
			} else {
				if(_content) {
					_content.removeEventListener(Event.RESIZE, onContentResize);
					_contentContainer.removeChild(_content);
				}
				_content = content;
				_content.addEventListener(Event.RESIZE, onContentResize, false, 0, true);
				_contentContainer.x = this._padding.left;
				_contentContainer.y = this._padding.top;
				_contentContainer.scrollRect = new Rectangle(0, 0, calculateContenAreaWidth(), this.calculateContenAreaHeight());
				_contentContainer.addChild(_content);
				
				if(inited)this.relayout();
			}
		}

		public function resize(w : Number, h : Number) : void {
			_width = w > _minW ? w : _minW;
			_height = h > _minH ? h : _minH;
			
			this.relayout();
		}

		public function relayout() : void {
			//			_width = _width > _minW ? _width : _minW;
			//			_height = _height > _minH ? _height : _minH;

			drawBG();
			if(_content)drawContent();
			
			_virtualResizer.x = _resizer.x = _width;
			_virtualResizer.y = _resizer.y = _height;
			
			closeBtn.x = this._width - 5 /*this._padding.right*/ - closeBtn.width;
			closeBtn.y = 5;
			
			resizeBtn.x = closeBtn.x - resizeBtn.width;
			resizeBtn.y = 5;
			
			this.drawTitle();
		}

		protected function drawTitle() : void {
			_title.x = _padding.left;
			_title.y = 7;
			
			_title.width = _title.textWidth + 4;
			if(_title.width > resizeBtn.x - _padding.left)_title.width = resizeBtn.x - _padding.left;
		}

		/**
		 * 绘制内容
		 */
		private function drawContent() : void {
			var rect : Rectangle = _contentContainer.scrollRect;
			if(needHScroller()) {
				if(_scroller == null) {
					_scroller = new InspectorScroller(15, this.calculateContenAreaHeight());
					_scroller.y = _padding.top;
					
					_scroller.addEventListener(Event.CHANGE, onScroll);
					this.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
				} else {
					_scroller.resize(15, this.calculateContenAreaHeight());
				}
				
				_scroller.x = _width - _padding.right - _scroller.width;
				
				addChild(_scroller);
				
				_contentContainer.scrollRect = new Rectangle(rect.x, calculateScrollRectY(), calculateContenAreaWidth() - _scroller.width, this.calculateContenAreaHeight());
			} else {
				_contentContainer.scrollRect = new Rectangle(rect.x, 0, calculateContenAreaWidth(), this.calculateContenAreaHeight());
				if(_scroller) {
					if(_scroller.stage)removeChild(_scroller);
					this.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
					_scroller.removeEventListener(Event.CHANGE, onScroll);
					_scroller = null;
				}
			}
		}

		/**
		 * 绘制背景
		 */
		private function drawBG() : void {
			this.bg.graphics.clear();
			this.bg.graphics.lineStyle(2, 0x666666);
			this.bg.graphics.beginFill(InspectorColorStyle.DEFAULT_BG/*, .95*/);
			this.bg.graphics.drawRoundRect(0, 0, this._width, this._height, 15, 15);
			this.bg.graphics.endFill();
		}

		/**
		 * 当内容的尺寸发生改变时
		 */
		private function onContentResize(evt : Event) : void {
			this.relayout();
		}

		private function onScroll(evt : Event = null) : void {
			//			trace(_scroller.value);
			var rect : Rectangle = _contentContainer.scrollRect;
			rect.y = calculateScrollRectY();
			//			rect.y = _scroller.value; 
			//			trace(_content.height);
			_contentContainer.scrollRect = rect;
		}

		/**
		 * 显示内容的某个区域
		 */
		public function showContentArea(rect : Rectangle) : void {
			if(_contentContainer.scrollRect.containsRect(rect))return;
			var v : Number = 100 * (rect.bottom) / (_content.height);
			if(v < 0)v = 0;
			if(v > 100)v = 100;
			if(this._scroller)this._scroller.value = v;
			this.onScroll();
		}

		/**
		 * 显示内容是否需要水平滚动条
		 */
		private function needHScroller() : Boolean {
			return _content.height - calculateContenAreaHeight() > 0;
		}

		/**
		 * TODO:显示内容是否需要垂直滚动条
		 */
		private function needVScroller() : Boolean {
			return false;
		}

		/**
		 * 鼠标滚动
		 */
		private function onMouseWheel(evt : MouseEvent) : void {
			if(_content) {
				var rect : Rectangle = _contentContainer.scrollRect;
				rect.y += evt.delta < 0 ? 20 : -20;
				if(rect.y < 0)rect.y = 0;
				var t : Number = _content.height - calculateContenAreaHeight();
				if(rect.y > t)rect.y = t;
				_contentContainer.scrollRect = rect;
				if(_scroller)_scroller.value = 100 * rect.y / t;
			}
		}

		/**
		 * 计算滚动矩形区域的y
		 */
		private function calculateScrollRectY() : Number {
			if(_scroller) {
				return (_scroller.value / 100) * (_content.height - calculateContenAreaHeight());
			} else {
				return 0; 
			}
		}

		private function calculateContenAreaHeight() : Number {
			return (this._height - _padding.top - _padding.bottom);
		}

		private function calculateContenAreaWidth() : Number {
			return (this._width - _padding.left - _padding.right);
		}

		protected function onClickClose(evt : Event) : void {
			evt.stopImmediatePropagation();
			
			dispatchEvent(new Event(Event.CLOSE));
		}

		private function onClickResize(evt : Event) : void {
			evt.stopImmediatePropagation();
			
			if(resizeBtn.normalMode) {
				open();
				dispatchEvent(new Event(Event.CANCEL));
			} else {
				hide();
				dispatchEvent(new Event(Event.OPEN));
			}
		}

		/**
		 * 展开面板
		 */
		public function open() : void {
			if(isNaN(_lw)) {
				_lw = 200;	
			}
			if(isNaN(_lh)) {
				_lh = 200;
			}
			
			addChild(_contentContainer);
			addChild(_resizer);
			
			this._width = _lw;
			this._height = _lh;
			this.relayout();
			
			if(_scroller)_scroller.visible = true;
		}

		private var _lw : Number = NaN, _lh : Number = NaN;

		/**
		 * 折叠面板
		 */
		public function hide() : void {
			_lw = _width;
			_lh = _height;
			
			if(_contentContainer.stage)_contentContainer.parent.removeChild(_contentContainer);
			if(_resizer.stage)_resizer.parent.removeChild(_resizer);
			
			this._height = 33;
			this.relayout();
			
			if(_scroller)_scroller.visible = false;
		}

		/**
		 * 销毁
		 */
		public function dispose() : void {
			while(this.numChildren) {
				this.removeChildAt(0);
			}
		}
	}
}
