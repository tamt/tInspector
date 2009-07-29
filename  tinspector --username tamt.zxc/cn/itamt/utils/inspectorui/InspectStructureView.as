package cn.itamt.utils.inspectorui {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;	

	/**
	 * @author tamt
	 */
	public class InspectStructureView extends Sprite {
		private var _margin : Number = 10;
		private var _target : DisplayObject;
		public function get target():DisplayObject{
			return _target;
		}

		public function InspectStructureView() : void {
			super();
		}

		public function inspect(target : DisplayObject) : void {
			if(_target){
				
			}
			
			_target = target;
			
			//索引出目标的所有"前辈对象".
			var eles : Array = [_target];
			var p : DisplayObject = _target;
			while(p = p.parent) {
				eles.push(p);
			}
			
			//
			var seles : Array = eles.map(buildStructureEle);
			var i : int = seles.length;
			var ele : StructureElement;
			while(i--){
				ele = seles[i] as StructureElement;
				var sp:Sprite = drawStructureEle(ele);
				sp.y = (seles.length-1 - i) * sp.height + _margin;
				sp.x = _margin * ele.level + _margin;
				addChild(sp);
			}
			
			//绘制背景
			drawBG();
		}
		
		private function drawStructureEle(ele : StructureElement):Sprite{
			var sp:Sprite = new Sprite();
			
			var tf:TextField = new TextField();
			tf.autoSize = 'left';
			tf.textColor = InspectorColorStyle.getObjectColor(ele.target);
			tf.text = getClassName(ele.target);
			sp.addChild(tf);
			
			return sp;
		}

		private function getClassName(value : *) : String {
			var str : String = getQualifiedClassName(value);
			return str.slice((str.lastIndexOf('::') >= 0) ? str.lastIndexOf('::') + 2 : 0);
		}

		private function buildStructureEle(ele : DisplayObject, index : uint, arr : Array) : StructureElement {
			return new StructureElement(ele, (arr.length - 1) - index, index == 0);
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
		public function dispose():void{
			
		}
	}
}

import flash.display.DisplayObject;

class StructureElement {
	private var _target : DisplayObject;
	public function get target():DisplayObject{
		return _target;
	}
	private var _isTargetFather : Boolean;
	private var _level : uint;
	public function get level():uint{
		return _level;
	}

	public function StructureElement(target : DisplayObject, level : uint, isTargetFather : Boolean = false) : void {
		_target = target;
		_level = level;
		_isTargetFather = isTargetFather;
	}
	
	public function toString():String{
		return _target.toString() + ' ' + _level + ' ';
	}
}