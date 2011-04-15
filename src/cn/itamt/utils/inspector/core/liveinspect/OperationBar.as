package cn.itamt.utils.inspector.core.liveinspect {
	import cn.itamt.utils.inspector.ui.style.Style;
	import cn.itamt.utils.Inspector;
	import cn.itamt.utils.inspector.core.inspectfilter.FilterManagerButton;
	import cn.itamt.utils.inspector.core.inspectfilter.InspectorFilterManager;
	import cn.itamt.utils.inspector.core.propertyview.PropertiesViewButton;
	import cn.itamt.utils.inspector.core.structureview.StructureViewButton;
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.plugins.InspectorPluginId;
	import cn.itamt.utils.inspector.ui.InspectorButton;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author tamt
	 */
	public class OperationBar extends Sprite {
		public static const PRESS_MOVE : String = 'press_move';
		public static const PRESS_PARENT : String = 'press_parent';
		public static const PRESS_CHILD : String = 'press_child';
		public static const PRESS_NEXT : String = 'press_brother';
		public static const PRESS_PREV : String = 'press_prev';
		public static const PRESS_INFO : String = 'press_info';
		public static const PRESS_STRUCTURE : String = 'press_structure';
		public static const PRESS_CLOSE : String = 'press_close';
		public static const DOWN_MOVE : String = 'down_move';
		public static const UP_MOVE : String = 'up_move';
		public static const DB_CLICK_MOVE : String = 'double_click_move';
		public static const PRESS_FILTER : String = 'click_filter';
		public static const PRESS_TRANSFORM_3D:String = 'click_transform_3d';
		// 按钮
		private var _moveBtn : InspectorViewMoveButton;
		private var _pareBtn : InspectorViewParentButton;
		private var _childBtn : InspectorViewChildButton;
		private var _broBtn : InspectorViewBrotherButton;
		private var _prevBtn : InspectorViewPrevButton;
		private var _infoBtn : PropertiesViewButton;
		private var _filterBtn : FilterManagerButton;
		private var _struBtn : StructureViewButton;
		private var _closeBtn : InspectorViewCloseButton;
		private var _3dBtn : Inspector3DButton;
		private var _style : Style;
		public function get tfm3dBtn():Inspector3DButton 
		{
			return _3dBtn;
		}
		
		//是否显示3d工具按钮
		private var _show3DBtn:Boolean, _showPropBtn:Boolean = true, _showStructBtn:Boolean = true, _showFilterBtn:Boolean = true;
		
		// 布局
		private var _paddings : Array = [10, 5, 10];
		private var _btnGap : int = 5;
		private var _width : int = 200;
		private var _height : int = 33;

		public function get barHeight() : int {
			return _height;
		}
		
		private var _btns:Array;
		private var _inited:Boolean;
		
		public function OperationBar() : void {
		}

		public function init() : void {
			_inited = true;
			// 按钮
			_btns = [	_moveBtn = new InspectorViewMoveButton, 
						_pareBtn = new InspectorViewParentButton, 
						_childBtn = new InspectorViewChildButton,
						_prevBtn = new InspectorViewPrevButton, 
						_broBtn = new InspectorViewBrotherButton, 
						_closeBtn = new InspectorViewCloseButton];
			_infoBtn = new PropertiesViewButton;
			if(showPropBtn)_btns.splice(_btns.length - 1, 0, _infoBtn);
			_struBtn = new StructureViewButton;
			if(showStructBtn)_btns.splice(_btns.length - 1, 0, _struBtn);
			_filterBtn = new FilterManagerButton;
			if(showFilterBtn)_btns.splice(_btns.length - 1, 0, _filterBtn);
			_3dBtn = new Inspector3DButton();
			if (show3DBtn)_btns.splice(_btns.length - 1, 0, _3dBtn);
			this.relayout();

			_moveBtn.doubleClickEnabled = true;
			_moveBtn.addEventListener(MouseEvent.CLICK, onClickMoveBtn);
			_moveBtn.addEventListener(MouseEvent.MOUSE_DOWN, onDownMoveBtn);
			_moveBtn.addEventListener(MouseEvent.MOUSE_UP, onUpMoveBtn);
			_moveBtn.addEventListener(MouseEvent.DOUBLE_CLICK, onDlickMoveBtn);
			_pareBtn.addEventListener(MouseEvent.CLICK, onClickParentBtn);
			_childBtn.addEventListener(MouseEvent.CLICK, onClickChildBtn);
			_broBtn.addEventListener(MouseEvent.CLICK, onClickBrotherBtn);
			_prevBtn.addEventListener(MouseEvent.CLICK, onClickPrevBtn);
			_infoBtn.addEventListener(MouseEvent.CLICK, onClickInfoBtn);
			_closeBtn.addEventListener(MouseEvent.CLICK, onClickCloseBtn);
			_struBtn.addEventListener(MouseEvent.CLICK, onClickStruBtn);
			_filterBtn.addEventListener(MouseEvent.CLICK, onClickFilterBtn);
			_3dBtn.addEventListener(MouseEvent.CLICK, onClick3DBtn);
		}
		
		private function relayout():void 
		{
			var btn : InspectorButton;
			for(var i : int = 0;i < _btns.length;i++) {
				btn = _btns[i] as InspectorButton;
				if(!contains(btn))addChild(btn);
				if(i == 0) {
					btn.x = _paddings[0] + i * _btnGap;
				} else {
					btn.x = _paddings[0] + i * (_btnGap + (_btns[i - 1] as InspectorButton).width);
				}
				btn.y = _paddings[1];
			}
			
			// 背景
			graphics.clear();
			graphics.beginFill(style.bgColor);
			graphics.drawRoundRectComplex(0, 0, _closeBtn.x + _closeBtn.width + 10, _height, 8, 8, 0, 8);
			graphics.endFill();
		}
		
		private function onClick3DBtn(e:MouseEvent):void 
		{
			dispatchEvent(new Event(PRESS_TRANSFORM_3D));
		}

		/**
		 * 双击"拖动"按钮
		 */
		private function onDlickMoveBtn(evt : MouseEvent) : void {
			dispatchEvent(new Event(DB_CLICK_MOVE));
		}

		private function onClickMoveBtn(evt : MouseEvent) : void {
			dispatchEvent(new Event(PRESS_MOVE));
		}

		private function onDownMoveBtn(evt : MouseEvent) : void {
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onUpMoveBtn);
			dispatchEvent(new Event(DOWN_MOVE));
		}

		private function onUpMoveBtn(evt : MouseEvent) : void {
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onUpMoveBtn);
			dispatchEvent(new Event(UP_MOVE));
		}

		private function onClickParentBtn(evt : MouseEvent) : void {
			dispatchEvent(new Event(PRESS_PARENT));
		}

		private function onClickChildBtn(evt : MouseEvent) : void {
			dispatchEvent(new Event(PRESS_CHILD));
		}

		private function onClickBrotherBtn(evt : MouseEvent) : void {
			dispatchEvent(new Event(PRESS_NEXT));
		}

		private function onClickPrevBtn(evt : MouseEvent):void {
			dispatchEvent(new Event(PRESS_PREV));
		}

		private function onClickInfoBtn(evt : MouseEvent) : void {
			dispatchEvent(new Event(PRESS_INFO, true, true));
		}

		private function onClickStruBtn(evt : MouseEvent) : void {
			dispatchEvent(new Event(PRESS_STRUCTURE, true, true));
		}

		private function onClickFilterBtn(evt : MouseEvent) : void {
			dispatchEvent(new Event(PRESS_FILTER, true, true));
		}

		private function onClickCloseBtn(evt : MouseEvent) : void {
			dispatchEvent(new Event(PRESS_CLOSE));
		}

		/**
		 * 销毁对象
		 */
		public function dispose() : void {
		}

		/**
		 * 验证target, 是否禁用相关按钮
		 */
		public function validate(target : DisplayObject) : void {
			_moveBtn.enabled = _pareBtn.enabled = _childBtn.enabled = _prevBtn.enabled = _broBtn.enabled = /*_infoBtn.enabled =*/ _closeBtn.enabled = true;

			if(target is Stage) {
				_moveBtn.enabled = false;
			}

			if(target.parent) {
				if(target.parent.numChildren == 1) {
					_broBtn.enabled = false;
					_prevBtn.enabled = false;
				}
			} else {
				_pareBtn.enabled = false;
				_broBtn.enabled = false;
				_prevBtn.enabled = false;
			}

			if(target is DisplayObjectContainer) {
			} else {
				_childBtn.enabled = false;
			}

			//_filterBtn.active = Inspector.getInstance().filterManager.isFilterActiving(target['constructor'] as Class);
			_filterBtn.active = (Inspector.getInstance().pluginManager.getPluginById(InspectorPluginId.FILTER_VIEW) as InspectorFilterManager).isFilterActiving(target['constructor'] as Class);
			if(_filterBtn.active) {
				_filterBtn.tip = InspectorLanguageManager.getStr('SetFilterClass');
			} else {
				_filterBtn.tip = InspectorLanguageManager.getStr('unSetFilterClass');
			}
		}

		public function get showPropBtn() : Boolean {
			return _showPropBtn;
		}

		public function set showPropBtn(showPropBtn : Boolean) : void {
			_showPropBtn = showPropBtn;

			if (_inited) {
				var i:int = _btns.indexOf(_infoBtn);
				if (_showPropBtn) {
					if (i < 0)_btns.splice(_btns.length - 1, 0, _infoBtn);
				}else {
					if (i >= 0) {
						if(contains(_infoBtn))removeChild(_infoBtn);
						_btns.splice(i, 1);
					}
				}
				relayout();
			}
		}

		public function get showStructBtn() : Boolean {
			return _showStructBtn;
		}

		public function set showStructBtn(showStructBtn : Boolean) : void {
			_showStructBtn = showStructBtn;

			if (_inited) {
				var i:int = _btns.indexOf(_struBtn);
				if (_showStructBtn) {
					if (i < 0)_btns.splice(_btns.length - 1, 0, _struBtn);
				}else {
					if (i >= 0) {
						if(contains(_struBtn))removeChild(_struBtn);
						_btns.splice(i, 1);
					}
				}
				relayout();
			}
		}

		public function get showFilterBtn() : Boolean {
			return _showFilterBtn;
		}

		public function set showFilterBtn(showFilterBtn : Boolean) : void {
			_showFilterBtn = showFilterBtn;
			
			if (_inited) {
				var i:int = _btns.indexOf(_filterBtn);
				if (_showFilterBtn) {
					if (i < 0)_btns.splice(_btns.length - 1, 0, _filterBtn);
				}else {
					if (i >= 0) {
						if(contains(_filterBtn))removeChild(_filterBtn);
						_btns.splice(i, 1);
					}
				}
				relayout();
			}
		}
				public function get show3DBtn():Boolean 
		{
			return _show3DBtn;
		}
		
		public function set show3DBtn(value:Boolean):void 
		{
			_show3DBtn = value;
			if (_inited) {
				var i:int = _btns.indexOf(_3dBtn);
				if (_show3DBtn) {
					if (i < 0)_btns.splice(_btns.length - 1, 0, _3dBtn);
				}else {
					if (i >= 0) {
						if(contains(_3dBtn))removeChild(_3dBtn);
						_btns.splice(i, 1);
					}
				}
				relayout();
			}
		}

		public function get style() : Style {
			return _style;
		}

		public function set style(style : Style) : void {
			_style = style;
		}
		
	}
}
