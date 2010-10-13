package cn.itamt.dedo.data {

	/**
	 * @author itamt[at]qq.com
	 */
	public class DMapCellsCollection extends DCollection {
		private var cellsX : Vector.<uint>;
		private var cellsY : Vector.<uint>;
		private var cellsImgOrAni : Vector.<int>;
		private var cellsValue : Vector.<uint>;
		private var anis : Vector.<uint>;

		public function DMapCellsCollection() {
			super();

			cellsX = new Vector.<uint>();
			cellsY = new Vector.<uint>();
			cellsImgOrAni = new Vector.<int>();
			cellsValue = new Vector.<uint>();
			anis = new Vector.<uint>();
		}

		public function setMapCell(index : uint, x : uint, y : uint, imgOrAni : int, value : uint) : void {
			cellsX[index] = x;
			cellsY[index] = y;
			cellsImgOrAni[index] = imgOrAni;
			cellsValue[index] = value;

			if(imgOrAni < -1000) {
				anis.push(index);
			}
		}

		public function getMapCellX(index : uint):uint {
			return cellsX[index];
		}

		public function getMapCellY(index : uint):uint {
			return cellsY[index];
		}

		public function getMapCellImg(index : uint):int {
			return cellsImgOrAni[index];
		}

		public function getMapCellValue(index : uint):uint {
			return cellsValue[index];
		}

		public function getMapCellFrame(index : uint) : uint {
			return 0;
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
		 * 根据位置得到cell index;
		 */
		public function getMapCellByPos(posX : uint, posY : uint) : int {
			for(var i : int = 0; i < length; i++) {
				if((getMapCellX(i) == posX) && (getMapCellY(i) == posY)) {
					return i;
				}
			}

			return -1;
		}

		/**
		 * 根据
		 */
		public function getMapCellByWorldPos(worldX : Number, worldY : Number):Vector.<int> {
			var cells : Vector.<int> = new Vector.<int>;
			cells.push(getMapCellByPos(Math.ceil(worldX), Math.ceil(worldY)));
			cells.push(getMapCellByPos(Math.floor(worldX), Math.floor(worldY)));
			cells.push(getMapCellByPos(Math.floor(worldX), Math.ceil(worldY)));
			cells.push(getMapCellByPos(Math.ceil(worldX), Math.floor(worldY)));
			return cells;
		}
	}
}
