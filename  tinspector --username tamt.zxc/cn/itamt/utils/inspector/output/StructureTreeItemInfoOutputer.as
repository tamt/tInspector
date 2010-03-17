package cn.itamt.utils.inspector.output {
	import cn.itamt.utils.ClassTool;
	import cn.itamt.utils.inspector.output.DisplayObjectInfoOutPuter;
	import cn.itamt.utils.inspector.ui.InspectorColorStyle;

	import flash.display.DisplayObject;	

	/**
	 * 显示树面板中节点项的信息输出类
	 * @author itamt@qq.com
	 */
	public class StructureTreeItemInfoOutputer extends DisplayObjectInfoOutPuter {
		public function StructureTreeItemInfoOutputer() {
			super();
		}

		override public function output(source : DisplayObject) : String {
			var c : uint = InspectorColorStyle.getObjectColor(source);
			//			_tf.textColor = InspectorColorStyle.getObjectColor(this._data.displayObject);
			//			
			var className : String = ClassTool.getShortClassName(source);
			return '<font color="#' + c.toString(16) + '">' + className + '</font>(' + source.name + ')';
		}
	}
}
