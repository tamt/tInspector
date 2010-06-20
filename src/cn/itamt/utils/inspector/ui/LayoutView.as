package cn.itamt.utils.inspector.ui {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;	

	/**
	 * 显示一个对象在舞台中的布局请况.
	 * @author tamt
	 */
	public class LayoutView extends Sprite {
		public static const INSPECT : String = 'inspect';
		public static const LIVE_INSPECT : String = 'live_inspect';
		private var _target : DisplayObject;
		private var _width : Number = 120, _height : Number = 120;
		private var _margin : Number = 10;

		public function get target() : DisplayObject {
			return _target;
		}

		public function LayoutView() {
			super();
			
			this.mouseEnabled = false;
			//绘制背景
			this.graphics.beginFill(InspectorColorStyle.DEFAULT_BG);
			this.graphics.drawRoundRect(0, 0, _width, _height, 10, 10);
			this.graphics.endFill();
			
			addEventListener(MouseEvent.MOUSE_OVER, onRollOver);			addEventListener(MouseEvent.MOUSE_OUT, onRollOut);
			addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onRollOver(evt : MouseEvent) : void {
			if(evt.target is DisplayObjectLayoutSymbol) {
				var dols : DisplayObjectLayoutSymbol = evt.target as DisplayObjectLayoutSymbol;
				if(!(dols.symbolTo is Stage)) {
					dols.applyMouseOverStyle();
					_target = (evt.target as DisplayObjectLayoutSymbol).symbolTo;
					dispatchEvent(new Event(LayoutView.LIVE_INSPECT));
				}
			}
		}

		private function onRollOut(evt : MouseEvent) : void {
			if(evt.target is DisplayObjectLayoutSymbol) {
				var dols : DisplayObjectLayoutSymbol = evt.target as DisplayObjectLayoutSymbol;
				dols.applyMouseOutStyle();
			}
		}

		private function onClick(evt : MouseEvent) : void {
			if(evt.target is DisplayObjectLayoutSymbol) {
				if(!((evt.target as DisplayObjectLayoutSymbol).symbolTo is Stage)) {
					
					this.mouseEnabled = true;
					this.mouseChildren = false;
					this.addEventListener(MouseEvent.ROLL_OVER, onEnableMouseChildren);
					
					_target = (evt.target as DisplayObjectLayoutSymbol).symbolTo;
					dispatchEvent(new Event(LayoutView.INSPECT));
				}
			}
		}

		private function onEnableMouseChildren(evt : MouseEvent = null) : void {
			this.mouseEnabled = false;
			this.mouseChildren = true;
		}

		public function inspect(target : DisplayObject) : void {
			//清除旧的画线
			if(_target) {
				while(numChildren) {
					removeChildAt(0);
				}
			}
			
			_target = target;
			//绘制stage框线
			var eles : Array = [_target];
			var p : DisplayObject = _target;
			while(p = p.parent) {
				eles.push(p);
			}
			
			var i : int = eles.length;
			var sp : DisplayObjectLayoutSymbol;
			while(i--) {
				sp = drawBound(eles.length - 1 - i, eles.length, eles[i] as DisplayObject);
				addChild(sp);
			}
		}

		public function dispose() : void {
			removeEventListener(MouseEvent.MOUSE_OVER, onRollOver);
		}

		private function drawBound(level : int, totalLevel : int, src : DisplayObject) : DisplayObjectLayoutSymbol {
			var w : Number, h : Number;
			var lineColor : uint = 0;
			
			if(level == 0) {
				w = _width - _margin;
				h = _height - _margin;
			}else {
				w = _width - _margin - level * (_width - 20) / totalLevel;				h = _height - _margin - level * (_height - 20) / totalLevel;
			}
			
			lineColor = InspectorColorStyle.getObjectColor(src);
			
			var sp : DisplayObjectLayoutSymbol = new DisplayObjectLayoutSymbol(src, lineColor, w, h, level == totalLevel - 1);
			sp.x = _width / 2 - sp.width / 2;
			sp.y = _height / 2 - sp.height / 2;
			
			return sp;
		}

	}
}

import flash.display.DisplayObject;
import flash.display.Sprite;

class DisplayObjectLayoutSymbol extends Sprite {
	private var _symbolTo : DisplayObject;

	public function get symbolTo() : DisplayObject {
		return _symbolTo;
	}

	private var _lineColor : uint;
	private var _w : Number;
	private var _h : Number;
	private var _topest : Boolean;

	public function DisplayObjectLayoutSymbol(symbolTo : DisplayObject, lineColor : uint, w : Number, h : Number, topest : Boolean = false) : void {
		super();
		
		_symbolTo = symbolTo;
		_lineColor = lineColor;
		_w = w;
		_h = h;
		_topest = topest;
		
		applyMouseOutStyle();
	}

	public function applyMouseOutStyle() : void {
		graphics.clear();
		graphics.lineStyle(1, _lineColor);
		graphics.beginFill(_lineColor, _topest ? .6 : 0);
		graphics.drawRect(0, 0, _w, _h);
		graphics.endFill();
	}

	public function applyMouseOverStyle() : void {
		graphics.clear();
		graphics.lineStyle(1, _lineColor);
		graphics.beginFill(_lineColor, _topest ? .6 : .3);
		graphics.drawRect(0, 0, _w, _h);
		graphics.endFill();
	}
}