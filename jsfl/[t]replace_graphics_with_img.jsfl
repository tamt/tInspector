//export your selection as .png image, and replace your selection with the image.
//remind that the Dynamic TextField will be "nothing", because Flash couldn't grab the graphics of Dynamic TextField when export.
//
//@author www.itamt.org
//

//把舞台上选中的元素导出图片.
//tamt	2009.12.22	ver 0.1		注意动态文本无法导出图形.

var doc = fl.getDocumentDOM();

if(doc.selection.length == 0){
	alert('select something on the stage first.');
}else{
	doc.clipCopy();
	var tmpDoc = fl.createDocument();
	if(tmpDoc == undefined){
		alert('create temp document fail.');
	}else{
		tmpDoc.clipPaste(true);
		//------------------------------------------------------------------
		//TODO: 搜索所选元素中的动态文本, 把它设置成静态文本. 因为动态文本无法导出图形.
		//------------------------------------------------------------------
		tmpDoc.group();
		var ele = tmpDoc.selection[0];
		if(ele){
			tmpDoc.width = Math.ceil(ele.width);
			tmpDoc.height = Math.ceil(ele.height);
			ele.x = ele.width/2;
			ele.y = ele.height/2;
		}
		tmpDoc.unGroup();
		ele = tmpDoc.selection[0];
		var png = doc.pathURI+"."+getPngNameStr(ele);
		var exported = tmpDoc.exportPNG(png, true);
		tmpDoc.close(false);
		
		if(exported){
			if(confirm('replace selection with the exported png?')){
				var rect = doc.getSelectionRect();//{left:value1,top:value2,right:value3,bottom:value4}
				var oSelect = doc.selection;
				doc.clipCut();
				doc.importFile(png, false);
				
				ele = doc.selection[0];
				ele.x = rect.left;
				ele.y = rect.top;
			}else{
				
			}
		}
	}
}

//TODO:
function getPngNameStr(ele){
	var str = 'tmp.png';
	//if(ele.elementType == 'text'){
		//str = ele.getTextString();
	//}
	return str;
}