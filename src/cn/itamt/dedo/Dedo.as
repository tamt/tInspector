package cn.itamt.dedo {
	import cn.itamt.dedo.data.DedoCoord;

	import de.polygonal.ds.Array2;

	/**
	 * @author itamt[at]qq.com
	 */
	public class Dedo {

		public var coords : Array2;
		protected var w : uint = 10;
		protected var h : uint = 10;

		/**
		 * 地图
		 * @param w		长度(单位:单元格)
		 * @param h		高度(单位:单元格)
		 */
		public function Dedo(w : uint = 10, h : uint = 10) : void {
			if(w > 0 && h > 0) {
				coords = new Array2(w, h);
				this.w = w;
				this.h = h;
			}
		}

		/**
		 * 简单的生成地形
		 */
		public function generateTerrain() : void {
			for(var y : int = 0;y < coords.height;y++) {
				for(var x : int = 0;x < coords.width;x++) {
					coords.set(x, y, new DedoCoord(x, y, []));
				}
			}
		}
	}
}
	