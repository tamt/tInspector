package cn.itamt.utils.inspector.output {
	import cn.itamt.utils.DisplayObjectTool;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;	

	/**
	 * 输出一个显示对象的子对象数目信息.(目前被用在StructurePanel上).
	 * @author itamt@qq.com
	 */
	public class DisplayObjectChildrenInfoOutputer extends DisplayObjectInfoOutPuter {
		public function DisplayObjectChildrenInfoOutputer() : void {
		}

		override public function output(source : DisplayObject) : String {
			if(source is DisplayObjectContainer) {
				var tmp : DisplayObjectContainer = source as DisplayObjectContainer;
				return '[<font color="#99cc00">' + source.name + '</font>]childs:<font color="#000000">' + tmp.numChildren + '/' + DisplayObjectTool.getAllChildrenNum(tmp) + '</font>';
			} else {
				return '[' + source.name + ']';
			}
		}
	}
}
