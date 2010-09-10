package cn.itamt.fx {
	import cn.itamt.fx.core.Effect;
	import cn.itamt.utils.DisplayObjectTool;

	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.actuators.GenericActuator;
	import com.eclecticdesignstudio.motion.easing.Back;
	import com.eclecticdesignstudio.motion.easing.IEasing;
	import com.eclecticdesignstudio.motion.easing.Sine;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author itamt@qq.com
	 */
	public class WobbleEffect extends Effect {

		private var vertices : Vector.<Number>;
		private	var indices : Vector.<int>;
		private	var uvtData : Vector.<Number>;
		private var vertexs : Array;
		private var tVertexs : Array;
		private var IMG_W : int;
		private var IMG_H : int;
		private var sprite : Sprite;
		private var bmd : BitmapData;
		private var deltas : Array;
		private var delays : Array;
		private var _moving : Boolean;

		public function get moving() : Boolean {
			return _moving;
		}

		public var grid : Boolean = false;
		public var smooth : Boolean = true;

		private var matrix : Matrix = new Matrix();

		private var _filters : Array;

		public function set filters(val : Array) : void {
			_filters = val;
			
			if(this.sprite) {
				this.sprite.filters = _filters;
			}
		}

		public function get filters() : Array {
			return _filters;
		}

		public function WobbleEffect(tg : DisplayObject) : void {
			super(tg);
		}

		private var _visible : Boolean = true;

		public function set visible(val : Boolean) : void {
			_visible = val;
			if(this.sprite) {
				this.sprite.visible = _visible;
			}
		}

		public function get x() : Number {
			return tVertexs[0][0].x;
		}

		public function get y() : Number {
			return tVertexs[0][0].y;
		}

		/**
		 * 开始使用效果.
		 */
		override public function apply() : void {

			if(bmd)bmd.dispose();
			if(_target is Bitmap) {
				bmd = (_target as Bitmap).bitmapData.clone();
			} else {
				_filters = _target.filters;
				_target.filters = null;
				bmd = snap(_target);
				_target.filters = _filters;
			}
			IMG_W = bmd.width;
			IMG_H = bmd.height;
			
			vertices = new Vector.<Number>();
			indices = new Vector.<int>();
			uvtData = new Vector.<Number>();
			vertexs = [];
			tVertexs = [];
			
			sprite = new Sprite();
			//			sprite.mouseChildren = sprite.mouseEnabled = false;
			//			sprite.addEventListener(MouseEvent.MOUSE_DOWN, onDown);			//			sprite.addEventListener(MouseEvent.MOUSE_UP, onUp);
			sprite.visible = _visible;
			sprite.filters = _filters;
			_target.parent.addChildAt(sprite, _target.parent.getChildIndex(_target) + 1);
			//			stage.addChild(sprite);
			sprite.transform.matrix = this.matrix;
						var pt : Point = _target.getBounds(_target).topLeft;
						
			var indStep : int;
			for (var xx : int = 0;xx <= _segmenth;xx++) {
				vertexs[xx] = [];
				tVertexs[xx] = [];
				for (var yy : int = 0;yy <= _segmentv;yy++) {
					var ratioOffsetX : Number = ((xx + .5) / _segmenth) * (_segmenth / IMG_W);					var ratioOffsetY : Number = ((yy + .5) / _segmentv) * (_segmentv / IMG_H);
					vertexs[xx][yy] = new Point(pt.x + xx * IMG_W / _segmenth, pt.y + yy * IMG_H / _segmentv);
					tVertexs[xx][yy] = new Point(pt.x + xx * IMG_W / _segmenth, pt.y + yy * IMG_H / _segmentv);

					if(xx < _segmenth && yy < _segmentv) {
						uvtData.push((xx + ratioOffsetX) / _segmenth, (yy + ratioOffsetY) / _segmentv, (xx + ratioOffsetX + 1) / _segmenth, (yy + ratioOffsetY) / _segmentv, (xx + ratioOffsetX + 1) / _segmenth, (yy + ratioOffsetY + 1) / _segmentv, (xx + ratioOffsetX) / _segmenth, (yy + ratioOffsetY + 1) / _segmentv);
						indices.push(indStep, indStep + 1, indStep + 3, indStep + 1, indStep + 2, indStep + 3);
						indStep += 4;
					}
				}
			}
			
			//			draw();
			invalidate();
		}

		private var rpt : Point = new Point;

		public function onDown(evt : MouseEvent) : void {
			rpt.x = sprite.mouseX;
			rpt.y = sprite.mouseY;
			
			deltas = [];
			delays = [];
			
			var c : Number = Math.sqrt(bmd.width * bmd.width + bmd.height * bmd.height);
			for (var xx : int = 0;xx <= _segmenth;xx++) {
				deltas[xx] = [];
				delays[xx] = [];
				for (var yy : int = 0;yy <= _segmentv;yy++) {
					deltas[xx][yy] = [tVertexs[xx][yy].x - rpt.x, tVertexs[xx][yy].y - rpt.y];
					var t : Number = Math.sqrt(deltas[xx][yy][0] * deltas[xx][yy][0] + deltas[xx][yy][1] * deltas[xx][yy][1]);
					delays[xx][yy] = _duration * t / c ;
				}
			}
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}

		private var tpt : Point = new Point;

		public function onUp(evt : MouseEvent) : void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			if(_moving)move(true);
			if(maxDelay) {
				Actuate.timer(maxDelay).onComplete(onTweenFinish);
			} else {
				onTweenFinish();
			}
		}

		public function onMove(evt : MouseEvent) : void {
			tpt.x = sprite.mouseX;
			tpt.y = sprite.mouseY;
			
			move();
		}

		private function onTweenFinish() : void {
			_moving = false;
			dispatchEvent(new Event(Event.COMPLETE));
		}

		private var maxDelay : Number = 0;

		private function move(overwrite : Boolean = false) : void {
			_moving = true;
			
			var xx : int, yy : int, delay : Number = 0;
			for (xx = 0;xx <= _segmenth;xx++) {
				for (yy = 0;yy <= _segmentv;yy++) {
					tVertexs[xx][yy].x = tpt.x + deltas[xx][yy][0];
					tVertexs[xx][yy].y = tpt.y + deltas[xx][yy][1];
					
					delay = delays[xx][yy];
					
					Actuate.tween(vertexs[xx][yy], delay, {x:tVertexs[xx][yy].x, y:tVertexs[xx][yy].y}, overwrite).ease(_ease).onUpdate(invalidate);

					maxDelay = Math.max(delay, maxDelay);
				}
			}
		}

		private var needValidate : Boolean = false;

		private function invalidate() : void {
			if(!needValidate) {
				needValidate = true;
				this.stage.invalidate();
				this.stage.addEventListener(Event.RENDER, onStageRender);
			}
		}

		private function onStageRender(event : Event) : void {
			if(needValidate) {
				needValidate = false;
				draw();
			}
		}

		
		private function draw(e : Event = null) : void {
			if(vertexs == null)return;
			vertices = new Vector.<Number>();
			for(var xx : int = 0;xx < _segmenth;xx++) {
				for(var yy : int = 0;yy < _segmentv;yy++) {
					vertices.push(vertexs[xx][yy].x, vertexs[xx][yy].y, vertexs[xx + 1][yy].x, vertexs[xx + 1][yy].y, vertexs[xx + 1][yy + 1].x, vertexs[xx + 1][yy + 1].y, vertexs[xx][yy + 1].x, vertexs[xx][yy + 1].y);
				}
			}
			
			var g : Graphics = sprite.graphics;
			g.clear();
			if(grid)g.lineStyle(1);
			g.beginBitmapFill(bmd, null, false, smooth);
			g.drawTriangles(vertices, indices, uvtData);
			g.endFill();
		}

		protected function snap(dp : DisplayObject) : BitmapData {
			var bmd : BitmapData;
			var bounds : Rectangle = dp.getBounds(dp);
			bmd = new BitmapData(bounds.width, bounds.height, true, 0x00ff0000);
			bmd.draw(dp, new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y));
			
			//			this.matrix = _target.transform.concatenatedMatrix;
			this.matrix = DisplayObjectTool.getConcatenatedMatrix(_target);
			var t : Matrix = DisplayObjectTool.getConcatenatedMatrix(_target.parent);
			t.invert();
			this.matrix.concat(t);
			
			return bmd;
		}

		override public function dispose() : void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);

			_moving = false;

			vertices = null;
			indices = null;
			uvtData = null;
			vertexs = null;
			tVertexs = null;
			deltas = null;
			delays = null;
			if(bmd)bmd.dispose();
			bmd = null;
			
			if(sprite) {
				if(sprite.stage) {
					sprite.parent.removeChild(sprite);
				}
			}
			
			sprite = null;
		}

		//////////////////////////////////////
		////////////setter, getter////////////
		//////////////////////////////////////
		private var _segmentv : int = 5;

		public function set segmentsv(val : uint) : void {
			_segmentv = val;
		}

		public function get segmentsv() : uint {
			return _segmentv;
		}

		private var _segmenth : int = 5;

		public function set segmentsh(val : uint) : void {
			_segmenth = val;
		}

		public function get segmentsh() : uint {
			return _segmenth;
		}

		protected var _ease : IEasing;

		public function set ease(fun : IEasing) : void {
			if(fun == null) {
				if(_ease == null) {
					_ease = Back.easeOut;
				}
			} else {
				_ease = fun;
			}
		}

		public function get ease() : IEasing {
			return _ease;
		}

		protected var _duration : Number = 1;

		public function set duration(val : Number) : void {
			_duration = val;
		}

		public function get duration() : Number {
			return _duration;
		}

		//////////////////////////////////////
		/////////public functions/////////////
		//////////////////////////////////////
		
		/**
		 * 调整尺寸
		 * @param rect		要resize到的区域, 注意是相对于target的rect.
		 */
		public function resize(trect : Rectangle) : void {
			var rect : Rectangle = new Rectangle();
			//			var mx : Matrix = this.matrix.clone();			var mx : Matrix = DisplayObjectTool.getConcatenatedMatrix(sprite);
			mx.invert();
			rect.topLeft = mx.transformPoint(trect.topLeft);			rect.bottomRight = mx.transformPoint(trect.bottomRight);
			
			var xx : int, yy : int, delay : Number = 0;
			
			rpt.x = rect.x;
			rpt.y = rect.y;
			
			deltas = [];
			delays = [];
						var c : Number = NaN;
			for (xx = 0;xx <= _segmenth;xx++) {
				deltas[xx] = [];
				delays[xx] = [];
				for (yy = 0;yy <= _segmentv;yy++) {
					tVertexs[xx][yy] = new Point(rect.x + xx * rect.width / _segmenth, rect.y + yy * rect.height / _segmentv);
					deltas[xx][yy] = [tVertexs[xx][yy].x - vertexs[xx][yy].x, tVertexs[xx][yy].y - vertexs[xx][yy].y];
					
					if(isNaN(c))c = Math.sqrt(deltas[0][0][0] * deltas[0][0][0] + deltas[0][0][1] * deltas[0][0][1]);
					
					var t : Number = Math.sqrt(deltas[xx][yy][0] * deltas[xx][yy][0] + deltas[xx][yy][1] * deltas[xx][yy][1]);
					delays[xx][yy] = .2 * _duration * t / c + t * (_duration / 1000);

					delay = delays[xx][yy];
					
					Actuate.tween(vertexs[xx][yy], delay, {x:tVertexs[xx][yy].x, y:tVertexs[xx][yy].y}, true).onUpdate(draw).onComplete(onTweenFinish);

					maxDelay = Math.max(delay, maxDelay);
				}
			}
		}
	}
}
