package cn.itamt.dedo.manager {
	import cn.itamt.dedo.data.DMap;
	import cn.itamt.dedo.data.DMapsCollection;

	/**
	 * @author itamt[at]qq.com
	 */
	public class MapsManager {
		private var maps : DMapsCollection;

		public function MapsManager(maps : DMapsCollection) : void {
			this.maps = maps;
		}

		public function getMap(index : uint) : DMap {
			return this.maps.getMap(index);
		}
	}
}