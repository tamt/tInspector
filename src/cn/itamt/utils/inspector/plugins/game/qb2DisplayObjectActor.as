package cn.itamt.utils.inspector.plugins.game
{
	import As3Math.geo2d.amPoint2d;

	import QuickB2.misc.acting.qb2IActor;
	import QuickB2.misc.acting.qb2IActorContainer;
	import QuickB2.misc.acting.qb2_flashActorUtils;

	import cn.itamt.utils.DisplayObjectTool;

	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author tamt
	 */
	public class qb2DisplayObjectActor implements qb2IActor
	{
		private var dp : DisplayObject;

		public function qb2DisplayObjectActor(dp : DisplayObject)
		{
			this.dp = dp;
		}

		public function getX() : Number
		{
			var rect : Rectangle = this.dp.getRect(this.dp);
			var pos : Point = this.getDpMx().transformPoint(rect.topLeft);
			return pos.x;
		}

		public function setX(value : Number) : qb2IActor
		{
			var gPos : Point = new Point(value, this.getY());
			var mx : Matrix = this.getDpMx().clone();
			mx.invert();
			var pos : Point = mx.transformPoint(gPos);
			var tmx : Matrix = this.dp.transform.matrix.clone();
			tmx.tx = pos.x - this.dp.getRect(this.dp).x;
			tmx.ty = pos.x - this.dp.getRect(this.dp).x;
			this.dp.transform.matrix = tmx;
			return this;
		}

		public function getY() : Number
		{
			var rect : Rectangle = this.dp.getRect(this.dp);
			var pos : Point = this.getDpMx().transformPoint(rect.topLeft);
			return pos.y;
		}

		private function getDpMx() : Matrix
		{
			var mx : Matrix = DisplayObjectTool.getConcatenatedMatrix(this.dp);
			return mx;
		}

		public function setY(value : Number) : qb2IActor
		{
			var gPos : Point = new Point(this.getX(), value);
			var mx : Matrix = this.getDpMx().clone();
			mx.invert();
			var pos : Point = mx.transformPoint(gPos);
			var tmx : Matrix = this.dp.transform.matrix.clone();
			tmx.tx = pos.x - this.dp.getRect(this.dp).x;
			tmx.ty = pos.x - this.dp.getRect(this.dp).x;
			this.dp.transform.matrix = tmx;
			return this;
		}

		public function getPosition() : amPoint2d
		{
			return new amPoint2d(this.dp.x, this.dp.y);
		}

		public function setPosition(point : amPoint2d) : qb2IActor
		{
			this.dp.x = point.x;
			this.dp.y = point.y;
			return this;
		}

		public function getRotation() : Number
		{
			return this.dp.rotation;
		}

		public function setRotation(value : Number) : qb2IActor
		{
			var gPos : Point = new Point(this.getX(), value);
			var mx : Matrix = this.getDpMx().clone();
			mx.invert();
			var tmx : Matrix = this.dp.transform.matrix.clone();
			tmx.rotate(value);
			this.dp.transform.matrix = tmx;
			return this;
		}

		public function scaleBy(xValue : Number, yValue : Number) : qb2IActor
		{
			qb2_flashActorUtils.scaleActor(this.dp, xValue, yValue);
			return this;
		}

		public function getParentActor() : qb2IActorContainer
		{
			// TODO: Auto-generated method stub
			return null;
		}

		public function clone(deep : Boolean = true) : qb2IActor
		{
			// TODO: Auto-generated method stub
			return null;
		}
	}
}
