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
	}
}
