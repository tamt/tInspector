package
{
	import cn.itamt.display.IFrame;
	import cn.itamt.display.tSprite;

	import flash.events.MouseEvent;

	/**
	 * @author tamt
	 */
	public class IFrameDemo extends tSprite
	{
		public function IFrameDemo()
		{
			this.graphics.beginFill(0xff0000);
			this.graphics.drawCircle(0, 0, 100);
			this.graphics.endFill();
		}

		override protected function onAdded() : void
		{
			super.onAdded();

			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, buildIFrame);
		}

		private function buildIFrame(event : MouseEvent) : void
		{
			var iframe : IFrame = new IFrame('IFrameContainer', 800, 600);
			addChild(iframe);
			iframe.src = 'http://www.baidu.com';
			iframe.x = 100;
			iframe.y = 100;
		}
	}
}
