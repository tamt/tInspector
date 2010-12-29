var doc = fl.getDocumentDOM();
var selections = doc.selection;
var output = "";
var ip = "";
for(var i=0; i<selections.length; i++){
	var ele = selections[i];
	if(ele.elementType == "instance"){
		if(ele.name){
			var className;
			var importName;
			if(ele.libraryItem.linkageClassName){
				importName = ele.libraryItem.linkageClassName;
				var e = ele.libraryItem.linkageClassName.lastIndexOf(".");
				className = (e>0)?(ele.libraryItem.linkageClassName.substring(e+1)):(ele.libraryItem.linkageClassName);
			}else{
				switch(ele.libraryItem.itemType){
					case "button":
						className = "SimpleButton";
						importName = "flash.display.SimpleButton"
						break;
					case "movie clip":
						className = "MovieClip";
						importName = "flash.display.MovieClip"
						break;
				}
			}
			
			if(ip.indexOf("import " + importName + ";")<0){
				ip += "import " + importName + ";\n"
			}
			output += "public var " + ele.name + ":" + className + ";\n";
		}
	}
}

fl.outputPanel.clear();
output = ip + "\n\n\n" + output;
fl.trace(output);