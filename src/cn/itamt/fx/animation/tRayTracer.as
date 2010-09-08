package cn.itamt.fx.animation {
	import flash.utils.getDefinitionByName;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * 光线跟踪类, 这是针对于在Flash IDE中制作(引导线)动画而编写的类. 使用时先命名引导元件(影片剪辑), 然后在动画的第一帧上通过代码新建tRayTracer对象.
	 * @author itamt@qq.com
	 */
	public class tRayTracer extends Sprite {
		private var _src : DisplayObject;
		private var _pts : Array;
		private var _leg : uint = 20;
		//源已经是否已经从显示列表中删除.
		private var _isSrcRemoved : Boolean;
		//
		public var color : Number;

		public function tRayTracer(obj : DisplayObject, leg : uint = 0, color : Number = NaN) : void {
			_leg = leg;
			
			_src = obj;
			_src.visible = false;
			_src.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			_src.addEventListener(Event.REMOVED_FROM_STAGE, onSrcRemoved, false, 0, true);
			
			this.color = color;
			if(isNaN(this.color)) {
				var bmd : BitmapData = new BitmapData(1, 1);
				bmd.draw(_src);
				this.color = bmd.getPixel(0, 0);
			}
			this.filters = _src.filters;
			
			_isSrcRemoved = false;
			
			if(_pts == null)_pts = [];
		}

		private function onEnterFrame(evt : Event = null) : void {
			if(!_isSrcRemoved) {
				//如果和上一帧的位置时一样的则不进行绘制.
				//TODO:不过...若是位置没发生变化, 而大小有变化的话...
				if(_pts.length > 0)if(_src.x == _pts[0].x && _src.y == _pts[0].y)return;
				//
				_pts.unshift(new Point(_src.x, _src.y));
				if(_leg > 0) {
					if(_pts.length > _leg)_pts.length = _leg;
				}
				this.drawRay();
			} else {
				_pts.pop();
				if(_pts.length == 0) {
					dispatchEvent(new Event(Event.COMPLETE));
				} else {
					this.drawRay();
				}
			}
		}

		private function drawRay() : void {
			var style : String = tRayStyle.BRUSH;
			var g : Graphics = this.graphics;
			g.clear();
			
			//			this.drawBrush();
			this.drawLine();
			this.drawParticles();
		}

		private function drawParticles() : void {
			var pt : Point = _pts[0];
			var flower : DisplayObject = new (getDefinitionByName('Flower') as Class)();
			flower.x = pt.x;
			flower.y = pt.y;
			_src.parent.addChild(flower);
		}

		private function drawBrush() : void {
			var g : Graphics = this.graphics;
			var i : int = _pts.length;			var l : int = _pts.length;
			//			g.lineStyle(1, 0xff0000);
			g.beginFill(this.color);
			i -= 1;
			g.moveTo(_pts[i].x, _pts[i].y);
			while(i-- > 0) {
				g.lineTo(_pts[i].x - Math.sin(Math.PI * i / l) * _src.height / 2, _pts[i].y - Math.sin(Math.PI * i / l) * _src.height / 2);
			}
			while(++i < l - 1) {
				g.lineTo(_pts[i].x + Math.sin(Math.PI * i / l) * _src.height / 2, _pts[i].y + Math.sin(Math.PI * i / l) * _src.height / 2);
			}
			g.endFill();
		}

		private function drawLine() : void {
			var i : int = _pts.length;
			var g : Graphics = this.graphics;
			g.lineStyle(2, 0xffffff);
			g.moveTo(_pts[i - 1].x, _pts[i - 1].y);
			while(i-- > 0) {
				g.lineTo(_pts[i].x, _pts[i].y);
			}
		}

		private function onSrcRemoved(evt : Event) : void {
			_isSrcRemoved = true;
		}

		public function endAtPrevPoint() : void {
			_isSrcRemoved = true;
			_pts.shift();
			onEnterFrame();
		}

		public function dispose() : void {
			_isSrcRemoved = true;
			_src.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			_src = null;
			_pts = null;
		}
	}
}