package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;	
	import cn.itamt.utils.ClassTool;
	import cn.itamt.utils.inspector.events.PropertyEvent;
	import cn.itamt.utils.inspector.renders.BasePropertyEditor;
	import cn.itamt.utils.inspector.renders.MethodRender;
	import cn.itamt.utils.inspector.renders.PropertyAccessorRender;
	import cn.itamt.utils.inspector.ui.InspectorViewPanel;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.describeType;	

	/**
	 * 属性面板
	 * @author itamt@qq.com
	 */
	public class PropertiesViewPanel extends InspectorViewPanel {
		private var list : Sprite;
		private var listMethod : Sprite;
		private var  methodArray : Array;
		private var curTarget : DisplayObject;
		private var propList : Array;

		private var singletonBtn : InspectorViewSingletonButton;
		private var fullBtn : InspectorViewFullButton;

		private var renders : Array;
		//收藏的属性
		private var favProps : Array = ["x", "y", "width", "height", "scaleX", "scaleY", "alpha", "rotation"];

		private var viewPropBtn : InspectorTabLabelButton;
		private var viewMethodBtn : InspectorTabLabelButton;

		//当前状态为属性
		public static const PROP_STATE : int = 1;
		//当前状态为方法
		public static const METHOD_STATE : int = 2;
		//当前状态
		private var state : int = PROP_STATE;

		public function PropertiesViewPanel(w : Number = 240, h : Number = 170) {
			super('Property', w, h);
			
			_title.mouseEnabled = _title.mouseWheelEnabled = false;
			
			this._padding = new	Padding(33, 10, 40, 10);

			renders = [];
			
			this._minW = 240;
			this._minH = 170;			
			
			list = new Sprite();
			this.setContent(list);
			
			//查看完整属性.
			fullBtn = new InspectorViewFullButton();
			fullBtn.addEventListener(MouseEvent.CLICK, onClickFull);
			addChild(fullBtn);
			
			//单例面板模式/多面板模式
			singletonBtn = new InspectorViewSingletonButton();
			singletonBtn.addEventListener(MouseEvent.CLICK, onClickSingleton);
			addChild(singletonBtn);
			
			//查看"属性"tab按钮
			this.viewPropBtn = new InspectorTabLabelButton(InspectorLanguageManager.getStr('Property'), true);
			this.viewPropBtn.tip = InspectorLanguageManager.getStr('ViewProperties');
			this.viewPropBtn.addEventListener(MouseEvent.CLICK, onViewProp);
			addChild(this.viewPropBtn);
			//查看"方法"tab按钮
			this.viewMethodBtn = new InspectorTabLabelButton(InspectorLanguageManager.getStr('Method'));
			this.viewMethodBtn.tip = InspectorLanguageManager.getStr('ViewMethods');
			this.viewMethodBtn.addEventListener(MouseEvent.CLICK, onViewMethod);
			addChild(this.viewMethodBtn);
			
			this.addEventListener(PropertyEvent.UPDATE, onPropertyUpdate);
			this.addEventListener(PropertyEvent.FAV, onFavProperty);			this.addEventListener(PropertyEvent.DEL_FAV, onDelFavProperty);
		}

		//查看对象的方法
		private function onViewMethod(event : MouseEvent) : void {
			this.state = METHOD_STATE;
			if(listMethod == null) {
				listMethod = new Sprite();
			}
			this.setContent(listMethod);
			this.onInspectMethod(this.curTarget);
			
			this.viewMethodBtn.active = true;
			this.viewPropBtn.active = false;
		}

		//查看对象的属性
		private function onViewProp(event : MouseEvent) : void {
			this.state = PROP_STATE;
			this.setContent(list);
			this.onInspectProp(this.curTarget);
			
			this.viewMethodBtn.active = false;			this.viewPropBtn.active = true;
		}

		override public function relayout() : void {
			super.relayout();
			
			fullBtn.x = this.resizeBtn.x - this.fullBtn.width;
			fullBtn.y = 5;
			
			singletonBtn.x = this.fullBtn.x - this.singletonBtn.width - 2;
			singletonBtn.y = 5;
			
			//			this.viewPropBtn.x = this._padding.left;
			//			this.viewMethodBtn.x = this.viewPropBtn.x + this.viewPropBtn.width + 10;
			this.viewMethodBtn.x = _width - this._padding.right - this.viewMethodBtn.width;
			this.viewPropBtn.x = this.viewMethodBtn.x - 10 - this.viewPropBtn.width;
			this.viewPropBtn.y = this.viewMethodBtn.y = this._height - this.viewPropBtn.height - (_padding.bottom - viewPropBtn.height) / 2;
			
			//
			if(this.state == PROP_STATE) {
				this.fullBtn.enabled = this.fullBtn.mouseEnabled = true;
			} else {
				this.fullBtn.enabled = this.fullBtn.mouseEnabled = false;
			}
		}

		/*
		 * 查看某个对象的属性
		 */
		public function onInspectProp(object : DisplayObject) : void {
			var xml : XML = describeType(object);
			var tmp : XMLList = xml.accessor;
			propList = [];
			for each(var item:XML in tmp) {
				propList.push(item);
			}
			//			favProps.reverse();
			propList.sort(compateAccessorName);
			this.onClickFull();
		}

		/**
		 * 查看某个显示对象的属性.
		 */
		public function onInspect(object : DisplayObject) : void {
			if(curTarget != object) {
				curTarget = object;
				//属性状态
				if(this.state == PROP_STATE) {
					this.onInspectProp(object);
				} else {
					//方法状态
					this.onInspectMethod(curTarget);
				}
				
				//更新title
				this._title.htmlText = curTarget.name + '<font color="#cccccc">(' + ClassTool.getShortClassName(curTarget) + ')</font>';
				this.drawTitle();
			} else {
				onUpdate(object);
			}
		}

		
		override protected function drawTitle() : void {
			_title.x = _padding.left;
			_title.y = 7;
			
			_title.width = _title.textWidth + 4;
			if(_title.width > singletonBtn.x - _padding.left)_title.width = singletonBtn.x - _padding.left;
		}

		/*
		 * 查看某个显示对象的方法(如果传过来的对象为空，就用当前的对象)
		 */				public function onInspectMethod(object : DisplayObject = null) : void {
			if(object != null) {
				if(curTarget != object) {
					curTarget = object;
				}
				var xml : XML = describeType(curTarget);
				var methods : XMLList = xml.method;
				methodArray = [];
				for each(var method:XML in methods) {
					methodArray.push(method);
				}
				methodArray.sort(compateAccessorName);
				this.drawList();
			}
		}

		private function compateAccessorName(a : XML, b : XML) : Number {
			var aN : String = String(a.@name);			var bN : String = String(b.@name);
			
			if(favProps.indexOf(aN) > favProps.indexOf(bN)) {
				return -1;
			} else if(favProps.indexOf(aN) < favProps.indexOf(bN)) {
				return 1;
			} else {
				if(aN > bN) {
					return 1;
				}else if(aN < bN) {
					return -1;
				} else {
					return 0;
				}
			}
		}

		/**
		 * 侦听到单元格编辑器的属性更改事件.
		 */
		private function onPropertyUpdate(evt : PropertyEvent) : void {
			var editor : BasePropertyEditor = evt.target as BasePropertyEditor;
			curTarget[editor.getPropName()] = editor.getValue();
		}

		/**
		 * 收藏属性
		 */
		private function onFavProperty(evt : PropertyEvent) : void {
			var render : PropertyAccessorRender = evt.target as PropertyAccessorRender;
			var prop : String = String(render.xml.@name);
			if(this.favProps.indexOf(prop) < 0) {
				this.favProps.unshift(prop);
				this.propList.sort(compateAccessorName);
				
				drawList();
			}
		}

		/**
		 * 删除收藏属性
		 */
		private function onDelFavProperty(evt : PropertyEvent) : void {
			var render : PropertyAccessorRender = evt.target as PropertyAccessorRender;
			var prop : String = String(render.xml.@name);
			var t : int = this.favProps.indexOf(prop);
			if(t >= 0) {
				this.favProps.splice(t, 1);
				this.propList.sort(compateAccessorName);
				drawList();
			}
		}

		/**
		 * 当指定对象的属性有更新时
		 */
		public function onUpdate(obj : DisplayObject) : void {
			if(obj == curTarget) {
				var i : int = 0;
				var render : PropertyAccessorRender;
				while(i < list.numChildren) {
					render = list.getChildAt(i++) as PropertyAccessorRender;
					render.update();
				}
			}
		}

		private function drawList() : void {
			switch(this.state) {
				case PROP_STATE:
					this.propDrawList();
					break;
				case METHOD_STATE:
					this.methodDrawList();
					break;
			}
			this.relayout();
		}

		//对象的属性重绘
		private function propDrawList() : void {
			list.graphics.clear();
			list.graphics.lineTo(0, 0);
			while(list.numChildren) {
				list.removeChildAt(0);
			}
			
			var l : int = propList.length;
			for(var i : int = 0;i < l; i++) {				var render : PropertyAccessorRender;
				if(i < favProps.length) {
					if(this.favProps.indexOf(String(propList[i].@name)) > -1) {
						render = new PropertyAccessorRender(250, 20, true);
					} else {
						if(fullBtn.normalMode) {
							break;
						} else {
							render = new PropertyAccessorRender(250, 20);
						}
					}
				} else {
					if(fullBtn.normalMode) {
						break;
					} else {
						render = new PropertyAccessorRender(250, 20);
					}
				}
				render.setXML(this.curTarget, propList[i]);
				render.y = list.height + 2;
				
				list.addChild(render);
			}
		}

		//对象的方法重绘
		private function methodDrawList() : void {
			this.listMethod.graphics.clear();
			listMethod.graphics.lineTo(0, 0);
			while(listMethod.numChildren) {
				listMethod.removeChildAt(0);
			}
			var length : int = this.methodArray.length;
			for(var i : int = 0;i < length;i++) {
				var render : MethodRender = new MethodRender(210, 20);
				render.setXML(this.curTarget, methodArray[i]);
				render.y = listMethod.height + 2;
				listMethod.addChild(render);
			}
		}

		/**
		 * 当单击"查看完整属性按钮时".
		 */
		private function onClickFull(evt : MouseEvent = null) : void {
			if(evt)evt.stopImmediatePropagation();
			this.drawList();
			if(fullBtn.normalMode) {
				if(this.resizeBtn.normalMode)this.resize(this._width, 270);
			} else {
				if(this.resizeBtn.normalMode)this.resize(this._width, 400);
			}
		}

		public function getSingleMode() : Boolean {
			return singletonBtn.normalMode;
		}

		/**
		 * 单例/多面板 按钮.
		 */
		private function onClickSingleton(evt : MouseEvent = null) : void {
			if(evt)evt.stopImmediatePropagation();
			this.drawList();
			if(singletonBtn.normalMode) {
				
			} else {
				
			}
		}

		public function getCurTarget() : DisplayObject {
			return this.curTarget;
		}

		override public function open() : void {
			super.open();
			this.viewMethodBtn.visible = this.viewPropBtn.visible = true;
		}

		override public function hide() : void {
			super.hide();
			this.viewMethodBtn.visible = this.viewPropBtn.visible = false;
		}
	}
}
