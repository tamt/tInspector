package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.consts.InspectorSymbolIcon;
	import cn.itamt.utils.inspector.ui.InspectorViewOperationButton;

	import flash.display.Bitmap;
	import flash.events.MouseEvent;	

	/**
	 * @author itamt@qq.com
	 */
	public class InspectorViewFavoriteButton extends InspectorViewOperationButton {
		public function InspectorViewFavoriteButton(normal : Boolean = true) {
			super();
			
			_normalMode = normal;
			_tip = InspectorLanguageManager.getStr('MarkProperty');
			
			this.addEventListener(MouseEvent.CLICK, onToggleMode, false, 0, true);
			this.update();
		}

		//-----------------------------
		//-----------------------------
		private var _normalMode : Boolean = true;

		public function get normalMode() : Boolean {
			return _normalMode;
		}

		public function set normalMode(val : Boolean) : void {
			_normalMode = val;
			this.update();
		}

		//切换按钮状态
		private function onToggleMode(evt : MouseEvent) : void {
			_normalMode = !_normalMode;
			
			update();
		}

		private function update() : void {
			var bmp : Bitmap;
			if(_normalMode) {
				bmp = new Bitmap(InspectorSymbolIcon.getIcon(InspectorSymbolIcon.FAVORITE));
					
				_tip = InspectorLanguageManager.getStr('MarkProperty');
			} else {
				bmp = new Bitmap(InspectorSymbolIcon.getIcon(InspectorSymbolIcon.DELETE));
				
				_tip = InspectorLanguageManager.getStr('DelMark');
			}
			
			this.upState = this.downState = this.overState = this.hitTestState = bmp;
		}
	}
}
