package cn.itamt.utils.inspector.output {
	import cn.itamt.utils.ClassTool;
	import cn.itamt.utils.inspector.output.OutPuter;

	import flash.display.DisplayObject;	

	/**
	 * 显示对象信息输出类
	 * 用户自定自己的信息输出类时, 重载output方法和dispose即可.
	 * @author itamt@qq.com
	 */
	public class DisplayObjectInfoOutPuter extends OutPuter {

		public function DisplayObjectInfoOutPuter() {
			super();
		}

		public function output(source : DisplayObject) : String {
			return '[' + ClassTool.getShortClassName(source) + ']' + '<font color="#990000">[x:' + source.x + ', y: ' + source.y + ']</font><font color="#0000FF">[w: ' + int(source.width) + ', h: ' + int(source.height) + ']</font><font color="#FF9900">[r: ' + int(source.rotation) + '°]</font>';
		}
	}
}
