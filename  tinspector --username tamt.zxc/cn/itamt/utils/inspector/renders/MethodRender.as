package cn.itamt.utils.inspector.renders {
	import cn.itamt.utils.inspector.ui.InspectorTextField;	

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;	

	/** 方法列表中的单元行渲染类.
	 * @author pethan
	 */
	public class MethodRender extends Sprite {
		private var name_tf : TextField;
		private var valueEditor : BasePropertyEditor;

		private var _width : Number;
		private var _height : Number;

		private var _target : *;
		private var _xml : XML;

		public function get xml() : XML {
			return _xml;
		}

		
		public function MethodRender(w : Number = 200, h : Number = 20) : void {
			this._width = w;
			this._height = h;
			
			//			this.mouseEnabled = false;

			name_tf = InspectorTextField.create('', 0xcccccc, 12);
			name_tf.height = _height - 2;
			name_tf.selectable = name_tf.mouseEnabled = name_tf.mouseWheelEnabled = false;
			addChild(name_tf);

			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		
		private function onAdded(evt : Event) : void {
			this.relayout();
		}

		/**
		 * 重新布局
		 */
		public function relayout() : void {
			name_tf.width = name_tf.textWidth + 4;
			if(name_tf.width < 48)name_tf.width = 48;
			name_tf.x = 12;
			
			if(valueEditor) {
				valueEditor.setSize(_width - name_tf.width - 15, this._height);
				valueEditor.x = name_tf.x + name_tf.width + 8;
			}
			
			drawBg();
		}

		private function drawBg() : void {			
			this.graphics.clear();
			this.graphics.beginFill(0x282828);
			this.graphics.drawRoundRect(0, 0, name_tf.width + 16, _height, 5, 5);
			this.graphics.endFill();
		}

		/**
		 *<method name="attachNetStream" declaredBy="flash.media::Video" returnType="void">
		<parameter index="1" type="flash.net::NetStream" optional="false"/>
		</method>
		 * TODO:目前只显示方法名称和类型而已（因为不知道方法的参数名称，不好让用户知道，等以后有办法知道在做)
		 */
		public function setXML(target : *, methodXML : XML) : void {
			_target = target;
			_xml = methodXML;
			
			name_tf.text = methodXML.@name;
			if(valueEditor == null) {
				this.valueEditor = new MethodEditor();
				addChildAt(this.valueEditor, 0);
			}
			this.valueEditor.setXML(target, methodXML);
			
			this.relayout();
		}

		public function update() : void {
			this.valueEditor.setXML(_target, _xml);
		}

		public function resize() : void {
		}
	}
}
