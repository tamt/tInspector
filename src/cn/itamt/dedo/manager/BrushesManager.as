package cn.itamt.dedo.manager {
	import cn.itamt.dedo.data.DBrushesCollection;

	/**
	 * @author itamt[at]qq.com
	 */
	public class BrushesManager {
		private var brushes : DBrushesCollection;

		public function BrushesManager(brushes : DBrushesCollection):void {
			this.brushes = brushes;
		}
	}
}
