package cn.itamt.dedo.data {

	/**
	 * @author itamt[at]qq.com
	 */
	public class DMapCellsCollection extends DCollection {

		private var cellsX : Vector.<uint>;		private var cellsY : Vector.<uint>;		private var cellsImg : Vector.<uint>;		private var cellsValue : Vector.<uint>;

		public function DMapCellsCollection() {
			super();
			
			cellsX = new Vector.<uint>();
			cellsY = new Vector.<uint>();
			cellsImg = new Vector.<uint>();
			cellsValue = new Vector.<uint>();
		}

		public function setMapCell(index : uint, x : uint, y : uint, img : uint, value : uint) : void {
			cellsX[index] = x;
			cellsY[index] = y;
			cellsImg[index] = img;
			cellsValue[index] = value;			
		}
	}
}
