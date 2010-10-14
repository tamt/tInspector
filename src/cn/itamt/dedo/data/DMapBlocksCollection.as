package cn.itamt.dedo.data {
	/**
	 * @author itamt[qt]qq.com
	 */
	public class DMapBlocksCollection extends DCollection {

		private var _cellsX : Vector.<uint>;
		private var _cellsY : Vector.<uint>;
		private var _imgs : Vector.<uint>;

		public function DMapBlocksCollection() {
			super();

			_cellsX = new Vector.<uint>;
			_cellsY = new Vector.<uint>;
			_imgs = new Vector.<uint>;
		}

		public function get length():uint {
			return _imgs.length;
		}

		public function setBlock(index : uint, img : uint, x : uint, y : uint) : void {
			_cellsX[index] = x;
			_cellsY[index] = y;
			_imgs[index] = img;
		}

		public function contains(posX : uint, posY : uint):Boolean {
			return getPosIsBlock(posX, posY);
		}

		public function getPosIsBlock(posX : uint, posY : uint):Boolean {
			for(var i : int = 0; i < length; i++) {
				if(_cellsX[i] == posX && _cellsY[i] == posY) {
					return true;
				}
			}

			return false;
		}
	}
}
