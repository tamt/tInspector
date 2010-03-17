package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;	
	import cn.itamt.utils.inspector.ui.LiveTransformPointBtn;	

	/**
	 * 拖动缩放变形的按钮
	 * @author itamt@qq.com
	 */
	public class LiveScalePointBtn extends LiveTransformPointBtn {
		public function LiveScalePointBtn(onMouseDown : Function = null, onMouseUp : Function = null, onDrag : Function = null) {
			super(onMouseDown, onMouseUp, onDrag);
			
			_tip = InspectorLanguageManager.getStr('LiveScale');
		}
	}
}
