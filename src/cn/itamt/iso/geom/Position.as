package cn.itamt.iso.geom
{
	/**
	 * 位置，等同于Point
	 * @author tamt
	 */
	public class Position
	{
		
		protected var _x:Number;
		protected var _y:Number;
		
		public function Position() {
		}

		public function get x() : Number
		{
			return _x;
		}

		public function set x(x : Number) : void
		{
			_x = x;
		}

		public function get y() : Number
		{
			return _y;
		}

		public function set y(y : Number) : void
		{
			_y = y;
		}
		
	}
}
