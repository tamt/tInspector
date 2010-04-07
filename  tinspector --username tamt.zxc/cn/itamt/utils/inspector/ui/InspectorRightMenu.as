package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.Inspector;
	import cn.itamt.utils.inspector.consts.InspectMode;
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.output.InspectorOutPuterManager;

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	/**
	 * tInspector的右键菜单。
	 */
	public class InspectorRightMenu extends BaseInspectorView {
		public static const ID : String = '右键菜单';

		public static const ON : String = 'tInspector on';		public static const OFF : String = 'tInspector off';
		//开关菜单项
		private var _on : ContextMenuItem;		private var _off : ContextMenuItem;
		private var _dspMode : ContextMenuItem;
		private var _intMode : ContextMenuItem;
		//属性面板视图
		private var _pView : ContextMenuItem;
		//显示列表树视图
		private var _sView : ContextMenuItem;

		override public function set outputerManager(value : InspectorOutPuterManager) : void {
			trace('[InspectorRightMenu][outputerManager]PropertiesView没有设计信息输出的接口，忽略该属性设置。');
		}

		public function InspectorRightMenu(on : Boolean = true, mode : String = InspectMode.DISPLAY_OBJ) {
			_on = new ContextMenuItem(ON);
			_on.separatorBefore = true;
			_on.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuItemSelect);
			_off = new ContextMenuItem(OFF);
			_off.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuItemSelect);
			
			_dspMode = new ContextMenuItem(InspectMode.DISPLAY_OBJ);
			_dspMode.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuItemSelect);
			_intMode = new ContextMenuItem(InspectMode.INTERACTIVE_OBJ);
			_intMode.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuItemSelect);
			
			_pView = new ContextMenuItem(InspectorLanguageManager.getStr("PropertyPanel"));
			_pView.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuItemSelect);
			_sView = new ContextMenuItem(InspectorLanguageManager.getStr("StructurePanel"));
			_sView.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuItemSelect);
			
			_on.enabled = on;
			_off.enabled = !on;
			
			_dspMode.caption = (mode == InspectMode.DISPLAY_OBJ) ? (InspectMode.DISPLAY_OBJ + '\t√') : (InspectMode.DISPLAY_OBJ);			_intMode.caption = (mode == InspectMode.INTERACTIVE_OBJ) ? (InspectMode.INTERACTIVE_OBJ + '\t√') : (InspectMode.INTERACTIVE_OBJ);
		}

		/**
		 * 注册到Inspector时.
		 */
		override public function onRegister(inspector : Inspector) : void {
			this._inspector = inspector;
			this.apply(inspector.root);
			
			this.onTurnOff();
		}

		private var _pOn : Boolean;		private var _sOn : Boolean;

		override public function onRegisterView(viewClassId : String) : void {
			switch(viewClassId) {
				case "PropertyPanel":
					_pOn = true;
					_pView.caption = InspectorLanguageManager.getStr("PropertyPanel") + '\t√';
					break;
				case "StructurePanel":
					_sOn = true;
					_sView.caption = InspectorLanguageManager.getStr("StructurePanel") + '\t√';
					break;
			}
		}

		/**
		 * 
		 */
		override public function onUnregisterView(viewClassId : String) : void {
			switch(viewClassId) {
				case "PropertyPanel":
					_pOn = false;
					_pView.caption = InspectorLanguageManager.getStr("PropertyPanel");
					break;
				case "StructurePanel":
					_sOn = false;
					_sView.caption = InspectorLanguageManager.getStr("StructurePanel");
					break;
			}
		}

		override public function onTurnOn() : void {
			_on.enabled = false;
			_off.enabled = true;
			
			_dspMode.enabled = _intMode.enabled = _pView.enabled = _sView.enabled = true;
		}

		override public function onTurnOff() : void {
			_on.enabled = true;
			_off.enabled = false;
			
			_dspMode.enabled = _intMode.enabled = _pView.enabled = _sView.enabled = false;
		}

		/**
		 * 当设置Inspect的查看模式时.
		 */
		override public function onInspectMode(clazz : Class) : void {
			if(clazz == DisplayObject) {
				_dspMode.caption = InspectMode.DISPLAY_OBJ + '\t√';
				_intMode.caption = InspectMode.INTERACTIVE_OBJ;
			}else if(clazz == InteractiveObject) {
				_dspMode.caption = InspectMode.DISPLAY_OBJ;
				_intMode.caption = InspectMode.INTERACTIVE_OBJ + '\t√';
			}
		}

		private var _objs : Array;

		/**
		 * 把InspectorRightmenu应用到某一个InteractiveObject的右键上.
		 */
		public function apply(obj : InteractiveObject) : void {
			if(_objs == null)_objs = [];
			if(_objs.indexOf(obj) < 0) {
				_objs.push(obj);
				
				var menu : ContextMenu = obj.contextMenu;
				if(menu == null) {
					menu = new ContextMenu();
				}
				menu.customItems.push(_on);
				menu.customItems.push(_off);
				menu.customItems.push(_dspMode);				menu.customItems.push(_intMode);
				menu.customItems.push(_pView);				menu.customItems.push(_sView);
				obj.contextMenu = menu;
			}
		}

		/**
		 * 返回这个InspectorView的id, 在tInspector中, 通过id来管理各个InspectorView.
		 */
		override public function getInspectorViewClassID() : String {
			return InspectorRightMenu.ID;
		}

		private function onMenuItemSelect(evt : ContextMenuEvent) : void {
			switch(evt.target) {
				case _on:
					_inspector.turnOn();
					break;
				case _off:
					_inspector.turnOff();
					break;
				case _dspMode:
					_inspector.setInspectFilter(DisplayObject);
					break;
				case _intMode:
					_inspector.setInspectFilter(InteractiveObject);
					break;
				case _pView:
					if(_pOn) {
						_inspector.unregisterViewById("PropertyPanel");
					} else {
						_inspector.registerViewById("PropertyPanel");
					}
					break;
				case _sView:
					if(_sOn) {
						_inspector.unregisterViewById("StructurePanel");
					} else {
						_inspector.registerViewById("StructurePanel");
					}
					break;
			}
		}
	}
}