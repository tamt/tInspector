package  
{
	import cn.itamt.utils.Debug;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class ProjectionMotionDemo extends Sprite 
	{
		public var startPt_btn:MovieClip;
		public var endPt_btn:MovieClip;
		
		public var degree:Number = 60;
		public var v:Number;
		
		public function ProjectionMotionDemo() 
		{
			addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			addEventListener(MouseEvent.MOUSE_UP, onUp);
		}
		
		private function onUp(e:MouseEvent):void 
		{
			(e.target as MovieClip).stopDrag();
			
			caculate();
			draw();
		}
		
		private function caculate():void 
		{
			var s1:Number = startPt_btn.y - endPt_btn.y;
			var s2:Number = startPt_btn.x - endPt_btn.x;
			var a1:Number = -9.8;
			var a2:Number = 1;
			var dain:Number = degree * Math.PI / 180;
			this.v = .5 * (s2 * a1 - s1 * a2) / (s1 * Math.cos(dain) - s2 * Math.sin(dain));
			Debug.trace(v.toString());
		}
		
		private function onDown(e:MouseEvent):void 
		{
			(e.target as MovieClip).startDrag();
		}
		
		private function draw():void 
		{
			
		}
		
	}

}