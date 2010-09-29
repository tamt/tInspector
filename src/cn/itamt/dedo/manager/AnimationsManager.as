package cn.itamt.dedo.manager {
	import cn.itamt.dedo.data.DAnimationsCollection;

	import flash.geom.Rectangle;

	/**
	 * @author itamt[at]qq.com
	 */
	public class AnimationsManager {
		private var _animations : DAnimationsCollection;

		public function AnimationsManager(animations : DAnimationsCollection) {
			_animations = animations;
		}

		public function getAnimationTile(index : uint, frame : uint):uint {
			return _animations.getAnimationTile(index, frame);
		}

		public function getAnimationCurFrame(index : uint) : uint {
			return _animations.getAnimationCurFrame(index);
		}
	}
}
