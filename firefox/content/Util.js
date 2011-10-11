var fInspectorUtil = {
OS : "",
WINDOWS : "winnt",
LINUX : "linux",
MAC : "darwin",
PATH_SEP : "/",
init : function() {
	try {
		// 当前系统
		var osString = Components.classes["@mozilla.org/xre/app-info;1"].getService(Components.interfaces.nsIXULRuntime).OS;
		switch (osString.toLowerCase()) {
		case fInspectorUtil.WINDOWS:
			fInspectorUtil.OS = fInspectorUtil.WINDOWS; // Windows Vista, XP,
														// 2000, and NT
			// systems;
			fInspectorUtil.PATH_SEP = "\\";
			break;
		case fInspectorUtil.LINUX:
			fInspectorUtil.OS = fInspectorUtil.LINUX; // GNU/Linux;
			fInspectorUtil.PATH_SEP = "/";
			break;
		case fInspectorUtil.MAC:
			fInspectorUtil.OS = fInspectorUtil.MAC; // MAC OSX/Darwin
			fInspectorUtil.PATH_SEP = "/";
			break;
		default:
			fInspectorUtil.OS = fInspectorUtil.WINDOWS;
			fInspectorUtil.PATH_SEP = "\\";
		}
	} catch (e) {
		fInspectorUtil.OS = fInspectorUtil.WINDOWS;
	}
},

// Flash Player的安全（信任）目录路径finspector.cfg
getFinspectorTrustPath : function() {
	switch (fInspectorUtil.OS) {
	case fInspectorUtil.WINDOWS:
		var fl = Components.classes["@mozilla.org/file/directory_service;1"].getService(Components.interfaces.nsIProperties).get("AppData", Components.interfaces.nsIFile);
		var fp = fl.path + "\\Macromedia\\Flash Player\\#Security\\FlashPlayerTrust\\finspector.cfg";
		break;
	case fInspectorUtil.LINUX:
		var fl = Components.classes["@mozilla.org/file/directory_service;1"].getService(Components.interfaces.nsIProperties).get("Home", Components.interfaces.nsIFile);
		var fp = fl.path + "/.macromedia/Flash_Player/#Security/FlashPlayerTrust/finspector.cfg";
		break;
	case fInspectorUtil.MAC:
		var fl = Components.classes["@mozilla.org/file/directory_service;1"].getService(Components.interfaces.nsIProperties).get("ULibDir", Components.interfaces.nsIFile);
		var fp = fl.path + "/Preferences/Macromedia/Flash Player/#Security/FlashPlayerTrust/finspector.cfg";
		break;
	}
	return fp;
},

// Flash Player的mm.cfg文件
getMMCfgPath : function() {
	switch (fInspectorUtil.OS) {
	case fInspectorUtil.WINDOWS:
		var fl = Components.classes["@mozilla.org/file/directory_service;1"].getService(Components.interfaces.nsIProperties).get("Home", Components.interfaces.nsIFile);
		var fp = fl.path + "\\mm.cfg";
		break;
	case fInspectorUtil.LINUX:
		var fl = Components.classes["@mozilla.org/file/directory_service;1"].getService(Components.interfaces.nsIProperties).get("Home", Components.interfaces.nsIFile);
		var fp = fl.path + "/mm.cfg";
		break;
	case fInspectorUtil.MAC:
		var fl = Components.classes["@mozilla.org/file/directory_service;1"].getService(Components.interfaces.nsIProperties).get("Home", Components.interfaces.nsIFile);
		var fp = fl.path + "/mm.cfg";
		break;
	}
	return fp;
},

// 检查Firefox是否已经安装了Debug版本的Flash Player
isDebugFlashPlayerInstalled : function() {
	var plugin = navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin;
	if (plugin) {
		for ( var prop in plugin) {
			var description = plugin.description;
		}
		return true;
	} else {
		return false;
	}
},

convertURLtoURI : function(url) {
	var path = 'file:///' + url.replace(/\\/g, '/');
	return path;
},

getElementPosition: function(element)
{
	// Restrict rectangle coordinates by the boundaries of a window's client area
	function intersectRect(rect, wnd)
	{
		let doc = wnd.document;
		let wndWidth = doc.documentElement.clientWidth;
		let wndHeight = doc.documentElement.clientHeight;
		if (doc.compatMode == "BackCompat") // clientHeight will be bogus in quirks mode
			wndHeight = doc.documentElement.offsetHeight - wnd.scrollMaxY;
		
		rect.left += doc.documentElement.scrollLeft;
		rect.top += doc.documentElement.scrollTop;

		rect.left = Math.max(rect.left, 0);
		rect.top = Math.max(rect.top, 0);
		rect.right = Math.min(rect.right, wndWidth);
		rect.bottom = Math.min(rect.bottom, wndHeight);
	}

	let rect = element.getBoundingClientRect();
	let wnd = element.ownerDocument.defaultView;

	let offsets = [0, 0, 0, 0];
	_objectOverlapsBorder = false;
	if (!_objectOverlapsBorder)
	{
		let style = wnd.getComputedStyle(element, null);
		offsets[0] = parseFloat(style.borderLeftWidth) + parseFloat(style.paddingLeft);
		offsets[1] = parseFloat(style.borderTopWidth) + parseFloat(style.paddingTop);
		offsets[2] = parseFloat(style.borderRightWidth) + parseFloat(style.paddingRight);
		offsets[3] = parseFloat(style.borderBottomWidth) + parseFloat(style.paddingBottom);
	}

	rect = {left: rect.left + offsets[0], top: rect.top + offsets[1],
					right: rect.right - offsets[2], bottom: rect.bottom - offsets[3]};
	while (true)
	{
		intersectRect(rect, wnd);

		if (!wnd.frameElement)
			break;

		// Recalculate coordinates to be relative to frame's parent window
		let frameElement = wnd.frameElement;
		wnd = frameElement.ownerDocument.defaultView;
		
		//wf.ownerDocument.defaultView.top.document;

		let frameRect = frameElement.getBoundingClientRect();
		let frameStyle = wnd.getComputedStyle(frameElement, null);
		let relLeft = frameRect.left + parseFloat(frameStyle.borderLeftWidth) + parseFloat(frameStyle.paddingLeft);
		let relTop = frameRect.top + parseFloat(frameStyle.borderTopWidth) + parseFloat(frameStyle.paddingTop);

		rect.left += relLeft;
		rect.right += relLeft;
		rect.top += relTop;
		rect.bottom += relTop;
	}

	return rect;
},

getFlashPluginVersion : function() {
	var version = {
	major : -1,
	minor : -1,
	installed : false,
	scriptable : false
	};

	var plugin = navigator.mimeTypes["application/x-shockwave-flash"].enabledPlugin;
	if (!plugin) {
		return version;
	}

	version.installed = true;

	var description = plugin.description;

	// use RegExp to obtain the relevant version strings
	// obtain an array of size 2 with version information

	var versionArray = description.match(/[\d.]+/g);

	if (!versionArray) {
		return version;
	}

	if (versionArray.length >= 1 && !isNaN(versionArray[0])) {
		version.major = parseFloat(versionArray[0]);
	}

	if (versionArray.length >= 2 && !isNaN(versionArray[1])) {
		version.minor = parseFloat(versionArray[1]);
	}

	if (version.major < 6 || navigator.product != 'Gecko') {
		return version;
	}

	if (version.major > 6 || version.minor >= 47) {
		version.scriptable = true;
	}

	return version;
},

//https://addons.mozilla.org/en-US/firefox/files/browse/126475/file/chrome/flashblock.jar/content/flashblock/flashblock.js#top
getTargetURI : function(node) {
	var targetURI;
	try {
		// Get object URI in the same way as
		// nsObjectLoadingContent::LoadObject()
		var relativeURI;
		switch (node.localName.toLowerCase()) {
		case "object":
			relativeURI = node.getAttribute("data")
					|| node.getAttribute("src") || "";
			if (!relativeURI) {
				var params = node.getElementsByTagName("param");

				for ( var ii = 0; ii < params.length; ii++) {
					var name = params[ii].getAttribute("name");
					switch (name) {
					case "movie":
					case "src":
						relativeURI = params[ii].getAttribute("value");
						break;
					}
				}
			}
			break;
		case "embed":
			relativeURI = node.getAttribute("src") || "";
			break;
		}

		var ios = Components.classes["@mozilla.org/network/io-service;1"]
				.getService(Components.interfaces.nsIIOService);
		var baseURI = ios.newURI(node.baseURI, null, null);
		var codeBase = node.getAttribute("codebase");
		if (codeBase) {
			try {
				baseURI = ios.newURI(codeBase,
						node.ownerDocument.characterSet, baseURI);
			} catch (e) {
			} // Ignore invalid codebase attribute
		}
		targetURI = ios.newURI(relativeURI,
				node.ownerDocument.characterSet, baseURI);
	} catch (e) {
		Components.utils.reportError(e);
	}
	return targetURI;
}

};

fInspectorUtil.init();