package cn.itamt.dedo.manager {
	import cn.itamt.dedo.data.DAnimationsCollection;

	/**
	 * @author itamt[at]qq.com
	 */
	public class AnimationsManager {
		private var _animations : DAnimationsCollection;

		public function AnimationsManager(animations : DAnimationsCollection) {
			_animations = animations;
		}

		public function getAnimationTile(index : uint, tick : uint):uint {
			return _animations.getAnimationTile(index, tick);
		}

		/**
		 * @param index		
		 * @param orien		
		 * @param offset		
		 */
		public function getCharacterFrameByOrien(index : uint, orien : uint, offset : Number = NaN):uint {
			var len : uint = _animations.getAnimationTilesLength(index) / 4;
			if(isNaN(offset)) {
				offset = 0;
			} else {
				// if(offset > .5) {
				// offset = -1;
				// } else {
				// offset = 1;
				// }

				offset = Math.round(2 * offset - 1);
			}
			return (orien % (len + 1)) * len + 1 + offset;
		}
	}
}
