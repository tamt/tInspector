package cn.itamt.utils.inspectorui {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import cn.itamt.utils.inspectorui.StructureElement;
	import cn.itamt.utils.inspectorui.StructureElementView;	

	/**
	 * @author tamt
	 */
	public class InspectStructureView extends Sprite {
		private var _margin : Number = 10;
		private var _target : DisplayObject;

		public function get target() : DisplayObject {
			return _target;
		}

		public function InspectStructureView() : void {
			super();
		}

		public function inspect(target : DisplayObject) : void {
			if(_target) {
				graphics.clear();
				while(numChildren) {
					removeChildAt(0);
				}
			}
			
			_target = target;
			
			//索引出目标的所有"前辈对象".
			var _fatherElesOfTarget : Array = [];
			var p : DisplayObject = _target;
			while(p = p.parent) {
				_fatherElesOfTarget.push(p);
			}
			
			//索引出显示结构
			var i : int = _fatherElesOfTarget.length;
			var level : int = 0;
			var sel : StructureElement = new StructureElement(_fatherElesOfTarget[i - 1], level++, true);
			var osel : StructureElement = sel;
			while(sel.isTargetFather) {
				var childs : Array = sel.getChilds();
				var selChilds : Array = [];
				var child : DisplayObject;
				var nextChildIndex : int = -1;
				for(i = 0;i < childs.length; i++) {
					child = childs[i] as DisplayObject;
					if(_fatherElesOfTarget.indexOf(child) >= 0) {
						selChilds.push(new StructureElement(child, level, true));
						nextChildIndex = i;
					}else if(child == _target) {
						selChilds.push(new StructureElement(child, level, false));
						nextChildIndex = i;
					}else {
						selChilds.push(new StructureElement(child, level, false));
					}
				}
				sel.structChildElements = selChilds;
				sel = selChilds[nextChildIndex];
				level++;
			}
			
			//绘制
			var views : Array = [];
			drawStructureEle(osel, views);
			var sp : StructureElementView;
			for(i = 0;i < views.length; i++) {
				sp = views[i] as StructureElementView;
				sp.y = (views.length - 1 - i) * sp.height + _margin;
				sp.x = _margin;
				addChild(sp);
			}
			
			//绘制背景
			drawBG();
		}

		private function drawStructureEle(ele : StructureElement, arr : Array) : void {
			var sp : StructureElementView = new StructureElementView(ele);
			if(ele.target == _target){
				sp.highLight();
			}
			
			for(var i : int = 0;i < ele.structChildElements.length; i++) {
				drawStructureEle(ele.structChildElements[i], arr);
			}
			
			arr.push(sp);
		}

		private function drawBG() : void {
			graphics.clear();
			
			var w : Number = this.width;
			var h : Number = this.height;
			
			graphics.beginFill(InspectorColorStyle.DEFAULT_BG);
			graphics.drawRoundRect(0, 0, w + 2 * _margin, h + 2 * _margin, _margin, _margin);
			graphics.endFill();
		}

		/**
		 * 销毁对象
		 */
		public function dispose() : void {
		}
	}
}
