package cn.itamt.fx 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.ConvolutionFilter;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class FlameFire extends Sprite 
	{
		private var _sampleBmd:BitmapData;
		private var _outputBmd:BitmapData;
		private var _perlinBmd:BitmapData;
		
		private var _output:Bitmap;
		//
		private var _offset:Array;
		
		public function FlameFire(sampleBmd:BitmapData) 
		{
			_sampleBmd = sampleBmd;
			_outputBmd = _sampleBmd.clone();
			_perlinBmd = _sampleBmd.clone();
			
			_offset = new Array(new Point(), new Point());
			_output = new Bitmap(_outputBmd);
			addChild(_output);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		private function onRemoved(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			stop();
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.start();
		}
		
		private var _running:Boolean;
		public function start():void {
			if (_running) return;
			_running = true;
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function stop():void {
			_running = false;
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			this.update();
			//this.stop();
		}
		
		public function update():void {
			_outputBmd = _sampleBmd.clone();
			
			var _spreadFilter:ConvolutionFilter	= new ConvolutionFilter(3, 3, [0, 1, 0,  1, 1, 1,  0, 1, 0], 5);
			_outputBmd.applyFilter(_outputBmd, _outputBmd.rect, new Point(), _spreadFilter);
			
			_offset[0].x += 5;
			_offset[1].y += 5;
			_perlinBmd.perlinNoise(100, 100, 2, 100, false, false, 0, true, _offset);
			
			_outputBmd.draw(_perlinBmd, null, null, "subtract");
		}
		
	}

}