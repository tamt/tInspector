//tamt 2009/11/24	ver 0.1	 导出所选元素的大小及位置属性.

//-------------界面文件的生成----------------------
var tmpXmlFile = fl.configURI + "/tmp.xml";
var xmlGui = buildXulGui();
FLfile.write(tmpXmlFile, xmlGui);
function buildXulGui()
{
	var t = fl.getDocumentDOM().pathURI;
	var folderPath = t.substr(0, t.lastIndexOf('/'));
  return '<dialog id="dialog" title="导出所选元素属性" buttons="accept, cancel"> \
      \
      <script> \
      function usePotIntMethod() \
      { \
		  fl.xmlui.setEnabled("posIntMethod", !fl.xmlui.getEnabled("posIntMethod")); \
		  if(fl.xmlui.getEnabled("posIntMethod")){ \
		  	fl.xmlui.set("posIntMethod", "setPos(%x%, %y%)"); \
		  }else{ \
		  	fl.xmlui.set("posIntMethod", "none"); \
		  } \
      } \
      function useSizeIntMethod() \
      { \
		  fl.xmlui.setEnabled("sizeIntMethod", !fl.xmlui.getEnabled("sizeIntMethod")); \
		  if(fl.xmlui.getEnabled("sizeIntMethod")){ \
		  	fl.xmlui.set("sizeIntMethod", "setSize(%w%, %h%)"); \
		  }else{ \
		  	fl.xmlui.set("sizeIntMethod", "none"); \
		  } \
      } \
      </script> \
      \
     <vbox> \
	 <hbox> \
      <checkbox width="80" label="位置取整" id="posInt"/> \
      <button label="√" value="no" width="20" id="usePosIntMethodBtn" oncommand="usePotIntMethod()"/> \
      <label width = "40" value="方法名"/> \
	  <textbox value="setPos(%x%, %y%)" id="posIntMethod" /> \
	 </hbox> \
      <separator/> \
	 <hbox> \
      <checkbox width="80" label="长宽取整" id="sizeInt"/> \
      <button label="√" value="no" width="20" id="useSizeIntMethodBtn" oncommand="useSizeIntMethod()"/> \
      <label width = "40" value="方法名"/> \
	  <textbox value="setSize(%w%, %h%)" id="sizeIntMethod" /> \
	 </hbox> \
      <separator/> \
      <checkbox label="只导出有命名的元素" id="hasInstanceNameOnly" checked="true"/> \
    </vbox> \
    \
  </dialog>';
}
//-------------------------------------------------
var setting = fl.getDocumentDOM().xmlPanel(tmpXmlFile);

fl.outputPanel.clear();

if(setting.dismiss == "accept"){
	var output = "";
	
	var doc = fl.getDocumentDOM();
	var selections = doc.selection;
	
	var props = [];
	for(var i=0; i<selections.length; i++){
		var ele = selections[i];
		if(ele.elementType == "instance" || ele.elementType == "text"){
			var prop = {name:"instance", x:0, y:0, width:0, height:0, class:"DisplayObject"};
			props.push(prop);
			
			prop.name = ele.name;
			prop.x = ele.x;
			prop.y = ele.y;
			prop.width = ele.width;
			prop.height = ele.height;
			
			if(ele.elementType == "text"){
				prop.class = "TextField";
			}else{
				if(ele.instanceType == "symbol"){
					var libItem = ele.libraryItem;
					if(libItem.linkageExportForAS){
						prop.class = libItem.linkageClassName;
						if(prop.class.lastIndexOf(".")>-1){
							prop.class = prop.class.substring(prop.class.lastIndexOf(".")+1);
						}
					}else{
						switch(ele.symbolType){
							case "button":
								prop.class = "SimpleButton";
								break;
							case "movie clip":
								prop.class = "Sprite";
								break;
							case "graphic":
								prop.class = "DisplayObject";
								break;
						}
					}
				}
			}
		}
	}
	
	//export to AS code;
	for(i=0; i<props.length; i++){		
		prop = props[i];
		if(setting.hasInstanceNameOnly == "true"){
			if(prop.name != "")output += outputPropVar(prop) + outputPropPos(prop) + outputPropSize(prop);
		}else{
			output += outputPropVar(prop) + outputPropPos(prop) + outputPropSize(prop);
		}
		output += "\n";
	}
	
	fl.trace(output);
}

function outputPropVar(prop){
	var str = "";
	var instanceName = (prop.name=="")?("instance"):(prop.name);
	str += "private var " + instanceName + ":" + prop.class + " = new " + prop.class + "();\n"; 
	return str;
}

function outputPropPos(prop){
	var str = "";
	var instanceName = (prop.name=="")?("instance"):(prop.name);
	var posX = (setting.posInt == "true")?String(Math.round(prop.x)):prop.x;
	var posY = (setting.posInt == "true")?String(Math.round(prop.y)):prop.y;
	if(setting.posIntMethod == "none"){
		str += instanceName + ".x" + " = " + posX + ";\n";
		str += instanceName + ".y" + " = " + posY + ";\n";
	}else{
		str += instanceName + "." + setting.posIntMethod + ";\n";
		str = str.replace("%x%", posX);
		str = str.replace("%y%", posY);
	}
	return str;
}

function outputPropSize(prop){
	var str = "";
	var instanceName = (prop.name=="")?("instance"):(prop.name);
	var sizeW = (setting.sizeInt == "true")?String(Math.round(prop.width)):prop.width;
	var sizeH = (setting.sizeInt == "true")?String(Math.round(prop.height)):prop.height;
	if(setting.sizeIntMethod == "none"){
		str += instanceName + ".width" + " = " + sizeW + ";\n";
		str += instanceName + ".height" + " = " + sizeH + ";\n";
	}else{
		str += instanceName + "." + setting.sizeIntMethod + ";\n";
		str = str.replace("%w%", sizeW);
		str = str.replace("%h%", sizeH);
	}
	return str;
}

//-----debug function------
function traceObj(obj){
	fl.trace("------------");
	for(var prop in obj){
		fl.trace(prop + ": " + obj[prop]);
	}
	fl.trace("------------");
}