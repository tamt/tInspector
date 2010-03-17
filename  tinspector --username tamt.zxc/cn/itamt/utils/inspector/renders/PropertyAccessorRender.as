package cn.itamt.utils.inspector.renders {
	import cn.itamt.utils.inspector.events.PropertyEvent;
	import cn.itamt.utils.inspector.ui.InspectorTextField;
	import cn.itamt.utils.inspector.ui.InspectorViewFavoriteButton;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;	

	/**
	 * 属性列表中的单元行渲染类.
	 * @author itamt@qq.com
	 */
	public class PropertyAccessorRender extends Sprite {
		private var name_tf : TextField;
		private var valueEditor : BasePropertyEditor;

		private var _width : Number;
		private var _height : Number;

		private var _target : *;
		private var _xml : XML;

		public function get xml() : XML {
			return _xml;
		}

		private var _favIconBtn : InspectorViewFavoriteButton;

		public function PropertyAccessorRender(w : Number = 200, h : Number = 20, isFavorite : Boolean = false) : void {
			this._width = w;
			this._height = h;
			
			//			this.mouseEnabled = false;

			name_tf = InspectorTextField.create('property name', 0xcccccc, 12, 0, 0, 'none', 'right');
			name_tf.height = _height - 2;
			name_tf.selectable = name_tf.mouseEnabled = name_tf.mouseWheelEnabled = false;
			addChild(name_tf);
			
			_favIconBtn = new InspectorViewFavoriteButton(!isFavorite);
			_favIconBtn.visible = false;
			_favIconBtn.y = 1;
			addChild(_favIconBtn);

			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			this._favIconBtn.addEventListener(MouseEvent.CLICK, onClickFavBtn);
		}

		/**
		 * 设置是否"收藏"
		 */
		public function setFavorite(bool : Boolean) : void {
			_favIconBtn.normalMode = !bool;
			
			drawBg();
		}

		private function onAdded(evt : Event) : void {
			this.relayout();
		}

		private function onRollOver(evt : MouseEvent) : void {
			this._favIconBtn.visible = true;
		}

		private function onRollOut(evt : MouseEvent) : void {
			this._favIconBtn.visible = false;
		}

		private function onClickFavBtn(evt : MouseEvent) : void {
			if(this._favIconBtn.normalMode) {
				dispatchEvent(new PropertyEvent(PropertyEvent.DEL_FAV, true, true));
			} else {
				dispatchEvent(new PropertyEvent(PropertyEvent.FAV, true, true));
			}
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
			this.graphics.beginFill(_favIconBtn.normalMode ? 0x282828 : /*0x512000*/ 0x282828);
			this.graphics.drawRoundRect(0, 0, name_tf.width + 16, _height, 5, 5);
			this.graphics.endFill();
		}

		/**
		 * <accessor name="graphics" access="readonly" type="flash.display::Graphics" declaredBy="flash.display::Shape" />
		 */
		public function setXML(target : *, accessorXML : XML) : void {
			_target = target;
			_xml = accessorXML;
			
			name_tf.text = accessorXML.@name;
			
			var type : String = accessorXML.@type;
			
			if(valueEditor == null) {
				this.valueEditor = this.createPropertyEditor(type);
				addChildAt(this.valueEditor, 0);
			}
			this.valueEditor.setXML(target, accessorXML);
			
			this.relayout();
		}

		public function update() : void {
			this.valueEditor.setXML(_target, _xml);
		}

		public function resize() : void {
		}

		/**
		 * 创建属性编辑器
		 */
		private function createPropertyEditor(type : String) : BasePropertyEditor {
			switch(type) {
				case 'String':
					return new StringPropertyEditor();
					break;
				case 'Number':
					return new NumberPropertyEditor();
					break;
				case 'int':
					return new NumberPropertyEditor();
					break;
				case 'uint':
					return new UnitPropertyEditor();
					break;
				case 'Boolean':
					return new BooleanPropertyEditor();
					break;
				default:
					return new PropertyEditor();
					break;
			}
		}
	}
}
