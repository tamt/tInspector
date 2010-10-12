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
			var has : Boolean;
			if(charas.length) {
				for(var i : int = 0; i < length; i++) {
					if(area.contains(charas.getCharacterX(i), charas.getCharacterY(i))) {
						has = true;
						break;
					}
				}
			}
			return has;
		}

		public function getCharactersInArea(area : DMapArea):Vector.<uint> {
			var indexs : Vector.<uint> = new Vector.<uint>;
			if(charas.length) {
				for(var i : uint = 0; i < length; i++) {
					if(area.contains(charas.getCharacterX(i), charas.getCharacterY(i))) {
						indexs.push(i);
					}
				}
			}
			return indexs;
		}
	}
}
