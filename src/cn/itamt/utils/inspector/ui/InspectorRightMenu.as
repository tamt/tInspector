package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.inspector.consts.InspectorPluginId;
	import cn.itamt.utils.inspector.interfaces.IInspector;
	import cn.itamt.utils.inspector.output.InspectorOutPuterManager;

	import flash.display.InteractiveObject;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	/**
	 * tInspector的右键菜单。
	 */
	public class InspectorRightMenu extends BaseInspectorPlugin {
		public static const ON : String = 'tInspector on';		public static const OFF : String = 'tInspector off';
		//开关菜单项
		private var _on : ContextMenuItem;		private var _off : ContextMenuItem;
		//几个inspectorView的菜单项
		private var _viewItems : Array;

		override public function set outputerManager(value : InspectorOutPuterManager) : void {
			trace('[InspectorRightMenu][outputerManager]PropertiesView没有设计信息输出的接口，忽略该属性设置。');
		}

		public function InspectorRightMenu(on : Boolean = true) {
			_on = new ContextMenuItem(ON);
			_on.separatorBefore = true;
			_on.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuItemSelect);
			_off = new ContextMenuItem(OFF);
			_off.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuItemSelect);
			
			_on.enabled = on;
			_off.enabled = !on;
			
			_viewItems = [];
		}

		/**
		 * 注册到Inspector时.
		 */
		override public function onRegister(inspector : IInspector) : void {
			this._inspector = inspector;
			
			this.apply(inspector.root);

			this.onTurnOff();
		}

		override public function onUnRegister(inspector : IInspector) : void {
		}

		override public function onRegisterPlugin(pluginId : String) : void {
			if(pluginId == InspectorPluginId.RIGHT_MENU)return;
			
			for each(var item:ViewMenuItem in _viewItems) {
				if(item.id == pluginId)return;
			}
			var menuItem : ViewMenuItem = new ViewMenuItem(pluginId);
			menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuItemSelect);
			_viewItems.push(menuItem);
			
			this.apply(_inspector.root);
		}

		override public function onUnRegisterPlugin(pluginId : String) : void {
			for each(var item:ViewMenuItem in _viewItems) {
				if(item.id == pluginId) {
					item.removeEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onMenuItemSelect);
					var t : int = _viewItems.indexOf(item);
					if(t >= 0)_viewItems.splice(t, 1);
				}
			}
		}

		override public function onActivePlugin(pluginId : String) : void {
			for each(var menuItem:ViewMenuItem in _viewItems) {
				if(menuItem.id == pluginId) {
					menuItem.on = true;
				}
			}
		}

		override public function onUnActivePlugin(pluginId : String) : void {
			for each(var menuItem:ViewMenuItem in _viewItems) {
				if(menuItem.id == pluginId) {
					menuItem.on = false;
				}
			}
		}

		override public function onTurnOn() : void {
			_on.enabled = false;
			_off.enabled = true;
			
			for each(var menuItem:ViewMenuItem in _viewItems) {
				menuItem.enabled = true;
				if(menuItem.on)_inspector.activePlugin(menuItem.id);
			}
		}

		override public function onTurnOff() : void {
			_on.enabled = true;
			_off.enabled = false;
			
			for each(var menuItem:ViewMenuItem in _viewItems) {
				//				menuItem.on = false;
				menuItem.enabled = false;
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
			}
				
			var menu : ContextMenu = obj.contextMenu;
			if(menu == null) {
				menu = new ContextMenu();
			}
			menu.customItems.push(_on);
			menu.customItems.push(_off);
				
			for each(var item:ViewMenuItem in _viewItems) {
				menu.customItems.push(item.target);
			}
				
			obj.contextMenu = menu;
		}

		private function onMenuItemSelect(evt : ContextMenuEvent) : void {
			switch(evt.target) {
				case _on:
					_inspector.turnOn();
					break;
				case _off:
					_inspector.turnOff();
					break;
				default:
					for each(var menuItem:ViewMenuItem in _viewItems) {
						if(menuItem.target == evt.target) {
							if(menuItem.on) {
								_inspector.unactivePlugin(menuItem.id);
							} else {
								_inspector.activePlugin(menuItem.id);
							}
							break;
						}
					}
					break;
			}
		}
	}
}

import cn.itamt.utils.inspector.lang.InspectorLanguageManager;

import flash.ui.ContextMenuItem;

class ViewMenuItem {

	private var _on : Boolean;

	public function set on(value : Boolean) : void {
		_on = value;
		if(_on) {
			target.caption = InspectorLanguageManager.getStr(id) + '\t√';
		} else {
			target.caption = InspectorLanguageManager.getStr(id);
		}
	}

	public function get on() : Boolean {
		return _on;
	}

	private var _id : String;

	public function get id() : String {
		return _id;
	}

	public var target : ContextMenuItem;

	public function ViewMenuItem(id : String) : void {
		this._id = id;
		this.target = new ContextMenuItem(InspectorLanguageManager.getStr(this.id), false, false);
	}

	public function addEventListener(type : String, listener : Function) : void {
		this.target.addEventListener(type, listener);
	}

	public function removeEventListener(type : String, listener : Function) : void {
		this.target.removeEventListener(type, listener);
	}

	public function set enabled(val : Boolean) : void {
		this.target.enabled = val;
	}

	public function get enabled() : Boolean {
		return this.target.enabled;
	}
}