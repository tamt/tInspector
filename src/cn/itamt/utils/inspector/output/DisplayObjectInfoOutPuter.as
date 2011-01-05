package cn.itamt.utils.inspector.output {
	import cn.itamt.utils.ClassTool;

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
			if(source == null)
				return null;
			return '[' + ClassTool.getShortClassName(source) + ']' + '<font color="#990000">[x:' + source.x.toFixed(2) + ', y: ' + source.y.toFixed(2) + ']</font><font color="#0000FF">[w: ' + source.width.toFixed(2) + ', h: ' + source.height.toFixed(2) + ']</font><font color="#FF9900">[r: ' + int(source.rotation) + '°]</font>';
		}
	}
}
