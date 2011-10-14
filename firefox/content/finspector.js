//--------------------------------------------------------------------------------
//----------------------------[fInspector definition]-----------------------------
//--------------------------------------------------------------------------------

var fInspector = {
	id : "finspector@itamt.org",
	path : "",
	isOn : true,
	enable : true,
	preTab : null,
	isInjectGlobal : false,
	// there may be several Firefox instances, each Firefox's FI controller has
	// an id.
	controllerId : new Date().getTime().toString(),
	firefoxLoaded : false,
	currTarget : null,
	setEnable : function(v) {
		fInspector.enable = (String(v) == "true");
		if (!fInspector.enable) {
			fInspector.showNeedDebuggerFP();
		}
	},
	getControllerId : function() {
		return fInspector.controllerId;
	},
	onFirefoxLoad : function(evt) {
		fInspector.trace('onFirefoxLoad...');
		fInspector.firefoxLoaded = true;

		var fpVersion = fInspectorUtil.getFlashPluginVersion();
		if (fpVersion.major > 9) {
			// set the "PreloadSWF" config in mm.cfg, remind that we add a
			// "finspectorId" param to "tInspectorPreloader.swf", which will be
			// used to communicate with FI.
			fInspector.setPreloadSwf();
			fInspector.setPathFlashTrust(fInspector
					.getAddonFilePath("/content/"));

			// listen the web load init event.
			fInspector.toggleProgressListener(gBrowser.webProgress, true);

			gBrowser.tabContainer.addEventListener("TabOpen",
					fInspector.handleEvent, false);
			gBrowser.tabContainer.addEventListener("TabClose",
					fInspector.handleEvent, false);

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

			gBrowser.tabContainer.addEventListener("TabSelect",
					fInspector.onTabSelect, false);
		} else {
			fInspector.setEnable("false");
		}
	},

	// when firefox close
	onFirefoxUnLoad : function(evt) {
		fInspector.clearPreloadSwf();

		fInspector.toggleProgressListener(gBrowser.webProgress, false);

		gBrowser.tabContainer.removeEventListener("TabOpen",
				fInspector.handleEvent, false);
		gBrowser.tabContainer.removeEventListener("TabClose",
				fInspector.handleEvent, false);
	},

	toggleProgressListener : function(aWebProgress, aIsAdd) {
		if (aIsAdd) {
			aWebProgress.addProgressListener(fInspector.progressListener,
					aWebProgress.NOTIFY_ALL);
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
			gBrowser.removeEventListener("MozAfterPaint", arguments.callee,
					false);
			swfEle.style.position = pos;
			swfEle.style.visibility = "none";
			fInspector.setSwfIdPersist(swfEle, 10);
		}, false);
		swfEle.style.position = (pos == "fixed" ? "relative" : "fixed");
	},

	setupSwfsInDoc : function(doc) {
		//
	},

	setSwfIdPersist : function(swf, num) {
		if (!swf.fInspectorEnabled) {
			try {
				swf.setSwfId(swf.id);
				swf.connectController();
				fInspector.trace("setSwfIdPersist: successfully" + swf.id
						+ ", at " + num + "th time.");
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
	 * on page load
	 */
	onPageLoad : function(doc) {
		fInspector.trace("onPageLoad");
		fInspector.setupSwfsInDoc(doc);

		// clear "PreloadSwf" config in mm.cfg
		if (!fInspector.isInjectGlobal) {
			 fInspector.clearPreloadSwf();
		}
	},

	/**
	 * when page content loaded.
	 */
	onPageContentLoad : function(doc) {
		fInspector.trace("onPageContentLoad");
		fInspector.setupSwfsInDoc(doc);

		// doc.addEventListener("DOMNodeInserted", fInspector.onDomNodeInserted,
		// false);

		// clear the "PreloadSWF" config in mm.cfg
		// fInspector.clearPreloadSwf();
	},

	onPageUnload : function(doc) {
		fInspector.trace("onPageUnload");

		// set the swf "fInspectorEnabled" as false;
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

		// doc.removeEventListener("DOMNodeInserted",
		// fInspector.onDomNodeInserted,
		// false);
	},

	onDomNodeInserted : function(evt) {
		fInspector.injectSwf(evt.target);
	},

	injectSwf : function(element) {
		// return;
		var swf;
		if ((element.tagName == "OBJECT" || element.tagName == "EMBED")
				&& element.type == "application/x-shockwave-flash") {
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

			// fInspector.reloadSwfElement(swf);
		} else {
		}
	},

	// 在所有FlashPlayer中注入FlashInspector.
	toggleInjectModeGlobal : function(owner) {
		fInspector.isInjectGlobal = !document
				.getElementById("fInspectorInjectMode_Global").checked;

		// 往FlasPlayer注入FI.
		if (fInspector.isInjectGlobal) {
			// fInspector.setPreloadSwf();
		}

		// 写入配置
		let
		_prefService = Cc["@mozilla.org/preferences-service;1"]
				.getService(Ci.nsIPrefBranch);
		_prefService.setBoolPref("extensions.flashinspector.injectGlobal",
				fInspector.isInjectGlobal);
	},

	toggleInspector : function(event) {
		// if the mouseup event is trigger by right-click
		if (event.button == 2) {
			document.getElementById("fInspectorSetting").openPopup(
					document.getElementById("finspectorBtnImg"), "before_end");

			document.getElementById("fInspectorInjectMode_Global").checked = fInspector.isInjectGlobal;
		}

		// the mouseup event is not trigger by left-click
		if (event.button != 0)
			return;

		if (!fInspector.enable) {
			if (document.getElementById("needFlashPlayerPanel").state == "open") {
				fInspector.hideNeedDebuggerFP();
			} else {
				fInspector.showNeedDebuggerFP();
			}
			return;
		}
		fInspector.callInspector();
	},

	callInspector : function() {
		fInspector.trace("callInspector");
		document.getElementById('tInspectorConsoleMonitor').toggleInspector();
	},

	onInspectorState : function(state) {
		if (state == "on") {
			document.getElementById('finspectorBtnImg').setAttribute("state",
					"on");
		} else if (state == "off") {
			document.getElementById('finspectorBtnImg').setAttribute("state",
					"off");
		}
	},

	// set file path to "PreloadSWF" in mm.cfg
	setPreloadSwf : function() {
		// if (!fInspector.enable)
		// return;
		var file = fInspector
				.getAddonFilePath("/content/tInspectorPreloader.swf?finspectorId="
						+ fInspector.controllerId);

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
			if (data.match(/PreloadSWF=.*\.swf\S*/)) {
				data = data.replace(/PreloadSWF=.*\.swf\S*/, preloadSwfPath);
				fInspector.trace('replace preloadswf path: ' + data);
			} else {
				if (data.slice(-1) == "\r" || data.slice(-1) == "\n") {
					data += preloadSwfPath;
				} else {
					data += '\r' + preloadSwfPath;
				}
				fInspector.trace('add preloadswf path successful: ' + data);
			}

			fInspectorFileIO.write(mmcfg, data);
		}
	},

	// clear the "PreloadSWF" config in mm.cfg
	clearPreloadSwf : function() {
		var file = fInspector
				.getAddonFilePath("/content/tInspectorPreloader.swf?finspectorId="
						+ fInspector.controllerId);
		var mmcfg = fInspectorFileIO.open(fInspectorUtil.getMMCfgPath());
		if (!mmcfg.exists()) {
			fInspector
					.trace('the mm.cfg file dose not exist, we donot need to clear the PreloadSWF config.');
			return;
		}

		var data = fInspectorFileIO.read(mmcfg);
		var preloadSwfPath = "PreloadSWF=" + file;
		if (data.indexOf(preloadSwfPath) >= 0) {
			data = data.replace(preloadSwfPath, "");
			fInspectorFileIO.write(mmcfg, data);
			fInspector.trace('the PreloadSWF has been clear!');
		} else {
			fInspector
					.trace('the PreloadSWF reference other swf, so we donot need to clear it.');
		}
	},

	// add the path to Flash Player trusted path.
	setPathFlashTrust : function(path) {
		var cfg = fInspectorFileIO
				.open(fInspectorUtil.getFinspectorTrustPath());
		if (!cfg.exists()) {
			var cfgCreated = fInspectorFileIO.create(cfg);
			fInspector.trace('the cfg doesnot exist, create it: ' + cfgCreated);
		}

		var data = fInspectorFileIO.read(cfg);
		if (data.indexOf(path) < 0) {
			fInspector.trace('add path::' + path + ':: to cfg.');
			fInspectorFileIO.write(cfg, data + "\n" + path + "\n");
		} else {
			fInspector.trace('the path has been in cfg.');
		}
	},

	// get the full path of a file under extension folder.
	getAddonFilePath : function(relativePath) {
		relativePath = relativePath.replace(/\//g, fInspectorUtil.PATH_SEP);
		return fInspector.path + relativePath;
	},

	// show panel tell user need debugger flashplayer.
	showNeedDebuggerFP : function() {
		document.getElementById("needFlashPlayerPanel").openPopup(
				document.getElementById("finspectorBtnImg"), "before_end");
	},
	hideNeedDebuggerFP : function() {
		document.getElementById("needFlashPlayerPanel").hidePopup();
	},

	// for debug msg
	trace : function(obj) {
		// dump('\n' + obj);
		// alert('\n' + obj);
	},

	// let firefox open an tab.
	openTab : function(url) {
		gBrowser.selectedTab = gBrowser.addTab(url);
	},

	// close the Setting Panel, not used currently.
	closeSettingPanel : function() {
		document.getElementById("fInspectorSetting").hidePopup();
	},

	// called by tInspectorConsoleMonitor.swf(tInspectorConsoleMonitor) when
	// user
	// click the FI plugin Icon on Setting Panel
	showFlashInspectorPluginGuide : function(pluginName) {
		var stringBundle = document.getElementById("tips");
		alert(stringBundle.getString(pluginName + "Guide"));
	},

	// called by tInspectorConsoleMonitor.swf(tInspectorConsoleMonitor) when
	// tInspectorPreloader.swf fail to fullscreen. if confirmed, FI will find
	// the swf by swfid, and reload it.
	showFullScreenGuide : function(swfId) {
		var stringBundle = document.getElementById("tips");
		if (confirm(stringBundle.getString("NeedReloadForFullScreenGuide"))) {
			var swf = gBrowser.contentDocument.wrappedJSObject
					.getElementById(swfId);
			fInspector.reloadSwfElement(swf);
		}
	},

	// called by tInspectorConsoleMonitor.swf(tInspectorConsoleMonitor) when
	// tInspectorPreloader.swf fail to fullscreen. if confirmed, FI will find
	// the swf by swfUrl, and reload it.
	showFullScreenGuideByUrl : function(swfUrl) {
		var stringBundle = document.getElementById("tips");
		if (confirm(stringBundle.getString("NeedReloadForFullScreenGuide"))) {
			var swf = fInspector.getSwfElementByUrl(gBrowser.contentDocument,
					swfUrl);
			fInspector.reloadSwfElement(swf);
		}
	},

	// called by tInspectorConsoleMonitor.swf(tInspectorConsoleMonitor), find a
	// swf
	// element by swf id, and reload it.
	reloadSwf : function(swfId) {
		var swf = gBrowser.contentDocument.wrappedJSObject
				.getElementById(swfId);
		fInspector.reloadSwfElement(swf);
	},

	// called by tInspectorConsoleMonitor.swf(tInspectorConsoleMonitor), find a
	// swf
	// element by swf url, and reload it.
	reloadSwfByUrl : function(swfUrl) {
		var swf = fInspector.getSwfElementByUrl(gBrowser.contentDocument,
				swfUrl);
		fInspector.reloadSwfElement(swf);
	},

	// find a swf element by swf url
	getSwfElementByUrl : function(doc, swfUrl) {
		var swfs = fInspector.getSwfElements(doc);
		var target;
		for ( var i = 0; i < swfs.length; i++) {
			var swf = swfs[i];
			if (swf.tagName == "OBJECT") {
				if (swfUrl.indexOf(swf["data"]) >= 0) {
					target = swf;
					break;
				}
			} else if (swf.tagName == "EMBED") {
				if (swfUrl.indexOf(swf["src"]) >= 0) {
					target = swf;
					break;
				}
			}
		}

		return target;
	},

	// called when user check plugin on Setting Panel.
	checkInspectorPlugin : function(pluginCheckBox) {
		var pluginId = pluginCheckBox.id.slice(("fInspectorPlugin_").length);

		// call tInspectorConsoleMonitor.swf store select/unselect plugin
		// setting (to SharedObject).
		if (!pluginCheckBox.checked) {
			// direct to FlashFirebug add-on if it's not installed yet
			if (pluginId == "FlashFirebug") {
				if (!fInspector.isFlashFirebugInstalled()) {
					var stringBundle = document.getElementById("tips");
					if (confirm(stringBundle.getString("NeedFlashFirebugGuide"))) {
						fInspector
								.openTab("https://addons.mozilla.org/en-US/firefox/addon/161670/");
					}
					setTimeout(function() {
						pluginCheckBox.checked = false;
					}, 100);
				} else {
					document.getElementById('tInspectorConsoleMonitor')
							.selectPlugin(pluginId);
					// 注入FlashFirebug, 增加openTree功能
					fInspector.injectFlashFirebug();
				}
			} else {
				document.getElementById('tInspectorConsoleMonitor')
						.selectPlugin(pluginId);
			}
		} else {
			document.getElementById('tInspectorConsoleMonitor').rejectPlugin(
					pluginId);
		}
	},

	// 向FlashFirebug注入脚本, 增强其功能.
	injectFlashFirebug : function() {
		try {
			Firebug.FlashPanel.prototype.openTree = function(data) {
				var target = $FQuery("#base li[rel='" + (data.id) + "'] ",
						this.panelNode);
				if (!$FQuery(target).hasClass("isOpened")) {
					$FQuery(target).addClass("isOpened");
					$FQuery(target).children("ul").slideDown("fast");
				}

				var absNameArr = (data.target).split(".");
				var absName = "li[rel='" + (data.id) + "'] ";
				var path = "";
				if (data.target != 'root') {
					for ( var i = 0; i < absNameArr.length; i++) {
						absName += "li[index='" + absNameArr[i] + "'] ";

						if (i > 0) {
							var target = $FQuery(absName, this.panelNode);
							if (target.length == 0) {
								Firebug.FlashModule.fromFlashFirebug({
									command : "getTree",
									target : path,
									id : data.id
								});
								var _this = this;

								setTimeout(function() {
									_this.openTree(data)
								}, 100);
								break;
							} else {
								if (i == absNameArr.length - 1) {
									// 把之前选中的 清除样式
									$FQuery(".selected", this.panelNode)
											.removeClass("selected");

									// 设置为选中样式
									target = $FQuery(target).first();
									$FQuery(target).children("a").addClass(
											"selected");

									// 把滚动条定位到该li的区域
									var offset = $FQuery(target).offset();
									offset.top += this.panelNode.scrollTop;
									if (offset.top < this.panelNode.scrollTop
											|| offset.top > (this.panelNode.scrollTop + this.panelNode.clientHeight)) {
										$FQuery(this.panelNode)
												.animate(
														{
															scrollTop : offset.top
																	- this.panelNode.clientHeight
																	/ 2
														}, 500);
									}
								}
							}
							path += "." + absNameArr[i];
						} else {
							path += absNameArr[i];
						}
					}
				}
			}
		} catch (error) {

		}
	},

	isFlashFirebugInstalled : function() {
		try {
			if (FBL && Firebug && Firebug.FlashModule
					&& Firebug.FlashModule.toFlashFirebug
					&& Firebug.FlashModule.toFlashFirebug) {
				return true;
			}
		} catch (error) {
		}
		return false;
	},

	// called by tInspectorConsoleMonitor.swf (tInspectorConsoleMonitor), after
	// it
	// read the plugin select setting from SharedObject.
	showCheckInspectorPlugin : function(pluginId, check) {
		var pluginCheckBox = document.getElementById("fInspectorPlugin_"
				+ pluginId);
		pluginCheckBox.checked = check;
		if (pluginId == "FlashFirebug") {
			// 注入FlashFirebug, 增加openTree功能
			if (check)
				fInspector.injectFlashFirebug();
		}
	},

	// reload all pages
	restartFirefox : function() {
		var Application = Components.classes["@mozilla.org/fuel/application;1"]
				.getService(Components.interfaces.fuelIApplication);
		Application.restart();
	},

	progressListener : {
		QueryInterface : function(aIID) {
			if (aIID.equals(Components.interfaces.nsIWebProgressListener)
					|| aIID
							.equals(Components.interfaces.nsISupportsWeakReference)
					|| aIID.equals(Components.interfaces.nsISupports))
				return this;
			throw Components.results.NS_NOINTERFACE;
		},

		onStateChange : function(aWebProgress, aRequest, aFlag, aStatus) {
			var doc = aWebProgress.DOMWindow.document;
			if ((aFlag & Components.interfaces.nsIWebProgressListener.STATE_START)
					&& (aFlag & Components.interfaces.nsIWebProgressListener.STATE_IS_DOCUMENT)) {
				fInspector.trace("This fires when the load event is initiated");
				fInspector.setPreloadSwf();
			} else if ((aFlag & Components.interfaces.nsIWebProgressListener.STATE_STOP)
					&& (aFlag & Components.interfaces.nsIWebProgressListener.STATE_IS_DOCUMENT)) {
				fInspector.trace("This fires when the load finishes");
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

		onProgressChange : function(aWebProgress, aRequest, curSelf, maxSelf,
				curTot, maxTot) {
		},
		onStatusChange : function(aWebProgress, aRequest, aStatus, aMessage) {
		},
		onSecurityChange : function(aWebProgress, aRequest, aState) {
		}
	},

	init : function() {
		let
		_prefService = Cc["@mozilla.org/preferences-service;1"]
				.getService(Ci.nsIPrefBranch);

		fInspector.isInjectGlobal = _prefService
				.getBoolPref("extensions.flashinspector.injectGlobal");
		
		if (_prefService.getBoolPref("extensions.flashinspector.installed")) {

			var finspectorPath = (_prefService.getComplexValue(
					"extensions.flashinspector.path",
					Components.interfaces.nsISupportsString).data);

			if (Components.classes["@mozilla.org/extensions/manager;1"]) {
				// it's Firefox 3!!
				fInspector.path = Components.classes["@mozilla.org/extensions/manager;1"]
						.getService(Components.interfaces.nsIExtensionManager)
						.getInstallLocation(fInspector.id).getItemFile(
								fInspector.id, "install.rdf").parent.path;

				fInspector.setPreloadSwf();
				fInspector.setPathFlashTrust(fInspector
						.getAddonFilePath("/content/"));

				if (fInspector.firefoxLoaded) {
					fInspector.restartFirefox();
				}
			} else {
				// it's Firefox 4!!

				fInspector.path = finspectorPath;
				fInspector.setPreloadSwf();
				fInspector.setPathFlashTrust(fInspector
						.getAddonFilePath("/content/"));

				if (fInspector.firefoxLoaded) {
					fInspector.restartFirefox();
				}
			}

			window.addEventListener('load', fInspector.onFirefoxLoad, false);
			window
					.addEventListener('unload', fInspector.onFirefoxUnLoad,
							false);
		} else {
			_prefService.setBoolPref("extensions.flashinspector.installed",
					true)

			// 首次运行, 进行tInspectorConsoleMonitor.swf的路径设置
			if (Components.classes["@mozilla.org/extensions/manager;1"]) {
				// Firefox 3
				// 将dom.ipc.plugins.enabled.npswf32.dll设置为false
				if (_prefService
						.getBoolPref("dom.ipc.plugins.enabled.npswf32.dll")) {
					_prefService.setBoolPref(
							"dom.ipc.plugins.enabled.npswf32.dll", false);
				}

				fInspector.path = Components.classes["@mozilla.org/extensions/manager;1"]
						.getService(Components.interfaces.nsIExtensionManager)
						.getInstallLocation(fInspector.id).getItemFile(
								fInspector.id, "install.rdf").parent.path;

				var inspectorPath = Components.classes["@mozilla.org/supports-string;1"]
						.createInstance(Components.interfaces.nsISupportsString);
				inspectorPath.data = fInspector.path;
				_prefService.setComplexValue("extensions.flashinspector.path",
						Components.interfaces.nsISupportsString, inspectorPath);

				var xulPath = fInspector
						.getAddonFilePath("/content/finspector.xul");

				var xul = fInspectorFileIO.open(xulPath);
				var data = fInspectorFileIO.read(xul);
				if (data.match(/%tInspectorConsoleMonitor%/)) {
					data = data
							.replace(/%tInspectorConsoleMonitor%/,
									"chrome://finspector/content/tInspectorConsoleMonitor.swf");
					fInspectorFileIO.write(xul, data);
				}

				fInspector.restartFirefox();
			} else {
				// Firefox 4
				// 将dom.ipc.plugins.enabled.npswf32.dll设置为false
				if (_prefService.getBoolPref("dom.ipc.plugins.enabled")) {
					_prefService.setBoolPref("dom.ipc.plugins.enabled", false);
				}

				try {
					Components.utils
							.import("resource://gre/modules/AddonManager.jsm");

					AddonManager
							.getAddonByID(
									"finspector@itamt.org",
									function(addon) {
										var addonLocation = addon
												.getResourceURI("")
												.QueryInterface(
														Components.interfaces.nsIFileURL).file;
										fInspector.path = addonLocation.path;

										// /////store the fInspector.path to the
										// Prefereneces/////
										var str = Components.classes["@mozilla.org/supports-string;1"]
												.createInstance(Components.interfaces.nsISupportsString);
										str.data = fInspector.path;
										_prefService
												.setComplexValue(
														"extensions.flashinspector.path",
														Components.interfaces.nsISupportsString,
														str);
										// ////////////////////////////////////////////////////////

										// 把xul中的路径替换成真实路径//
										var xulPath = fInspector
												.getAddonFilePath("/content/finspector.xul");

										var xul = fInspectorFileIO
												.open(xulPath);
										var data = fInspectorFileIO.read(xul);
										if (data
												.match(/%tInspectorConsoleMonitor%/)) {
											data = data
													.replace(
															/%tInspectorConsoleMonitor%/,
															"chrome://finspector/content/tInspectorConsoleMonitor.swf");
											fInspectorFileIO.write(xul, data);
										}
										// //////////////////////////////

										fInspector.setPreloadSwf();
										fInspector.setPathFlashTrust(fInspector
												.getAddonFilePath("/content/"));

										fInspector.restartFirefox();
									});
				} catch (error) {
					dump("can not get the addon install location.");
				}
			}
		}

		window.addEventListener("flashblockCheckLoad",
				fInspector.checkLoadFlash, true, true);
	},

	checkLoadFlash : function(event) {
		//fInspector.setPreloadSwf();
	}
};
// --------------------------------------------------------------------------------
// --------------------------------------------------------------------------------
// --------------------------------------------------------------------------------

fInspector.init();