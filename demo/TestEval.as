package
{
	import r1.deval.D;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author tamt
	 */
	public class TestEval extends Sprite
	{
		public function TestEval()
		{
			Object.prototype.prototype = null;
			D.eval("trace(this);", null, this);
		}
	}
}
