package ominds{

	import cn.itamt.utils.Debug;
	import cn.itamt.utils.Inspector;
	import cn.itamt.utils.inspector.firefox.firebug.FlashFirebug;
	import cn.itamt.utils.inspector.plugins.InspectorPluginId;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	import flash.net.*;
	import flash.xml.XMLNode;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import com.adobe.serialization.json.*;
	import flash.filters.GlowFilter;
	import utility.CharacterEntity;
	
	public class Firebug extends MovieClip {

		private static  var root:*;
		public static  var id:String;
		private static  var name:String = "";
		private static  var url:String = "";
		private static  var swfVersion:String = "";
		public static  var overlay:MovieClip;
		private static  var overlayBitmap:Bitmap;
		private static  var selectedObject;		
		private static  var isReady;		
		private static  var currentVersion:String = "1.5.0";
		
		private static var _tryConnectTimes:int;
		
		public function Firebug():void {
			super();
			trace("flash for firebug is a static class and should not be instantiated.");
			return;
		}

		//------------------------------------------------ inspect functions

		public static function startInspect(mainObject:Object):void{// activate auto inspect 
			mainObject.addEventListener(MouseEvent.MOUSE_OVER,inspect_selected);
			return;
		}
		public static function stopInspect(mainObject):void{// de-activate auto inspect 
			mainObject.removeEventListener(MouseEvent.MOUSE_OVER,inspect_selected);
			return;			
		}
		private static function inspect_selected(evt:MouseEvent):void{
			if (evt.target!=evt.currentTarget) {
				inspect(evt.target);
			}
			return;			
		}
		public static function inspect(obj:Object):void {
			//***************************** Object inspect functions
			trace("name: "+obj.name);
			//************************ class
			inspect_class(obj);
			inspect_inherit(obj);
			//************************ properties
			inspect_properties(obj);
			//************************ methods
			inspect_methods(obj);
			return;
		}

		public static function inspect_properties(_obj:*):Array{
			var _description:XML = describeType(_obj);
			var _properties:Array = new Array();
			for each (var prop:XML in _description.accessor) {
				var _property:Object = new Object();
				_property.name 		 = String(prop.@name);
				_property.type 		 = String(simple_type(prop.@type));
				_property.access 	 = String(prop.@access);
				_property.declaredBy = String(prop.@declaredBy);
				_property.allowed 	 = inspect_constantValues(_property.declaredBy,_property.name,_property.type);
				try {
					if (_property.type == "ByteArray"){
						_property.value = "ByteArray";
					}else{
						_property.value = CharacterEntity.encode(String(_obj[_property.name]));
					}
				} catch (e) {
					_property.value = "" ;
				}
				_properties.push(_property)
			}
			_properties.sortOn("name");
			return _properties;
		}

		public static function inspect_methods(_obj:*){
			var _description:XML=describeType(_obj);
			for each (var _method:XML in _description.method) {
				var _method_name:String=_method.@name;
				var _method_type:String=_method.@returnType;
				var _method_parm:String="";

				var _method_parms:Array=new Array;
				for each (var param:XML in _method.parameter) {
					_method_parms.push(param.@optional=="false"?simple_type(param.@type):"["+simple_type(param.@type)+"]");
				}
				_method_parm=_method_parms.join(",");
				trace(_method_name+"("+_method_parm+"):"+simple_type(_method_type));
			}
		}

		public static function inspect_inherit(_obj:*):String{
			var _description:XML=describeType(_obj);
			var inheritance:String="";
			var inheritances:Array=new Array;
			for each (var exclass:XML in _description.extendsClass) {
				inheritances.push(simple_type(exclass.@type));
			}
			inheritance = inheritances.join(" ► ");
			return inheritance;
		}

		public static function inspect_class(_obj:*):Object{
			var _description:XML    = describeType(_obj);
			var _classInfo:Object   = new Object();
			_classInfo.packageName  = String(_description.@name).split("::")[0];
			_classInfo.className    = String(_description.@name).split("::")[1];
			_classInfo.isDynamic    = Boolean(_description.@isDynamic);
			_classInfo.isStatic     = Boolean(_description.@isStatic);
			_classInfo.isFinal      = Boolean(_description.@isFinal);

			return _classInfo;
		}
		public static function inspect_constantValues(declaredBy:String,className:String,classType:String):Array{
			className  = (className.substr(0,1)).toUpperCase() + className.substr(1); // fix flash local upercase bug 
			declaredBy = declaredBy.split("::")[0];
			
			var _constants:Array = new Array();
			try{
				if (classType == "Boolean"){
					var _constant_true:Object = new Object();
					var _constant_false:Object = new Object();					
					_constant_true.name  = "True";
					_constant_false.name  = "False";					
					_constant_true.value = "true";
					_constant_false.value = "false";					
					_constants.push(_constant_true,_constant_false);
				}else{
					var _validValues:Class = getDefinitionByName(declaredBy + "." + className) as Class;
					var _description:XMLList = describeType(_validValues).constant;
					for each (var _cons in _description) {
						var _constant:Object = new Object();
						_constant.name = className+"."+String(_cons.@name);
						_constant.value = String(_validValues[_cons.@name]);
						_constants.push(_constant);
					}
				}
			}catch(e){}
			return _constants;
		}		
		public static function traceOut(... arguments):void{
			for (var i:uint = 0; i < arguments.length; i++) {
        		arguments[i] = CharacterEntity.encode(arguments[i]);
    		}
			sendToFlashFirebug({command:"traceOut",args:arguments});
			return;
		}
		public static function clearOut():void {
			sendToFlashFirebug({"command":"clearOut"});
			return;
		}		
		//---------------------------------------------- children tree and target object 

		public static function getDisplayTree(dispObj:*):Array{
			var treeObj:Array = new Array();
			if (dispObj.numChildren) {
				for (var i:int=0; i < dispObj.numChildren; i++) {
					var obj:* = dispObj.getChildAt(i);
					var object:Object = new Object();
					if (obj is DisplayObjectContainer) {
						object.isContainer = true;
						object.hasChildren = (obj.numChildren > 0);
					}
					object.name = obj.name;
					object.index = i;
					object.className = inspect_class(obj).className;
					object.packageName = inspect_class(obj).packageName;
					treeObj[i]  = object;
				}
			}
			return treeObj;
		}

		private static function getDisplayObject(absName:String):*{
			if (absName=="root") {
				return root;
			}
			var absNameArray:Array = absName.split(".");
			var myObject:* = root;
			for (var i = 0; i < absNameArray.length; i++) {
				if(myObject is DisplayObjectContainer){
					myObject = myObject.getChildAt(absNameArray[i]);
				}else {
					break;
				}
			}
			return myObject;
		}
		public static function displayObjectPath(avDisplayObject : DisplayObject):String{
			var lvPath:String = "";
			do{
				if( avDisplayObject.name ) lvPath = avDisplayObject.name + ( lvPath == "" ? "" : "." + lvPath );
			} while( avDisplayObject = avDisplayObject.parent );
			return lvPath;
		}		
		//---------------------------------------------- private functions

		private static function simple_type(_type:String):String{
			var lastIndex=_type.lastIndexOf("::");
			_type=lastIndex>0?_type.substr(lastIndex+2):_type;
			return _type;
		}
		//---------------------------------------------- start connection
		public static function connect(scope:*):void{ 
			if(!root){ // if root then it's already connected
				// remove domain security
				Security.allowInsecureDomain("*");
				Security.allowDomain("*");

				// adding the interface 
				if (ExternalInterface.available) {
					ExternalInterface.addCallback('fromFlashFirebug',getFromFlashFirebug);
				}
				// set the scope root
				root = scope;
	
				// inite inspector overlay
				overlay = new MovieClip();
				overlay.filters = [new GlowFilter()];
				overlayBitmap = new Bitmap(new BitmapData(root.stage.stageWidth,root.stage.stageHeight,true,0x000000),'auto',true);
				overlay.addChild(overlayBitmap);
				overlay.alpha = 0.5;
				overlay.mouseEnabled = false;
				overlay.target = null;
				root.parent.addChild(overlay);
				
				// add the eventlisteners 
				if (root.loaderInfo.bytesTotal && root.loaderInfo.bytesTotal == root.loaderInfo.bytesLoaded) {
					onLoaded();
				}else {
					root.loaderInfo.addEventListener(Event.COMPLETE, onLoaded);
				}
			}else {
				if (_tryConnectTimes) {
					_tryConnectTimes = 0;
				}else {
					if (root.loaderInfo.bytesTotal && root.loaderInfo.bytesTotal == root.loaderInfo.bytesLoaded) {
						onLoaded();
					}else {
						root.loaderInfo.addEventListener(Event.COMPLETE, onLoaded);
					}
				}
			}
			return;
		}
		
		private static function onLoaded(evt:Event = null):void{
			root.addEventListener(Event.ENTER_FRAME,update);
			return;
		}
		
		private static function ifReady():void {
			if (id) {
				Debug.trace("Ready");
				isReady = true;
				name = (root.loaderInfo.url).split("/").pop();
				url = root.loaderInfo.url;
				swfVersion = root.loaderInfo.swfVersion;
				sendToFlashFirebug({"command":"ready","name":name,"url":url,"current":getCurrentVersion()});
				getTree( { "target":"root" } );
				
				if (_toInspect) {
					openTree(_toInspect);
					_toInspect = null;
				}
				
				root.removeEventListener(Event.ENTER_FRAME, update);
				Debug.trace("connect success after " + _tryConnectTimes + " times");
				(Inspector.getInstance().pluginManager.getPluginById(InspectorPluginId.FLASH_FIREBUG) as FlashFirebug).onConnectSuccess(_tryConnectTimes);
				_tryConnectTimes = 0;
			}else {
				_tryConnectTimes++;
				sendToFlashFirebug( { "command":"refreshIds" } );
				if (_tryConnectTimes >= 10) {
					root.removeEventListener(Event.ENTER_FRAME, update);
					(Inspector.getInstance().pluginManager.getPluginById(InspectorPluginId.FLASH_FIREBUG) as FlashFirebug).onConnectFail(_tryConnectTimes);
					Debug.trace("GiveUp connect FlashFirebug after " + _tryConnectTimes + " times try");
					_tryConnectTimes = 0;
				}
			}
			return;
		}
		
		private static function update(evt:Event):void {
			//root.removeEventListener(Event.ENTER_FRAME,update);
			// ------------------------------- update get Ready
			if (!isReady) {
				ifReady();
			}
			
			// ------------------------------- update Overlay
			cleanOverlay();
			if (overlay.target != null ){
				var overlayColorTransform:ColorTransform = overlay.target.transform.colorTransform;				
				overlayColorTransform.color = 0x9FD8EF;
				overlayBitmap.bitmapData.draw(overlay.target,overlay.target.transform.concatenatedMatrix,overlayColorTransform ,null,null,true);
			}
			return;
		}
		
		//---------------------------------------------- externalInterface
		private static function sendToFlashFirebug(data:*):void{
			data.id = id;
			data = JSON.encode(data);
			if (ExternalInterface.available) {
				ExternalInterface.call('toFlashFirebug',data);
			}else {
				Debug.trace("can't sendToFlashFirebug because ExternalInterface is unavailable.");
			}
			return;
		}
		private static function getFromFlashFirebug(data:*):void {
			data = JSON.decode(data);
			var command = data.command;
			var listenerId = data.id;
			if (Firebug[command] && ( id == listenerId || listenerId == null || command=="setId") ) {
				Firebug[command](data);// dynamic functions ;)
			}
			return;
		}
		// --------------------------------------------- dynamic connector functions
		private static function setId(data):void{
			id = data.id;
			return;
		}
		
		private static var _toInspect;
		public static function openTree(data):void {
			try {
				if(isReady){
					Debug.trace("[Firebug.openTree]" + data.target);
					sendToFlashFirebug( { command:"openTree", target:data.target } );
				}else {
					_toInspect = data;
				}
			}catch (e) { }
		}
		
		public static function getTree(data):void {
			Debug.trace("[Firebug.getTree]" + data.target);
			try{
				var displayObject = getDisplayObject(data.target);
				var displayTree = getDisplayTree(displayObject);
				var target_path = data.target;
				sendToFlashFirebug( { command:"setTree", "tree":displayTree, "target":target_path } );
				
				////////[tamt] FlashInspector extend ///////////
				//if (!data.callFromFI) {
					
				//}
			}catch(e){}
			return;
		}
		public static function selectObject(data):void {
			Debug.trace("[Firebug.selectObject]" + data.target);
			selectedObject = getDisplayObject(data.target);
			var inherit_info = inspect_inherit(selectedObject);  
			var class_info = inspect_class(selectedObject);
			var target_path = displayObjectPath(selectedObject);
			var	target_name = selectedObject.name;
			var target_properties:Array = inspect_properties(selectedObject);
			sendToFlashFirebug({command:"displayGeneralInfo",inheritInfo:inherit_info,classInfo:class_info,targetName:target_name,targetPath:target_path});
			sendToFlashFirebug( { command:"displayProperties", targetProperties:target_properties, target:(data.target) } );			

			////////[tamt] FlashInspector extend ///////////
			if (!data.callFromFI) {
				(Inspector.getInstance().pluginManager.getPluginById(InspectorPluginId.FLASH_FIREBUG) as FlashFirebug).keepStatic = true;
				Inspector.getInstance().inspect(selectedObject);
				(Inspector.getInstance().pluginManager.getPluginById(InspectorPluginId.FLASH_FIREBUG) as FlashFirebug).keepStatic = false;
			}
			return;
		}
		private static function selectSwf(data):void {
			var target_properties:Array = inspect_properties(root.loaderInfo);
			sendToFlashFirebug({"command":"displaySwfGeneralInfo","swfName":name,"swfUrl":url,"swfVersion":swfVersion,"currentVersion":getCurrentVersion()});
			sendToFlashFirebug({command:"displayProperties",targetProperties:target_properties});
			return;
		}
        private static function restartConnection(data):void{
            id = null;
            isReady = false;
            return;
        }		
		// ------------------------------------------------------------ versions functions  
		public static function getCurrentVersion():String {
			return currentVersion;
		}
		// ------------------------------------------------------- overlay functions
		private static function overlayObject(data):void{
			var displayObject = getDisplayObject(data.target);			
			// add the overlay
			overlay.target = displayObject;
			
			////////[tamt] FlashInspector extend ///////////
			Inspector.getInstance().liveInspect(displayObject);
			return;
		}
		private static function removeOverlay(data):void{
			overlay.target = null;
			
			////////[tamt] FlashInspector extend ///////////
			Inspector.getInstance().stopLiveInspect();
			//if(Inspector.getInstance().getCurInspectTarget())Inspector.getInstance().inspect(Inspector.getInstance().getCurInspectTarget().displayObject);
			return;
	    }
		private static function cleanOverlay():void{
			overlayBitmap.bitmapData.fillRect(overlayBitmap.bitmapData.rect, 0);
			return;
	    }
		// ----------------------------------------------------		
		private static function setPropertyValue(data):void{
			try{
				if(selectedObject){
					switch (data.propType){
						case "Boolean":
						selectedObject[data.propName] = (data.propValue == "true")? true : false;  
						break;
						case "String":
						selectedObject[data.propName] = CharacterEntity.decode(data.propValue);
						break;
						default:
						selectedObject[data.propName] = data.propValue;  
					}
			
					////////[tamt] FlashInspector extend ///////////
					if (Inspector.getInstance().getCurInspectTarget().displayObject == selectedObject) {
						(Inspector.getInstance().pluginManager.getPluginById(InspectorPluginId.FLASH_FIREBUG) as FlashFirebug).keepStatic = true;
						Inspector.getInstance().updateInsectorView();
						(Inspector.getInstance().pluginManager.getPluginById(InspectorPluginId.FLASH_FIREBUG) as FlashFirebug).keepStatic = false;
					}
				}
			}catch(e){}
			return;
		}
		private static function getPropertyValue(data):void{ 
			return;
		}		
	}
}