package cn.itamt.fx {
	import fl.controls.CheckBox;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;	

	public class WobbleEffectDemo extends Sprite {
		private const IMAGE_URL : String = "window.png";
		private var IMG_W : int;
		private var IMG_H : int;
		private var SEGMENT : int = 5;
		private var loader : Loader;
		private var vertexs : Array;
		private var tVertexs : Array;
		private var sprite : Sprite;
		private var deltas : Array;

		private var vertices : Vector.<Number> = new Vector.<Number>();
		private	var indices : Vector.<int> = new Vector.<int>();
		private	var uvtData : Vector.<Number> = new Vector.<Number>();

		//各点的tween运动采用不同的持续时间
		public var cb_dDuration : CheckBox;
		//各点的tween运动采用相同的持续时间
		public var cb_dDelay : CheckBox;
		//ease类型
		public var cb_ease : ComboBox;		public var cb_inOut : ComboBox;

		public function WobbleEffectDemo() : void {
			stage.quality = StageQuality.MEDIUM;
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, compHandler);
			loader.load(new URLRequest(IMAGE_URL));
			addChild(loader);
			
			cb_ease.dataProvider = new DataProvider(new Array({label:'Back'}, {label:'Bounce'}, {label:'Circ'}, {label:'Cubic'}, {label:'Elastic'}, {label:'Expo'}, {label:'Linear'}, {label:'Quad'}, {label:'Quart'}, {label:'Quint'}, {label:'Sine'}, {label:'Strong'}));
			cb_ease.selectedIndex = 10;
			cb_inOut.dataProvider = new DataProvider(new Array({label:'.easein'}, {label:'.easeout'}, {label:'.easeinout'}));
			cb_inOut.selectedIndex = 1;
		}

		private function compHandler(e : Event) : void {
			var eff : WobbleEffect = new WobbleEffect(this.loader.content);
			eff.apply();
			
//			removeChild();
			IMG_W = (loader.content as Bitmap).bitmapData.width;			IMG_H = (loader.content as Bitmap).bitmapData.height;
			
			sprite = new Sprite();
			addChild(sprite);
			vertexs = [];
			tVertexs = [];
			
			var indStep : int;
			for (var xx : int = 0;xx <= SEGMENT; xx++) {
				vertexs[xx] = [];
				tVertexs[xx] = [];
				for (var yy : int = 0;yy <= SEGMENT; yy++) {
					vertexs[xx][yy] = new Point(xx * IMG_W / SEGMENT, yy * IMG_H / SEGMENT);//[xx * IMG_W / SEGMENT, yy * IMG_H/SEGMENT];
					tVertexs[xx][yy] = new Point(xx * IMG_W / SEGMENT, yy * IMG_H / SEGMENT);//[xx * IMG_W / SEGMENT, yy * IMG_H/SEGMENT];

					if(xx < SEGMENT && yy < SEGMENT) {
						uvtData.push(xx / SEGMENT, yy / SEGMENT, (xx + 1) / SEGMENT, yy / SEGMENT, (xx + 1) / SEGMENT, (yy + 1) / SEGMENT, xx / SEGMENT, (yy + 1) / SEGMENT);
						indices.push(indStep, indStep + 1, indStep + 3, indStep + 1, indStep + 2, indStep + 3);
						indStep += 4;
					}
				}
			}
			
			draw();
			
			sprite.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		}

		private var rpt : Point = new Point;

		private function onDown(evt : MouseEvent) : void {
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			
			rpt.x = evt.stageX;
			rpt.y = evt.stageY;
			
			deltas = [];
			for (var xx : int = 0;xx <= SEGMENT; xx++) {
				deltas[xx] = [];
				for (var yy : int = 0;yy <= SEGMENT; yy++) {
					deltas[xx][yy] = [tVertexs[xx][yy].x - rpt.x, tVertexs[xx][yy].y - rpt.y];
				}
			}
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}

		private var tpt : Point = new Point;

		private function onUp(evt : MouseEvent) : void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			
			tpt.x = evt.stageX;
			tpt.y = evt.stageY;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			move();
		}

		private function onMove(evt : MouseEvent) : void {
			tpt.x = evt.stageX;
			tpt.y = evt.stageY;
			
			move();
		}

		private function move() : void {
			var xx : int, yy : int, delay : Number;
			
			for (xx = 0;xx <= SEGMENT; xx++) {
				for (yy = 0;yy <= SEGMENT; yy++) {
					//					tVertexs[xx][yy] = [tpt.x + deltas[xx][yy][0], tpt.y + deltas[xx][yy][1]];
					tVertexs[xx][yy].x = tpt.x + deltas[xx][yy][0];
					tVertexs[xx][yy].y = tpt.y + deltas[xx][yy][1];
					
					delay = Math.sqrt(deltas[xx][yy][0] * deltas[xx][yy][0] + deltas[xx][yy][1] * deltas[xx][yy][1]) / 400;
					
					TweenLite.to(vertexs[xx][yy], cb_dDuration.selected ? delay / 2 : 0, {onUpdate:draw, ease:EaseLookup.find(cb_ease.selectedLabel + cb_inOut.selectedLabel), delay:cb_dDelay.selected ? delay / 50 : 0, x:tVertexs[xx][yy].x, y:tVertexs[xx][yy].y});
				}
			}
		}

		/**
		 * drawTriangles 
		 * 参考： http://wonderfl.net/code/e7e1e28a9f20d73f11f0bb02d3e4b5f512c7cc0f
		 */
		private function draw(e : Event = null) : void {
			vertices = new Vector.<Number>();
			for(var xx : int = 0;xx < SEGMENT; xx++) {
				for(var yy : int = 0;yy < SEGMENT; yy++) {
					vertices.push(vertexs[xx][yy].x, vertexs[xx][yy].y, vertexs[xx + 1][yy].x, vertexs[xx + 1][yy].y, vertexs[xx + 1][yy + 1].x, vertexs[xx + 1][yy + 1].y, vertexs[xx][yy + 1].x, vertexs[xx][yy + 1].y);
				}
			}
			
			var g : Graphics = sprite.graphics;
			g.clear();
			//			g.lineStyle(1);
			g.beginBitmapFill(Bitmap(loader.content).bitmapData);
			g.drawTriangles(vertices, indices, uvtData);
			g.endFill();
		}
	}
}