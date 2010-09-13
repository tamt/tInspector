var fInspector = {
id : "finspector@itamt.org",
path : "kiddingme?",
isOn : false,
enable : true,
preTab : null,
firefoxLoaded : false,
setEnable : function(v) {
	fInspector.enable = (String(v) == "true");
	if (!fInspector.enable) {
		fInspector.showNeedDebuggerFP();
	}
},
onFirefoxLoad : function(evt) {
	fInspector.trace('onFirefoxLoad...');
	fInspector.firefoxLoaded = true;

	var fpVersion = fInspectorUtil.getFlashPluginVersion();
	if (fpVersion.major > 9) {
		fInspector.setPreloadSwf(fInspector.getAddonFilePath("/content/tInspectorPreloader.swf"));
		fInspector.setPathFlashTrust(fInspector.getAddonFilePath("/content/"));

		fInspector.toggleProgressListener(gBrowser.webProgress, true);

		gBrowser.tabContainer.addEventListener("TabOpen", fInspector.handleEvent, false);
		gBrowser.tabContainer.addEventListener("TabClose", fInspector.handleEvent, false);

		gBrowser.addEventListener("DOMContentLoaded", function(event) {
			var doc = event.originalTarget;
			if (doc instanceof HTMLDocument) {
				doc.defaultView.addEventListener("unload", function() {
					fInspector.onPageUnload(doc);
				}, true);

				fInspector.onPageContentLoad(doc);
			}
		}, true);

		gBrowser.addEventListener("DOMNodeInserted", function(event) {
			fInspector.injectSwf(event.originalTarget);
		}, false);

		gBrowser.addEventListener("load", function(event) {
			var doc = event.originalTarget;
			if (doc instanceof HTMLDocument) {
				fInspector.onPageLoad(doc);
			}
		}, true);

		gBrowser.tabContainer.addEventListener("TabSelect", fInspector.onTabSelect, false);
	} else {
		fInspector.setEnable("false");
	}
},

// 关闭Firefox时
onFirefoxUnLoad : function(evt) {
	// 清除mm.cfg中PreloadSWF的设置
	fInspector.clearPreloadSwf(fInspector.getAddonFilePath("/content/tInspectorPreloader.swf"));

	fInspector.toggleProgressListener(gBrowser.webProgress, false);

	gBrowser.tabContainer.removeEventListener("TabOpen", fInspector.handleEvent, false);
	gBrowser.tabContainer.removeEventListener("TabClose", fInspector.handleEvent, false);
},

toggleProgressListener : function(aWebProgress, aIsAdd) {
	if (aIsAdd) {
		aWebProgress.addProgressListener(fInspector.progressListener, aWebProgress.NOTIFY_ALL);
	} else {
		aWebProgress.removeProgressListener(fInspector.progressListener);
	}
},

handleEvent : function(aEvent) {
	let
	tab = aEvent.target;
	let
	webProgress = gBrowser.getBrowserForTab(tab).webProgress;
	// fInspector.toggleProgressListener(webProgress,
	// ("TabOpen" == aEvent.type));

	// fInspector.toggleProgressListener(gBrowser.webProgress, webProgress,
	// ("TabOpen" == aEvent.type));
},

onTabSelect : function(evt) {
},

getSwfElements : function(doc) {
	var swfEles = [];

	var objs = doc.wrappedJSObject.getElementsByTagName("OBJECT");
	for ( var i = 0; i < objs.length; i++) {
		if (objs[i].type == "application/x-shockwave-flash") {
			swfEles.push(objs[i]);
		}
	}

	var embeds = doc.wrappedJSObject.embeds;
	for (i = 0; i < embeds.length; i++) {
		if (embeds[i].type == "application/x-shockwave-flash") {
			swfEles.push(embeds[i]);
		}
	}

	return swfEles;
},

reloadSwfElement : function(swfEle) {
	var pos = swfEle.style.position;
	gBrowser.addEventListener("MozAfterPaint", function(evt) {
		gBrowser.removeEventListener("MozAfterPaint", arguments.callee, false);
		swfEle.style.position = pos;
		swfEle.style.visibility = "none";
		fInspector.setSwfIdPersist(swfEle, 10);
	}, false);
	swfEle.style.position = (pos == "fixed" ? "relative" : "fixed");
},

setupSwfsInDoc : function(doc) {

	fInspector.trace("try setup swfs");

	// 为该documen注入一些js方法.供tInspectorPreloader调用.
	var tabDoc = doc;
	if (!doc.getElementById("finspector_js_injector")) {
		var script = tabDoc.createElement("script");
		script.setAttribute("type", "text/javascript");
		script.setAttribute("language", "JavaScript");
		script.id = "finspector_js_injector";
		script.innerHTML = "function fInspectorReloadSwf(swfId){var swfEle = document.getElementById(swfId);var visibility = swfEle.style.visibility;swfEle.style.visibility = \"none\";var pos = swfEle.style.position;swfEle.style.position = (pos == \"fixed\" ? \"relative\" : \"fixed\");setTimeout(function() {swfEle.style.position = pos;swfEle.style.visibility = visibility;setTimeout(function() {try{swfEle.setSwfId(swfId);}catch(error){}}, 300);}, 0);}";
		tabDoc.body.appendChild(script);
	}

	// 设置swf的属性, 比如:allowscriptaccess, allowfullscreen.
	var swfs = fInspector.getSwfElements(doc);
	fInspector.trace(swfs.length + " swf(s) was found in this page.");
	for ( var i = 0; i < swfs.length; i++) {
		var swf = swfs[i];
		if (!swf.fInspectorEnabled) {
			// 如果没有id,则分配一个.
			if (!swf.id) {
				swf.id = "fInspectorSwf_" + (new Date()).getTime();
			}
			if (swf.tagName == "OBJECT") {
				var param = doc.createElement("param");
				param.name = "allowScriptAccess";
				param.value = "always";
				swf.appendChild(param);

				param = doc.createElement("param");
				param.name = "allowFullScreen";
				param.value = "true";
				swf.appendChild(param);

				fInspector.trace("swf injected.");
			} else if (swf.tagName == "EMBED") {
				swf.setAttribute("allowscriptaccess", "always");
				swf.setAttribute("allowfullscreen", "true");

				fInspector.trace("swf injected.");
			}

			/*
			 * var anchor = doc.createElement("a"); anchor.setAttribute("href",
			 * "javascript:alert(\"finspector alert\");"); anchor.style.position =
			 * "absolute"; anchor.style.left = "0"; anchor.style.top = "0";
			 * anchor.innerHTML = "<img src=\"" +
			 * fInspectorUtil.convertURLtoURI(fInspector.getAddonFilePath("/skin/finspector_16.png")) +
			 * "\">"; doc.body.appendChild(anchor);
			 */
//			fInspector.reloadSwfElement(swf);
		}
	}
},

setSwfIdPersist : function(swf, num) {
	if (!swf.fInspectorEnabled) {
		try {
			swf.setSwfId(swf.id);
			swf.connectController();
			fInspector.trace("setSwfIdPersist: successfully" + swf.id + ", at " + num + "th time.");
			swf.fInspectorEnabled = true;
		} catch (error) {
			swf.fInspectorEnabled = false;
			if (num > 0) {
				setTimeout(function() {
					fInspector.setSwfIdPersist(swf, num - 1);
				}, 200);
			} else {
				fInspector.trace("setSwfIdPersist: failed");
				swf.style.visibility = "display";
			}
		}
	}
	if (swf.fInspectorEnabled) {
		swf.style.visibility = "display";
	}
},

/**
 * 整个页面加载完成
 */
onPageLoad : function(doc) {
	fInspector.trace("onPageLoad");
	fInspector.setupSwfsInDoc(doc);

	// 清除mm.cfg中PreloadSWF的设置
	fInspector.clearPreloadSwf(fInspector.getAddonFilePath("/content/tInspectorPreloader.swf"));
},

/**
 * 页面的文档加载完成
 */
onPageContentLoad : function(doc) {
	fInspector.trace("onPageContentLoad");
	fInspector.setupSwfsInDoc(doc);

	// doc.addEventListener("DOMNodeInserted", fInspector.onDomNodeInserted,
	// false);

	// 清除mm.cfg中PreloadSWF的设置
	// fInspector.clearPreloadSwf(fInspector.getAddonFilePath("/content/tInspectorPreloader.swf"));
},

onPageUnload : function(doc) {
	fInspector.trace("onPageUnload");

	// 设置swf的属性, 比如:allowscriptaccess, allowfullscreen.
	var swfs = fInspector.getSwfElements(doc);
	fInspector.trace(swfs.length + " swf(s) was found in this page.");
	for ( var i = 0; i < swfs.length; i++) {
		var swf = swfs[i];
		swf.fInspectorEnabled = false;
		try {
			swf.disconnectController();
		} catch (error) {

		}
	}

	// doc.removeEventListener("DOMNodeInserted", fInspector.onDomNodeInserted,
	// false);
},

onDomNodeInserted : function(evt) {
	fInspector.injectSwf(evt.target);
},

injectSwf : function(element) {
	var swf;
	if ((element.tagName == "OBJECT" || element.tagName == "EMBED") && element.type == "application/x-shockwave-flash") {
		swf = element;
		fInspector("an swf element was inserted.");
		if (!swf.id) {
			swf.id = "fInspectorSwf_" + (new Date()).getTime();
		}
		if (swf.tagName == "OBJECT") {
			var param = doc.createElement("param");
			param.name = "allowScriptAccess";
			param.value = "always";
			swf.appendChild(param);

			param = doc.createElement("param");
			param.name = "allowFullScreen";
			param.value = "true";
			swf.appendChild(param);
		} else if (swf.tagName == "EMBED") {
			swf.setAttribute("allowscriptaccess", "always");
			swf.setAttribute("allowfullscreen", "true");
		}

//		fInspector.reloadSwfElement(swf);
	} else {
	}
},

toggleInspector : function() {
	if (!fInspector.enable) {
		if (document.getElementById("needFlashPlayerPanel").state == "open") {
			fInspector.hideNeedDebuggerFP();
		} else {
			fInspector.showNeedDebuggerFP();
		}
		return;
	}
	fInspector.isOn = !fInspector.isOn;
	fInspector.callInspector();
},

callInspector : function() {
	fInspector.trace("callInspector");
	if (fInspector.isOn) {
		document.getElementById('finspectorBtnImg').setAttribute("state", "on");
		document.getElementById('tInspectorController').startInspector();
	} else {
		document.getElementById('finspectorBtnImg').setAttribute("state", "off");
		document.getElementById('tInspectorController').stopInspector();
	}
},
// 设置mm.cfg中的PreloadSWF值
setPreloadSwf : function(file) {
	var mmcfg = fInspectorFileIO.open(fInspectorUtil.getMMCfgPath());
	if (!mmcfg.exists()) {
		fInspector.trace('the mm.cfg file dose not exist, we create it.');
		fInspectorFileIO.create(mmcfg);
	}

	var data = fInspectorFileIO.read(mmcfg);
	var preloadSwfPath = "PreloadSWF=" + file;
	if (data.indexOf(preloadSwfPath) >= 0) {
		fInspector.trace('the PreloadSWF already be:' + file);
	} else {
		if (data.match(/PreloadSWF=.*\.swf/)) {
			data = data.replace(/PreloadSWF=.*.swf/, preloadSwfPath);
			fInspector.trace('replace preloadswf path: ' + data);
		} else {
			if (data.slice(-1) == "\r" || data.slice(-1) == "\n") {
				data += preloadSwfPath;
			} else {
				data += '\r' + preloadSwfPath;
			}
			fInspector.trace('add preloadswf path successful.');
		}

		fInspectorFileIO.write(mmcfg, data);
	}
},

clearPreloadSwf : function(file) {
	var mmcfg = fInspectorFileIO.open(fInspectorUtil.getMMCfgPath());
	if (!mmcfg.exists()) {
		fInspector.trace('the mm.cfg file dose not exist, we donot need to clear the PreloadSWF config.');
		return;
	}

	var data = fInspectorFileIO.read(mmcfg);
	var preloadSwfPath = "PreloadSWF=" + file;
	if (data.indexOf(preloadSwfPath) >= 0) {
		data = data.replace(preloadSwfPath, "");
		fInspectorFileIO.write(mmcfg, data);
		fInspector.trace('the PreloadSWF has been clear!');
	} else {
		fInspector.trace('the PreloadSWF reference other swf, so we donot need to clear it.');
	}
},

// 把文件路径添加到Flash Player的信任路径
setPathFlashTrust : function(path) {
	var cfg = fInspectorFileIO.open(fInspectorUtil.getFinspectorTrustPath());
	if (!cfg.exists()) {
		var cfgCreated = fInspectorFileIO.create(cfg);
		fInspector.trace('the cfg doesnot exist, create it: ' + cfgCreated);
	}

	var data = fInspectorFileIO.read(cfg);
	if (data.indexOf(path) < 0) {
		fInspector.trace('add path::' + path + ':: to cfg.');
		fInspectorFileIO.write(cfg, "\n" + path + "\n");
	} else {
		fInspector.trace('the path has been in cfg.');
	}
},

// 得到fInspector下文件的系统路径
getAddonFilePath : function(relativePath) {
	relativePath = relativePath.replace(/\//g, fInspectorUtil.PATH_SEP);
	return fInspector.path + relativePath;
},

// 如果Debugger Flash Player没有安装
showNeedDebuggerFP : function() {
	document.getElementById("needFlashPlayerPanel").openPopup(document.getElementById("finspectorBtnImg"), "before_end");
},

// 如果Debugger Flash Player没有安装
hideNeedDebuggerFP : function() {
	document.getElementById("needFlashPlayerPanel").hidePopup();
},

// 测试输出
trace : function(obj) {
	dump('\n' + obj);
},

// 打开一个tab
openTab : function(url) {
	gBrowser.selectedTab = gBrowser.addTab(url);
},

progressListener : {

QueryInterface : function(aIID) {
	if (aIID.equals(Components.interfaces.nsIWebProgressListener) || aIID.equals(Components.interfaces.nsISupportsWeakReference) || aIID.equals(Components.interfaces.nsISupports))
		return this;
	throw Components.results.NS_NOINTERFACE;
},

onStateChange : function(aWebProgress, aRequest, aFlag, aStatus) {
	var doc = aWebProgress.DOMWindow.document;
	if ((aFlag & Components.interfaces.nsIWebProgressListener.STATE_START) && (aFlag & Components.interfaces.nsIWebProgressListener.STATE_IS_DOCUMENT)) {
		fInspector.trace("This fires when the load event is initiated");
		fInspector.setPreloadSwf(fInspector.getAddonFilePath("/content/tInspectorPreloader.swf"));
	} else if ((aFlag & Components.interfaces.nsIWebProgressListener.STATE_STOP) && (aFlag & Components.interfaces.nsIWebProgressListener.STATE_IS_DOCUMENT)) {
		fInspector.trace("This fires when the load finishes");
		// 给该页面中所有swf元素分配id
		// fInspector.setupSwfsInDoc(doc);
	}
},

onLocationChange : function(aProgress, aRequest, aURI) {
	// This fires when the location bar changes; i.e load event is
	// confirmed
	// or when the user switches tabs. If you use myListener for more
	// than
	// one
	// tab/window,
	// use aProgress.DOMWindow to obtain the tab/window which triggered
	// the
	// change.
},

onProgressChange : function(aWebProgress, aRequest, curSelf, maxSelf, curTot, maxTot) {
},
onStatusChange : function(aWebProgress, aRequest, aStatus, aMessage) {
},
onSecurityChange : function(aWebProgress, aRequest, aState) {
}
}
};

if (Components.classes["@mozilla.org/extensions/manager;1"]) {
	fInspector.path = Components.classes["@mozilla.org/extensions/manager;1"].getService(Components.interfaces.nsIExtensionManager).getInstallLocation(fInspector.id).getItemFile(fInspector.id, "install.rdf").parent.path;

	fInspector.setPreloadSwf(fInspector.getAddonFilePath("/content/tInspectorPreloader.swf"));
	fInspector.setPathFlashTrust(fInspector.getAddonFilePath("/content/"));

	window.addEventListener('load', fInspector.onFirefoxLoad, false);
	window.addEventListener('unload', fInspector.onFirefoxUnLoad, false);
} else {
	try {
		Components.utils.import("resource://gre/modules/AddonManager.jsm");
		AddonManager.getAddonByID("finspector@itamt.org", function(addon) {
			var addonLocation = addon.getResourceURI("").QueryInterface(Components.interfaces.nsIFileURL).file;
			fInspector.path = addonLocation.path;

			fInspector.setPreloadSwf(fInspector.getAddonFilePath("/content/tInspectorPreloader.swf"));
			fInspector.setPathFlashTrust(fInspector.getAddonFilePath("/content/"));

			if (fInspector.firefoxLoaded) {
				fInspector.onFirefoxLoad(null);
			} else {
				window.addEventListener('load', fInspector.onFirefoxLoad, false);
			}
			window.addEventListener('unload', fInspector.onFirefoxUnLoad, false);

		});
	} catch (error) {
		dump("can not get the addon install location.");
	}
}

// window.addEventListener("load", function(e) {
// httpresponsetweak.windowEvent(e);
// }, false);
// window.addEventListener("unload", function(e) {
// httpresponsetweak.unload_httpresponsetweak(e);
// }, false);
//

/*
 * var httpresponsetweak = {
 * 
 * observerService :
 * Components.classes["@mozilla.org/observer-service;1"].getService(Components.interfaces.nsIObserverService),
 * 
 * windowEvent : function() { this.init_httpresponsetweak(); },
 * 
 * init_httpresponsetweak : function() {
 * this.observerService.addObserver(httpresponsetweak_httpRequestObserver,
 * "http-on-examine-response", false); },
 * 
 * unload_httpresponsetweak : function() {
 * this.observerService.removeObserver(httpresponsetweak_httpRequestObserver,
 * "http-on-examine-response"); },
 * 
 * setupStreamListener : function(httpChannel, aSubject) { var newListener = new
 * TracingListener();
 * aSubject.QueryInterface(Components.interfaces.nsITraceableChannel);
 * newListener.originalListener = aSubject.setNewListener(newListener); } };
 * 
 * var httpresponsetweak_httpRequestObserver = { observe : function(aSubject,
 * aTopic, aData) { if (aTopic == "http-on-examine-response") { var httpChannel =
 * aSubject.QueryInterface(Components.interfaces.nsIHttpChannel);
 * 
 * if (httpChannel.loadFlags & httpChannel.LOAD_INITIAL_DOCUMENT_URI)
 * this.checkRequest(httpChannel, aSubject); // this.checkRequest(httpChannel,
 * aSubject); } },
 * 
 * checkRequest : function(httpChannel, aSubject) { var reqhost =
 * httpChannel.getRequestHeader("host"); var responseStatus =
 * httpChannel.responseStatus;
 * 
 * httpresponsetweak.setupStreamListener(httpChannel, aSubject); },
 * 
 * QueryInterface : function(aIID) { if
 * (aIID.equals(Components.interfaces.nsIObserver) ||
 * aIID.equals(Components.interfaces.nsISupports)) { return this; } throw
 * Components.results.NS_NOINTERFACE; } };
 * 
 * function CCIN(cName, ifaceName) { return
 * Components.classes[cName].createInstance(Components.interfaces[ifaceName]); }
 * 
 * function TracingListener() { } TracingListener.prototype = {
 * 
 * originalListener : null,
 * 
 * onDataAvailable : function(request, context, inputStream, offset, count) {
 * 
 * var binaryInputStream = CCIN("@mozilla.org/binaryinputstream;1",
 * "nsIBinaryInputStream"); var storageStream =
 * CCIN("@mozilla.org/storagestream;1", "nsIStorageStream"); var
 * binaryOutputStream = CCIN("@mozilla.org/binaryoutputstream;1",
 * "nsIBinaryOutputStream"); // binaryInputStream.setInputStream(inputStream); //
 * var data = binaryInputStream.readBytes(count); var str = data; data =
 * fInspectorSWFInjector(str);
 * 
 * var newcount = data.length; // storageStream.init(8192, newcount, null); //
 * binaryOutputStream.setOutputStream(storageStream.getOutputStream(0));
 * binaryOutputStream.writeBytes(data, newcount);
 * 
 * this.originalListener.onDataAvailable(request, context,
 * storageStream.newInputStream(0), offset, newcount); },
 * 
 * onStartRequest : function(request, context) {
 * this.originalListener.onStartRequest(request, context); },
 * 
 * onStopRequest : function(request, context, statusCode) {
 * this.originalListener.onStopRequest(request, context, statusCode); },
 * 
 * QueryInterface : function(aIID) { if (aIID.equals(Ci.nsIStreamListener) ||
 * aIID.equals(Ci.nsISupports)) { return this; } throw
 * Components.results.NS_NOINTERFACE; } };
 */
