package transform3d.consts 
{
	/**
	 * transform's tool mode.
	 * @author tamt
	 */
	public class TransformToolMode
	{
		public static const ALL:String = "all";
		public static const ROTATION:String = "rotation";
		public static const TRANSLATION:String = "translation";
		public static const SCALE:String = "scale";
		public static const GLOBAL_TRANSLATION:String = "global translation";
		
		public static function isInvalidMode(mode:String):Boolean {
			return !(mode == ALL || mode == ROTATION || mode == TRANSLATION || mode == GLOBAL_TRANSLATION || mode == SCALE);
		}
		
	}

}