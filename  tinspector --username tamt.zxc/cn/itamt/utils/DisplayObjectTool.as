package cn.itamt.utils {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;	

	/**
	 * @author itamt@qq.com
	 */
	public class DisplayObjectTool {

		/**
		 * 返回显示列表中的某个显示对象在显示对象树当中的级别.
		 */
		public static function getDisplayObjectLevel(object : DisplayObject) : int {
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

		/**
		 * 移除显示容器底下, 所有所有的显示对象. 不仅仅是子级.
		 */
		public static function removeAllChildAndChild(container : DisplayObjectContainer) : void {
			while (container.numChildren) {
				if (container.getChildAt(0) is DisplayObjectContainer) {
					removeAllChildAndChild(container.getChildAt(0) as DisplayObjectContainer);
				}
				container.removeChildAt(0);
			}
		}

		/**
		 * 将显示对象置顶.
		 */
		public static function swapToTop(obj : DisplayObject) : void {
			if(obj.stage) {
				var fun : Function;
				obj.stage.invalidate();
				obj.stage.addEventListener(Event.RENDER, fun = function(evt : Event):void {
					if(obj && obj.stage && fun) {
						obj.stage.removeEventListener(Event.RENDER, fun);
						obj.parent.setChildIndex(obj, obj.parent.numChildren - 1);
					}
				});
			}
		}

		/**
		 * 返回某一个Container下的所有显示对象的个数(包括子/"孙"...显示对象).
		 */
		public static function getAllChildrenNum(container : DisplayObjectContainer) : uint {
			var num : uint = container.numChildren;
			for(var i : int = 0;i < container.numChildren; i++) {
				var child : DisplayObject = container.getChildAt(i);
				if(child is DisplayObjectContainer) {
					num += getAllChildrenNum(child as DisplayObjectContainer);
				}
			}
			return num;
		}

		/**
		 * 得到一个显示对象他的全局的旋转角度.
		 */
		public static function localRotationToGlobal(child : DisplayObject) : Number {
			var greed : Number = child.rotation;
			if(child.parent) {
				greed += localRotationToGlobal(child.parent);
			}
			return greed;
		}

		public static function global2LocalMath(child : DisplayObject, c : Number, mathFun : Function) : Number {
			var num : Number;
			num = c * mathFun.call(null, child.rotation * Math.PI / 180);
			if(child.parent)num *= global2LocalMath(child.parent, num, mathFun);
			return num;
		}
	}
}
