package cn.itamt.utils.inspector.renders {

	/** 方法的编辑，实际上是不能编辑，就显示出来而已
	 * @author pethan
	 */
	public class MethodEditor extends PropertyEditor {
		public function MethodEditor() {
			super();
		}
		
		override public function setXML(target : *, xml : XML) : void {
			_xml = xml;
			
			var type : String = _xml.@returnType;
			value_tf.text=type;
		}
	}
}
