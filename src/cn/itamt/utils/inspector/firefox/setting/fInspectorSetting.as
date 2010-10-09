package cn.itamt.utils.inspector.firefox.setting {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.ui.InspectorStageReference;
	import cn.itamt.utils.inspector.ui.InspectorViewPanel;

	import flash.net.SharedObject;

	/**
	 * @author itamt[at]qq.com
	 */
	public class fInspectorSetting extends InspectorViewPanel {

		private var _so : SharedObject;

		public function fInspectorSetting(w : Number = 200, h : Number = 200, autoDisposeWhenRemove : Boolean = true, resizeable : Boolean = true, closeable : Boolean = true) {
			InspectorStageReference.referenceTo(this.stage);
			super(InspectorLanguageManager.getStr("Setting"), w, h, autoDisposeWhenRemove, resizeable, closeable);

		}

		public function init():void {
			_so = SharedObject.getLocal("FlashInspector");
		}
	}
}
