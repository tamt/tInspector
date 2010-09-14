package cn.itamt.utils.firefox.addon {
	import cn.itamt.utils.Debug;

	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;

	/**
	 * FlashPlayer运行环境
	 */
	public class FlashPlayerEnvironment {

		private static var _swfId : String;

		public static function get swfId() : String {
			if(_swfId == null) {
				return ExternalInterface.objectID;
			} else {
				return _swfId;
			}
		}

		public static function set swfId(val : String) : void {
			_swfId = val;
		}

		
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
			Debug.trace('[FlashPlayerEnvironment][getSwfObjectAttributes]');
			var tmpXML : XML = <xml><![CDATA[
			function(){
				/**
				var eles = document.embeds.concat(document.getElementsByTagName("object"));
				var swf;
				if(eles.length == 1){
					swf = eles[0];
				}else{
					for(var i=0; i<eles.length; i++){
						if(eles[i].type == "application/x-shockwave-flash"){
							if(eles[i].id == &SWFID& || eles[i].name==&SWFID&){
								swf = eles[i];
							}
						}
					}
				}
				*/
				
				var swf = document.getElementById(&SWFID&);
				
				var attrs = {};
				var str = "";
				if(swf){
					for(var i=0; i<swf.attributes.length; i++){
						attrs[swf.attributes[i].name.toLowerCase()] = swf.attributes[i].value;
						str += swf.attributes[i].name.toLowerCase() + ":" + swf.attributes[i].value + '\n';
					}
				}
				alert(str);
				
				return attrs;
			}
			]]></xml>;
			
			var js : String = tmpXML.toString().replace(/&SWFID&/g, '"' + swfId + '"');
			
			var attribute : Object;
			if(ExternalInterface.available) {
				try {
					attribute = ExternalInterface.call(js);
				}catch(e : Error) {
				}
			}
			
			for(var prop:String in attribute) {
				Debug.trace('[FlashPlayerEnvironment][getAllowFullScreen]' + prop + ": " + attribute[prop]);
			}
			
			return attribute;
		}

		public static function getSwfSize() : Rectangle {
			var size : Rectangle;
			
			var tmpXML : XML = <xml><![CDATA[
				function(){				
					var swf = document.getElementById(&SWFID&);
					var rect = {x:swf.offsetLeft, y:swf.offsetTop, width:swf.offsetWidth, height:swf.offsetHeight};
					return rect;
				}
			]]></xml>;
			
			var js : String = tmpXML.toString().replace(/&SWFID&/g, '"' + (swfId) + '"');
			if(!ExternalInterface.available)return null;
			var rect : * = ExternalInterface.call(js);
			if(rect == null)return null;
			return size = new Rectangle(rect.x, rect.y, rect.width, rect.height);
		}

		public static function setSwfSize(width : Number, height : Number) : void {
			var tmpXML : XML = <xml><![CDATA[
			function(swfid, width, height){				
				var swf = document.getElementById(swfid);
				swf.setAttribute("width", width);				swf.setAttribute("height", height);
			}
			]]></xml>;
			
			//			var js : String = tmpXML.toString().replace(/&SWFID&/g, '"' + (swfId) + '"');			//			js = tmpXML.toString().replace(/&width&/g, width);			//			js = tmpXML.toString().replace(/&height&/g, height);
			var js : String = tmpXML.toString();
			
			if(ExternalInterface.available) {
				ExternalInterface.call(js, (swfId), width, height);
			}
		}

		public static function getSwfBgColor() : int {
			var color : int = -1;
			var tmpXML : XML = <xml><![CDATA[
			function(swfid){				
				var swf = document.getElementById(swfid);
				if(swf.tagName == "OBJECT"){
					for(var i=0; i<swf.children.length; i++){
						if(swf.children[i].name == "bgcolor"){
							return swf.children[i].value;
						}
					}
					return "null";
				}else if(swf.tagName == "EMBED"){
					if(swf.getAttribute("bgcolor")){
						return swf.getAttribute("bgcolor");
					}else{
						return "null";
					}
				}
			}
			]]></xml>;
			
			var js : String = tmpXML.toString();
			
			if(ExternalInterface.available) {
				var res : String = ExternalInterface.call(js, (swfId));
				if(res && res != "null") {
					// Works with or without the #
					if (res.indexOf("#") > -1) {
						res = res.replace(/^\s+|\s+$/g, "");
						res = res.replace(/#/g, "");
					}
					// Convert to a color.
					color = parseInt(res, 16);
				}
			}
			return color;
		}

		public static function setSwfBgColor(color : uint) : void {
			Debug.trace('[FlashPlayerEnvironment][setSwfBgColor]' + color);
			var tmpXML : XML = <xml><![CDATA[
			function(swfid, colorStr){
				var swf = document.getElementById(swfid);
				if(swf.tagName == "OBJECT"){
					for(var i=0; i<swf.children.length; i++){
						if(swf.children[i].name == "bgcolor"){
							swf.children[i].value = colorStr;
						}
					}
					if(i == swf.children.length){
						var param = document.createElement("param");
						param.name = "bgcolor";
						param.value = colorStr;
						swf.appendChild(param);
					}
				}else if(swf.tagName == "EMBED"){
					swf.setAttribute("bgcolor", colorStr);
				}
			}
			]]></xml>;
			
			var js : String = tmpXML.toString();
			
			if(ExternalInterface.available) {
				var colorStr : String = color.toString(16);
				while (colorStr.length < 6) {
					colorStr = "0" + colorStr;
				}
				ExternalInterface.call(js, (swfId), "#" + colorStr);
				//reload swf;
				ExternalInterface.call("fInspectorReloadSwf", FlashPlayerEnvironment.swfId);
			}
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