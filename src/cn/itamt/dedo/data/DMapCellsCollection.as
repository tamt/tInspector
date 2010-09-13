package cn.itamt.dedo.data {

	/**
	 * @author itamt[at]qq.com
	 */
	public class DMapCellsCollection extends DCollection {

		private var cells : Vector.<DMapCell>;

		public function DMapCellsCollection() {
			super();
			
			cells = new Vector.<DMapCell>();
		}

		public function getMapCell(index : uint) : DMapCell {
			var cell : DMapCell;
			cell = cells[index];
			return cell;
		}

		public function setMapCell(index : uint, cell : DMapCell) : void {
			cells[index] = cell;			
		}
	}
}
