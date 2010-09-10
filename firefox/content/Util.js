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
}

};

fInspectorUtil.init();