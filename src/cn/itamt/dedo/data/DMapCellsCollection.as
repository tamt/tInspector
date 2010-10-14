package cn.itamt.dedo.data {

	/**
	 * @author itamt[at]qq.com
	 */
	public class DMapCellsCollection extends DCollection {
		private var cellsX : Vector.<uint>;
		private var cellsY : Vector.<uint>;
		private var cellsImg : Vector.<uint>;
		private var cellsValue : Vector.<uint>;
		private var anis : Vector.<uint>;
		private var cellsIsAni : Vector.<Boolean>;

		public function DMapCellsCollection() {
			super();

			cellsX = new Vector.<uint>();
			cellsY = new Vector.<uint>();
			cellsImg = new Vector.<uint>();
			cellsValue = new Vector.<uint>();
			cellsIsAni = new Vector.<Boolean>();
			anis = new Vector.<uint>();
		}

		public function setMapCell(index : uint, x : uint, y : uint, img : uint, value : uint, isAnimation : Boolean = false) : void {
			cellsX[index] = x;
			cellsY[index] = y;
			cellsImg[index] = img;
			cellsValue[index] = value;
			cellsIsAni[index] = isAnimation;

			if(isAnimation) {
				anis.push(index);
			}
		}

		public function getMapCellX(index : uint):uint {
			return cellsX[index];
		}

		public function getMapCellY(index : uint):uint {
			return cellsY[index];
		}

		public function getMapCellImg(index : uint):uint {
			return cellsImg[index];
		}

		public function getMapCellValue(index : uint):uint {
			return cellsValue[index];
		}

		public function getMapCellIsAnimation(index : int):Boolean {
			return cellsIsAni[index];
		}

		/**
		 * 返回在某个区域内是不是含有动画元素
		 */
		public function hasAnimationInArea(area : DMapArea):Boolean {
			var has : Boolean;
			if(anis.length) {
				for(var i : int = 0; i < anis.length; i++) {
					if(area.contains(this.getMapCellX(anis[i]), this.getMapCellY(anis[i]))) {
						has = true;
						break;
					}
				}
			}
			return has;
		}

		public function get length():uint {
			return cellsX.length;
		}

		/**
		 * 根据
		 */
		public function getMapCellByWorldPos(worldX : Number, worldY : Number):Vector.<uint> {
			var cells : Vector.<uint> = new Vector.<uint>;
			// cells.push(getMapCellByPos(Math.ceil(worldX), Math.ceil(worldY)));
			// cells.push(getMapCellByPos(Math.floor(worldX), Math.floor(worldY)));
			// cells.push(getMapCellByPos(Math.floor(worldX), Math.ceil(worldY)));
			// cells.push(getMapCellByPos(Math.ceil(worldX), Math.floor(worldY)));
			for(var i : int = 0; i < length; i++) {
				if(((getMapCellX(i) == Math.ceil(worldX)) && (getMapCellY(i) == Math.ceil(worldY))) || ((getMapCellX(i) == Math.floor(worldX)) && (getMapCellY(i) == Math.floor(worldY))) || ((getMapCellX(i) == Math.floor(worldX)) && (getMapCellY(i) == Math.ceil(worldY))) || ((getMapCellX(i) == Math.ceil(worldX)) && (getMapCellY(i) == Math.floor(worldY)))) {
					cells.push(i);
				}
			}
			return cells;
		}
	}
}
