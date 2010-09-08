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
		protected var name_tf : TextField;
		protected var valueEditor : BasePropertyEditor;

		public function get editor() : BasePropertyEditor {
			return valueEditor;
		}

		protected var _width : Number;
		protected var _height : Number;

		protected var _owner : PropertyAccessorRender;

		public function get owner() : PropertyAccessorRender {
			return _owner;
		}

		public function get target() : * {
			return _target;
		}

		protected var _target : *;
		protected var _xml : XML;

		public function get xml() : XML {
			return _xml;
		}

		public function get propName() : String {
			return name_tf.text;
		}

		protected var _favIconBtn : InspectorViewFavoriteButton;

		public function PropertyAccessorRender(w : Number = 100, h : Number = 20, isFavorite : Boolean = false, owner : PropertyAccessorRender = null, favoritable : Boolean = true) : void {
			this._width = w;
			this._height = h;
			
			_owner = owner;
			//			this.mouseEnabled = false;

			name_tf = InspectorTextField.create('property name', 0xcccccc, 12, 0, 0, 'none', 'right');
			name_tf.height = _height - 2;
			/*name_tf.selectable = name_tf.mouseEnabled = */
			name_tf.mouseWheelEnabled = false;
			addChild(name_tf);
			
			_favIconBtn = new InspectorViewFavoriteButton(!isFavorite);
			_favIconBtn.visible = false;
			_favIconBtn.y = 1;
			if(favoritable)addChild(_favIconBtn);

			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			if(favoritable)this._favIconBtn.addEventListener(MouseEvent.CLICK, onClickFavBtn);
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
				if(valueEditor.height > this._height)this._height = valueEditor.height;
				valueEditor.setSize(_width - name_tf.width - 15, this._height);
				valueEditor.x = name_tf.x + name_tf.width + 8;
			}
			
			drawBg();
		}

		protected function drawBg() : void {			
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
			
			var enums : Array;
			//标示了枚举元数据, 目前只支持基本数据类型:Number, String, uint, int, Boolean. 因为太复杂了就无法用String转化了.
			if(accessorXML.metadata.(@name == "tinspector_enum").length()) {
				for each(var xml:XML in accessorXML.metadata.(@name == "tinspector_enum")) {
					var t : String = xml.arg.(@key == "type").@value;
					var v : String = xml.arg.(@key == "value").@value;
					var vs : Array = v.split(",");
					if(enums == null)enums = [];
					for(var i : int = 0;i < vs.length;i++) {
						enums.push({type:t, value:vs[i]});
					}
				}
			}
			
			if(valueEditor == null) {
				if(enums == null) {
					var tname : String = String(accessorXML.@name).toLowerCase();
					if(type == "uint" && tname.indexOf("color") >= 0 ) {
						if(tname.indexOf("color") == tname.length - 5) {
							this.valueEditor = this.createPropertyEditor("Color");
						}
					} else {
						this.valueEditor = this.createPropertyEditor(type);
					}
				} else {
					var list : EnumValueListEditor = new EnumValueListEditor();
					for each(var enum:Object in enums) {
						var editor : BasePropertyEditor = this.createPropertyEditor(enum.type);
						editor.setValue(enum.value);
						list.addEnumValueEditor(editor);
					}
					this.valueEditor = list;
				}
				addChildAt(this.valueEditor, 0);
			}
			this.valueEditor.setAccessType(_xml.@access, _xml.@exclude == "true");
			if(this.valueEditor.readable)this.valueEditor.setValue(_target[_xml.@name]);
			
			this.relayout();
		}

		public function update() : void {
			if(this.valueEditor.readable)this.valueEditor.setValue(_target[_xml.@name]);
		}

		public function resize() : void {
		}

		/**
		 * 创建属性编辑器
		 */
		protected function createPropertyEditor(type : String) : BasePropertyEditor {
			switch(type) {
				case 'Boolean':
					return new BooleanPropertyEditor();
					break;
				case 'Function':
					return new FunctionPropertyEditor();
					break;
				case 'int':
					return new NumberPropertyEditor();
					break;
				case 'Number':
					return new NumberPropertyEditor();
					break;
				case 'object':
					return new ObjectPropertyEditor();
					break;
				case 'String':
					return new StringPropertyEditor();
					break;
				case 'uint':
					return new UintPropertyEditor();
					break;
				case 'XML':
					return new XMLPropertyEditor();
					break;
				case 'XMLList':
					return new XMLPropertyEditor();
					break;
				case 'Color':
					return new ColorPropertyEditor();
					break;
				default:
					return new ObjectPropertyEditor();
					break;
			}
		}
	}
}
