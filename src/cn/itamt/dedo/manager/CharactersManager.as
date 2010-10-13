package cn.itamt.dedo.manager {
	import cn.itamt.dedo.data.DMapArea;
	import cn.itamt.dedo.data.DMapCharactersCollection;

	/**
	 * @author itamt[at]qq.com
	 */
	public class CharactersManager {

		public var charas : DMapCharactersCollection;

		public function CharactersManager(characters : DMapCharactersCollection):void {
			charas = characters;
		}

		public function hasCharacterInArea(area : DMapArea):Boolean {
			return charas.hasCharacterInArea(area);
		}

		public function getCharactersInArea(area : DMapArea):Vector.<uint> {
			return charas.getCharactersInArea(area);
		}
	}
}
