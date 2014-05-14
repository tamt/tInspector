package transform3d.consts
{
	/**
	 * transorm mode.
	 * @author tamt
	 */
	public class Transform3DMode
	{
		//Internal transform mode 
		public static const INTERNAL:uint = 1;
		//Global transform mode means that the 3D transformations move in relationship to the Transform3DTool’s coordinates
		public static const GLOBAL:uint = 2;
		
		public static function toString(mode:uint):String {
			switch(mode) {
				case 1:
					return "internal";
					break;
				case 2:
					return "global";
					break;
			}
			
			return "internal";
		}
		
		public static function isInvalidMode(mode:uint):Boolean {
			return mode != INTERNAL && mode != GLOBAL;
		}
	}

}