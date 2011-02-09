package  
{
	import cn.itamt.utils.Debug;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.controls.Slider;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class ProjectionMotionDemo extends Sprite 
	{
		public var startPt_btn:MovieClip;
		public var endPt_btn:MovieClip;
		
		public var speed:Slider;
		public var degree:Number = 60;
		public var v:Number;
		//重力加速度
		var g:Number = .2;
		//风力加速度
		var f:Number = .01;
		//方向, 1:[start>>>>>>end], -1:[end<<<<<<start]
		var direction:int = 1;
		
		public function ProjectionMotionDemo() 
		{
			startPt_btn.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			startPt_btn.addEventListener(MouseEvent.MOUSE_UP, onUp);
			endPt_btn.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			endPt_btn.addEventListener(MouseEvent.MOUSE_UP, onUp);
			
			speed.addEventListener(Event.CHANGE, onSpeedChange);
			
			caculate();
			draw();
		}
		
		private function onSpeedChange(e:Event):void 
		{
			caculate();
			draw();
		}
		
		private function onUp(e:MouseEvent):void 
		{
			(e.target as MovieClip).stopDrag();
			
			caculate();
			draw();
		}
		
		private function caculate():void 
		{
			//方向
			direction = startPt_btn.x < endPt_btn.x? 1: -1;
			
			var theta:Number = degree * Math.PI / 180;
			//求出speed的值
			var A:Number = endPt_btn.x - startPt_btn.x;
			var B:Number = endPt_btn.y - startPt_btn.y;
			var C:Number = direction * Math.cos(theta);
			var D:Number = -Math.sin(theta);
			var E:Number = .5 * this.f;
			var F:Number = .5 * this.g;
			var G:Number = (A * D - B * C) / (B * E-A * F);
			
			speed.value = Math.sqrt(A / (C * G + E * G * G));
		}
		
		private function onDown(e:MouseEvent):void 
		{
			(e.target as MovieClip).startDrag();
		}
		
		private function draw():void 
		{
			this.graphics.clear();
			this.graphics.lineStyle(1, 0x999999);
			this.graphics.moveTo(this.startPt_btn.x, this.startPt_btn.y);
			
			var finish:Boolean = false;
			var t:int = 0;
			var theta:Number = degree * Math.PI / 180;
			var topest:Boolean = false;
			var lx:Number, ly:Number;
			while (!finish) {
				var xt:Number = direction * speed.value * Math.cos(theta) * t + .5 * f * t * t + startPt_btn.x;
				var yt:Number = -speed.value * Math.sin(theta) * t + .5 * g * t * t + startPt_btn.y;
				//trace(xt, yt);
				
				if (!topest && !isNaN(lx) && !isNaN(ly)) {
					if (yt > ly)topest = true;
				}
				
				t++;
				if (topest && yt>endPt_btn.y) {
					finish = true;
				}
				
				this.graphics.lineTo(xt, yt);
				
				lx = xt;
				ly = yt;
			}
			
			//this.graphics.lineTo(this.endPt_btn.x, this.endPt_btn.y);
		}
		
	}

}