package cn.itamt.utils {

	public final class ResizeStyle { 
		/** 
		 * Makes the entire image visible at the specified width and height 
		 * without distortion while maintaining the original aspect ratio. 
		 */ 
		public static const CONSTRAIN_PROPORTIONS : String = "constrainProportions"; 

		/** 
		 * Scales the image to fill the specified width and height, without 
		 * distortion but centers it and fills any empty space with transparent 
		 * pixels, while maintaining the original aspect ratio. 
		 */ 
		public static const CENTER : String = "center"; 

		/** 
		 * Scales the image to fill the specified width and height, without 
		 * distortion but possibly with some cropping, while maintaining the 
		 * original aspect ratio. 
		 */ 
		public static const CROP : String = "crop"; 

		/** 
		 * Makes the entire image visible in the specified width and height 
		 * without trying to preserve the original aspect ratio. Distortion can 
		 * occur. 
		 */ 
		public static const STRETCH : String = "stretch"; 
	} 
}
