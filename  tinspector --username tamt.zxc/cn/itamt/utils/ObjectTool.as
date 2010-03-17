package cn.itamt.utils {
	import flash.net.ObjectEncoding;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;	

	/**
	 * @author tamt
	 */
	public class ObjectTool {
		public static function copyObject(object : *) : * {
			var bytes : ByteArray = new ByteArray();
			bytes.objectEncoding = ObjectEncoding.AMF0;
			var objBytes : ByteArray = new ByteArray();
			objBytes.objectEncoding = ObjectEncoding.AMF0;
			objBytes.writeObject(object);
			var fullyQualifiedName : String = getQualifiedClassName(object);
			var clazz:Class = getDefinitionByName(fullyQualifiedName) as Class;
			registerClassAlias(fullyQualifiedName, clazz);
			bytes.writeByte(0x10); // 0x10 is AMF0 for "typed object (class instance)"

			bytes.writeUTF(fullyQualifiedName);
			bytes.writeBytes(objBytes, 1);
			bytes.position = 0;
			var result : * = bytes.readObject();
			return result; 
		}
	}
}
