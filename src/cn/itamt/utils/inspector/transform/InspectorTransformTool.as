package cn.itamt.utils.inspector.transform {
	import cn.itamt.utils.inspector.ui.InspectorStageReference;

	import com.senocular.display.TransformTool;

	import flash.events.Event;
	import flash.geom.Matrix;

	/**
	 * 扩展TransformTool, 修正TransformTool的一个小bug
	 * @author itamt[at]qq.com
	 */
	public class InspectorTransformTool extends TransformTool {
		public function InspectorTransformTool() {
			super();
		}

		/**
		 * Applies the current tool transformation to its target instance
		 */
		override public function apply() : void {
			if (target) {
				
				var applyMatrix : Matrix = toolMatrix.clone();
				applyMatrix.concat(transform.concatenatedMatrix);
				
				if (target.parent) {
					var invertMatrix : Matrix = target.parent.transform.concatenatedMatrix;
					if(target.parent == this.stage) {
						invertMatrix = InspectorStageReference.getConcatenatedMatrix();
					}
					invertMatrix.invert();
					applyMatrix.concat(invertMatrix);
				}
				
				target.transform.matrix = applyMatrix;
				
				dispatchEvent(new Event(TRANSFORM_TARGET));
			}
		}
	}
}
