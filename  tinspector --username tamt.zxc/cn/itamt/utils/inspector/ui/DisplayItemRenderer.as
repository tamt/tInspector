package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.ClassTool;	
	import cn.itamt.utils.inspector.data.DisplayItemData;
	import cn.itamt.utils.inspector.events.DisplayItemEvent;
	import cn.itamt.utils.inspector.interfaces.IDisplayItemRenderer;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;		

	/**
	 * @author itamt@qq.com
	 */
	public class DisplayItemRenderer extends BaseDisplayItemView {
		public var name_tf : TextField;
		public var btn : MovieClip;

		public function DisplayItemRenderer() {
			name_tf.autoSize = 'left';
			
			btn.addEventListener(MouseEvent.CLICK, onClickExpand);
		}

		override public function setData(value : DisplayItemData) : void {
			if(_data != value) {
				if(_data) {
					_data.removeEventListener(DisplayItemEvent.CHANGE, onDataChange);
				}
				_data = value;
				_data.addEventListener(DisplayItemEvent.CHANGE, onDataChange, false, 0, true);
			}
			
			if(_data.hasChildren) {
				btn.visible = true;
				if(_data.isExpand) {
					this.btn.gotoAndStop(1);
				} else {
					this.btn.gotoAndStop(2);
				}
			} else {
				btn.visible = false;
			}
			
			name_tf.text = ClassTool.getShortClassName(_data.displayObject);
			
			var level : int = getDisplayObjectLevel(_data.displayObject);
			btn.x = level * 10;
			name_tf.x = btn.x + btn.width + 4;
		}

		/**
		 * 单击展开/折叠按钮
		 */
		private function onClickExpand(evt : MouseEvent) : void {
			_data.toggleExpand();
		}

		/**
		 * 数据发生改变时
		 */
		private function onDataChange(evt : DisplayItemEvent) : void {
			this.setData(_data);
		}

		/**
		 * 返回显示列表中的某个显示对象在显示对象树当中的级别.
		 */
		private function getDisplayObjectLevel(object : DisplayObject) : int {
			if(object is Stage)return 0;
			if(object.stage) {
				var i : int = 0;
				while(object.parent) {
					object = object.parent;
					i++;
				}
				return i;
			} else {
				return -1;
			}
		}
	}
}
