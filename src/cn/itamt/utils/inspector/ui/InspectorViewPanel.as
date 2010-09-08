package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.DisplayObjectTool;

	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.JointStyle;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 * Inspector的ui面板类
	 * TODO:增加水平方向的滚动条支持
	 * @author itamt@qq.com
	 */
	public class InspectorViewPanel extends Sprite {
		protected var _padding : Padding = new Padding(33, 10, 10, 10);

		public function set padding(val : Padding) : void {
			_padding = val;
			
			if(this.inited)this.relayout();
		}

		public function get padding() : Padding {
			return _padding;
		}

		protected var bg : Sprite;
		protected var _title : TextField;

		protected var _width : Number;

		override public function get width() : Number {
			return _width;
		}

		protected var _height : Number;

		protected var _contentContainer : Sprite;
		protected var _content : DisplayObject;
		protected var _scroller : InspectorScroller;

		protected var closeBtn : InspectorViewCloseButton;
		protected var resizeBtn : InspectorViewResizeButton;

		protected var _resizer : ResizerButton;
		protected var _virtualResizer : Sprite;

		private var autoDispose : Boolean;

		//		protected var _useEff : Boolean;
		//		protected var _eff : WobbleEffect;

		//最小尺寸
		protected var _minW : Number = 180, _minH : Number = 160;

		public function set minW(num : Number) : void {
			_minW = num;
		}

		public function set minH(num : Number) : void {
			_minH = num;
		}

		public function InspectorViewPanel(title : String = '面板', w : Number = 200, h : Number = 200, autoDisposeWhenRemove : Boolean = true, resizeable : Boolean = true, closeable : Boolean = true) {
			autoDispose = autoDisposeWhenRemove;
			
			bg = new Sprite();
			addChild(bg);
			
			bg.filters = [new GlowFilter(0x0, 1, 8, 8, 1)];

			_virtualResizer = new Sprite();
			_virtualResizer.graphics.lineStyle(1, 0x888888, 1, false, 'normal', CapsStyle.NONE, JointStyle.MITER);
			_virtualResizer.graphics.beginFill(0);
			_virtualResizer.graphics.moveTo(0, 0);
			_virtualResizer.graphics.lineTo(-w, 0);
			_virtualResizer.graphics.lineTo(0, -h);
			_virtualResizer.graphics.lineTo(0, 0);
			_virtualResizer.graphics.moveTo(-w / 2, 0);
			_virtualResizer.graphics.moveTo(0, -h / 2);
			_virtualResizer.graphics.endFill();
			
			
			_resizer = new ResizerButton(15, 15);
			if(resizeable)addChild(_resizer);
			
			_title = InspectorTextField.create(title, 0x99cc00, 12);
			_title.selectable = false;
			_title.height = 20;
			addChild(_title);
			
			_contentContainer = new Sprite();
			addChild(_contentContainer);
			
			closeBtn = new InspectorViewCloseButton();
			closeBtn.addEventListener(MouseEvent.CLICK, onClickClose);
			if(closeable)addChild(closeBtn);
			
			resizeBtn = new InspectorViewResizeButton();
			resizeBtn.addEventListener(MouseEvent.CLICK, onClickResize);
			if(resizeable)addChild(resizeBtn);
			
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
				this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseup);				this.addEventListener(MouseEvent.MOUSE_UP, onMouseup);
				
				this._resizer.addEventListener(MouseEvent.MOUSE_DOWN, onDownResizer);
				
				this.relayout();
			}
		}

		private function onRemoved(evt : Event) : void {
			if(evt.target == this) {
				inited = false;
				bg.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);		
				this.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseup);						this.removeEventListener(MouseEvent.MOUSE_UP, onMouseup);		
				
				this._resizer.removeEventListener(MouseEvent.MOUSE_DOWN, onDownResizer);
				this.stage.removeEventListener(Event.ENTER_FRAME, onMoveResizer);
				
				this.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
				
				if(autoDispose) {
					this.dispose();
				}
			}
		}

		private function onDownResizer(evt : MouseEvent) : void {
			this._virtualResizer.x = this._resizer.x;//mouseX;
			this._virtualResizer.y = this._resizer.y;//mouseY;
			this.stage.addEventListener(Event.ENTER_FRAME, onMoveResizer);
			
			var rect : Rectangle = this.getBounds(this.stage);
			var stagetBounds : Rectangle = InspectorStageReference.getStageBounds();			this._virtualResizer.startDrag(false, new Rectangle(_minW, _minH, stagetBounds.right - _minW - rect.x - 8, stagetBounds.bottom - _minH - rect.y - 8));
		}

		protected function onMoveResizer(evt : Event) : void {
			this.resize(this._virtualResizer.x, this._virtualResizer.y);
		}

		protected function onMouseDown(evt : MouseEvent) : void {
			this.cacheAsBitmap = true;
			var rect : Rectangle = InspectorStageReference.getStageBounds();
			this.startDrag(false, new Rectangle(rect.left - mouseX, rect.top - mouseY, rect.width, rect.height));
			
			DisplayObjectTool.swapToTop(this);
			
//			if(_useEff) {
//				this.visible = false;
//				if(_eff) {
//					_eff.dispose();
//					_eff.removeEventListener(Event.COMPLETE, onEffComplete);
//				}
//				_eff = new WobbleEffect(this);
//				_eff.apply();
//				_eff.addEventListener(Event.COMPLETE, onEffComplete);
//			
//				_eff.onDown(evt);
//			}
		}

		protected function onMouseup(evt : MouseEvent) : void {
			this.cacheAsBitmap = false;
			this.stage.removeEventListener(Event.ENTER_FRAME, onMoveResizer);
			this.stopDrag();
			this._virtualResizer.stopDrag();
			
//			if(_useEff)_eff.onUp(evt);
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

		public function getContent() : DisplayObject {
			return _content;
		}

		public function resize(w : Number, h : Number) : void {
			_width = w > _minW ? w : _minW;
			_height = h > _minH ? h : _minH;
			
			this.relayout();
		}

		public function relayout() : void {
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

		override public function get height() : Number {
			return _height;
		}

		protected function drawTitle() : void {
			_title.x = _padding.left;
			_title.y = 7;
			
			_title.width = _title.textWidth + 4;
			if(_title.width > resizeBtn.x - _padding.left)_title.width = resizeBtn.x - _padding.left;
		}

		public function set title(str : String) : void {
			_title.text = str;
			drawTitle();
		}

		public function get title() : String {
			return _title.text;
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
				_scroller.setContenRatio(calculateContenAreaHeight() / this._content.height);
				
				if(_scroller.stage == null)addChild(_scroller);
				
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
			this.bg.graphics.lineStyle(2, 0x888888);
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
			var rect : Rectangle = _contentContainer.scrollRect;
			rect.y = calculateScrollRectY();
			_contentContainer.scrollRect = rect;
		}

		/**
		 * 显示内容的某个区域
		 * @param rect		要滚动显示到的区域
		 * @param ori		方向值:0-只考虑垂直方向, 1-只考虑水平方向, 2-整个区域必须显示
		 */
		public function showContentArea(rect : Rectangle, ori : int = 2) : void {
			if(ori == 0) {
				rect.width = 1;
			}else if(ori == 1) {
				rect.height = 1;
			}
			
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
		protected function needHScroller() : Boolean {
			return _content.height - calculateContenAreaHeight() > 0;
		}

		/**
		 * TODO:显示内容是否需要垂直滚动条
		 */
		protected function needVScroller() : Boolean {
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
			
			//			if(_useEff) {
			//				_eff.visible = false;
			//				_eff.removeEventListener(Event.COMPLETE, onEffComplete);
			//				_eff.dispose();
			//			}

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

		private function onEffComplete(evt : Event) : void {
//			this.visible = true;
//			_eff.visible = false;
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
