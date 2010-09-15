package cn.itamt.utils.inspector.core.propertyview {
	import cn.itamt.utils.ClassTool;
	import cn.itamt.utils.inspector.core.propertyview.accessors.PropertyAccessorRender;
	import cn.itamt.utils.inspector.events.PropertyEvent;
	import cn.itamt.utils.inspector.ui.InspectorViewFullButton;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * 属性面板
	 * @author itamt@qq.com
	 */
	public class DisplayObjectPropertyPanel extends PropertyPanel {
		private var fullBtn : InspectorViewFullButton;

		//收藏的属性
		private static var favProps : Array = ["x", "y", "width", "height", "scaleX", "scaleY", "alpha", "rotation"];

		public function DisplayObjectPropertyPanel(w : Number = 240, h : Number = 170, owner : PropertyAccessorRender = null) {
			super(w, h, owner);
			
			singletonBtn.normalMode = true;
			
			//查看完整属性.
			fullBtn = new InspectorViewFullButton();
			fullBtn.addEventListener(MouseEvent.CLICK, onClickFull);
			addChild(fullBtn);
			
			this.addEventListener(PropertyEvent.FAV, this.onFavProperty);			this.addEventListener(PropertyEvent.DEL_FAV, this.onDelFavProperty);
		}

		override public function relayout() : void {
			super.relayout();
			
			fullBtn.x = this.resizeBtn.x - this.fullBtn.width;
			fullBtn.y = 5;
			
			singletonBtn.x = this.fullBtn.x - this.singletonBtn.width - 2;
			singletonBtn.y = 5;
			
			refreshBtn.x = this.singletonBtn.x - this.singletonBtn.width - 2;
			refreshBtn.y = 5;
		}

		
		override protected function drawTitle() : void {
			//更新title
			if(target)this._title.htmlText = '<font color="#99cc00">' + target.name + '</font>' + '<font color="#cccccc">(' + ClassTool.getShortClassName(target) + ')</font>';
			super.drawTitle();
		}

		override protected function compateAccessorName(a : XML, b : XML) : Number {
			var aN : String = String(a.@name);
			var bN : String = String(b.@name);
			
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
		 * 收藏属性
		 */
		private function onFavProperty(evt : PropertyEvent) : void {
			var render : PropertyAccessorRender = evt.target as PropertyAccessorRender;
			var prop : String = String(render.xml.@name);
			if(favProps.indexOf(prop) < 0) {
				favProps.unshift(prop);
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
			var t : int = favProps.indexOf(prop);
			if(t >= 0) {
				favProps.splice(t, 1);
				this.propList.sort(compateAccessorName);
				drawList();
			}
		}

		//对象的属性重绘
		override protected function drawPropList() : void {
			list.graphics.clear();
			list.graphics.lineTo(0, 0);
			while(list.numChildren) {
				list.removeChildAt(0);
			}
			
			if(propList) {
				var l : int = propList.length;
				for(var i : int = 0;i < l;i++) {
					var render : PropertyAccessorRender;
					if(i < favProps.length) {
						if(favProps.indexOf(String(propList[i].@name)) > -1) {
							render = new PropertyAccessorRender(200, 20, true, this.owner);
						} else {
							if(fullBtn.normalMode) {
								break;
							} else {
								render = new PropertyAccessorRender(200, 20, false, this.owner);
							}
						}
					} else {
						if(fullBtn.normalMode) {
							break;
						} else {
							render = new PropertyAccessorRender(200, 20, false, this.owner);
						}
					}
					render.setXML(this.target, propList[i]);
					render.y = list.height + 2;
				
					list.addChild(render);
				}
			}
		}

		/**
		 * 当单击"查看完整属性按钮时".
		 */
		override protected function onClickFull(evt : MouseEvent = null) : void {
			if(evt)evt.stopImmediatePropagation();
			this.drawList();
			if(!fullBtn.normalMode) {
				if(this.resizeBtn.normalMode) {
					if(_mSavedSize == null) {
						_mSavedSize = new Point(this._width, 270);
					} else {
						_mSavedSize = new Point(this._width, this.height);
					}
					if(_fSavedSize == null)_fSavedSize = new Point(this._width, 400);
					this.addChild(this.search);
					if(this.resizeBtn.normalMode)this.resize(_fSavedSize.x, _fSavedSize.y);
				}
			} else {
				if(this.resizeBtn.normalMode) {
					if(_fSavedSize == null) {
						_fSavedSize = new Point(this._width, 400);
					} else {
						_fSavedSize = new Point(this._width, this.height);
					}
					if(_mSavedSize == null)_mSavedSize = new Point(this._width, 270);
					if(this.search.parent)this.search.parent.removeChild(this.search);
					if(this.resizeBtn.normalMode)this.resize(_mSavedSize.x, _mSavedSize.y);
				}
			}
		}

		public function get target() : DisplayObject {
			return this.curTarget as DisplayObject;
		}

		public function set target(t : DisplayObject) : void {
			this.curTarget = t;
		}
	}
}
