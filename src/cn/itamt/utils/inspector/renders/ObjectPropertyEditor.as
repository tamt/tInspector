package cn.itamt.utils.inspector.renders {
	import cn.itamt.utils.inspector.consts.InspectorSymbolIcon;
	import cn.itamt.utils.inspector.events.PropertyEvent;
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.ui.InspectorButton;

	import flash.display.Bitmap;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;

	/**
	 * @author itamt[at]qq.com
	 */
	public class ObjectPropertyEditor extends PropertyEditor {
		protected var inspectBtn : InspectorButton;

		public function ObjectPropertyEditor() {
			super();
			
			inspectBtn = new InspectorButton();
			inspectBtn.upState = inspectBtn.overState = inspectBtn.downState = inspectBtn.hitTestState = new Bitmap(InspectorSymbolIcon.getIcon(InspectorSymbolIcon.INSPECT));
			inspectBtn.tip = InspectorLanguageManager.getStr("InspectInfo");
			inspectBtn.visible = false;
			inspectBtn.addEventListener(MouseEvent.CLICK, onClickInspect);
			addChild(inspectBtn);
			
			this.addEventListener(MouseEvent.ROLL_OVER, onMouseRoll);			this.addEventListener(MouseEvent.ROLL_OUT, onMouseRoll);
		}

		private function onMouseRoll(evt : MouseEvent) : void {
			if(evt.type == MouseEvent.ROLL_OUT) {
				inspectBtn.visible = false;
			}else if(evt.type == MouseEvent.ROLL_OVER) {
				inspectBtn.visible = true;
			}
		}

		private function onClickInspect(evt : MouseEvent) : void {
			this.dispatchEvent(new PropertyEvent(PropertyEvent.INSPECT, true, true));
		}

		override public function relayOut() : void {
			this.graphics.clear();
			this.graphics.lineStyle(2, 0x333333);
			this.graphics.drawRoundRect(0, 0, _width/* - inspectBtn.width*/, _height, 5, 5);
			
			value_tf.x = 2;
			value_tf.width = _width - 4/* - inspectBtn.width*/;
			value_tf.height = _height - 2;
			
			inspectBtn.x = -10/*- inspectBtn.width*/;
			inspectBtn.y = _height / 2 - inspectBtn.height / 2;
			
			if(autoSize) {
				if(value_tf.textWidth + 4 > value_tf.width) {
					//					value_tf.width = value_tf.textWidth;
					_width = value_tf.textWidth + 10/* + inspectBtn.width*/;
					relayOut();
				}
			}
		}

		override protected function onFocusIn(evt : FocusEvent) : void {
			this.value_tf.textColor = 0xffffff;
			this.graphics.clear();
			this.graphics.lineStyle(4, 0x222222);
			this.graphics.beginFill(0x667E01);
			this.graphics.drawRoundRect(0, 0, _width/* - inspectBtn.width*/, _height, 5, 5);
			this.graphics.endFill();
		}

		override protected function onFocusOut(evt : FocusEvent) : void {
			this.value_tf.textColor = 0xffffff;
			this.graphics.clear();
			this.graphics.lineStyle(2, 0x333333);
			this.graphics.drawRoundRect(0, 0, _width/* - inspectBtn.width*/, _height, 5, 5);
		}
	}
}
