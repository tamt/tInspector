package cn.itamt.utils.firefox.addon {
	import flash.system.Capabilities;

	import cn.itamt.utils.Debug;

	import flash.external.ExternalInterface;

	/**
	 * FlashPlayer运行环境
	 */
	public class FlashPlayerEnvironment {

		/**
		 * 是否允许全屏，通过判断在html的嵌入代码中allowfullscreen="true";
		 */
		public static function getAllowFullScreen() : Boolean {
			var allowFullScreen : Boolean;
			
			if(ExternalInterface.available) {
				var attr : Object = getSwfObjectAttributes();
				if(attr != null)allowFullScreen = (attr['allowfullscreen'] == 'true');
			} else {
				allowFullScreen = true;
			}
			
			return allowFullScreen;
		}

		public static function getSwfObjectAttributes() : Object {
			var tmpXML : XML = <xml><![CDATA[
			function(){
				var eles = document.embeds;
				var swf;
				if(eles.length == 1){
					swf = eles[0];
				}else{
					for(var i=0; i<eles.length; i++){
						if(eles[i].id == &SWFID& || eles[i].name==&SWFID&){
							swf = eles[i];
						}
					}
				}
				
				var attrs = {};
				var str = "";
				if(swf){
					for(var i=0; i<swf.attributes.length; i++){
						attrs[swf.attributes[i].name.toLowerCase()] = swf.attributes[i].value;
						str += swf.attributes[i].name.toLowerCase() + ":" + swf.attributes[i].value + '\n';
					}
				}
				
				return attrs;
			}
			]]></xml>;
			
			var js : String = tmpXML.toString().replace(/&SWFID&/g, '"' + ExternalInterface.objectID + '"');
			
			var attribute : Object;
			if(ExternalInterface.available) {
				try {
					attribute = ExternalInterface.call(js);
				}catch(e : Error) {
				}
			}
			return attribute;
		}

		public static function isInFirefox() : Boolean {
			var browser : String = "";
			
			if(ExternalInterface.available) {
				try {
					browser = ExternalInterface.call("function(){return navigator.userAgent.toLowerCase();}");
				}catch(e : Error) {
				}
			}
			
			return browser == null ? false : browser.indexOf("firefox") >= 0;
		}

		/**
		 * 是否Debug版本的Flash Player
		 */
		public static function isDebugVersion() : Boolean {
			return Capabilities.isDebugger;
		}
	}
}