package cn.itamt.dedo {
	import cn.itamt.dedo.manager.AnimationsManager;
	import cn.itamt.dedo.manager.BrushesManager;
	import cn.itamt.dedo.manager.MapsManager;
	import cn.itamt.dedo.manager.TilesManager;

	/**
	 * 整个DedoProject
	 * @author itamt[at]qq.com
	 */
	public class DedoProject {
		public var name : String;
		public var version : String;
		public var cellwidth : uint;
		public var cellheight : uint;

		public var animationsMgr : AnimationsManager;
		public var brushesMgr : BrushesManager;
		public var mapsMgr : MapsManager;
		public var tilesMgr : TilesManager;

		public function DedoProject() : void {
		}
	}
}
