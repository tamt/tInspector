Components.utils.import('resource://gre/modules/XPCOMUtils.jsm');

const
nsIContentPolicy = Components.interfaces.nsIContentPolicy;
const
nsISupports = Components.interfaces.nsISupports;

function FIContentPolicy() {
	this.wrappedJSObject = this;
}

function log(msg) {
	var consoleService = Components.classes["@mozilla.org/consoleservice;1"]
			.getService(Components.interfaces.nsIConsoleService);
	consoleService.logStringMessage(msg);
}

FIContentPolicy.prototype = {
	classDescription : 'My Hello World Javascript XPCOM Component',
	classID : Components.ID('{0A538808-BE5D-11E0-9450-F4304924019B}'),
	contractID : '@fi.itamt.com/helloworld;1',
	_xpcom_categories : [ {
		category : 'content-policy'
	} ],
	listeners : [],
	currSwfNode:{},
	QueryInterface : XPCOMUtils.generateQI( [ nsIContentPolicy ]),

	// nsIContentPolicy interface implementation
	shouldLoad : function(contentType, contentLocation, requestOrigin,
			insecNode, mimeTypeGuess, extra) {
		if (contentType == nsIContentPolicy.TYPE_OBJECT
				&& mimeTypeGuess == 'application/x-shockwave-flash') {
			// 通知侦听器
			 log('should load swf: ' + contentLocation + ', ' + requestOrigin
					+ ', ' + insecNode.localName + ', ' + extra);
			
			for ( var i = 0; i < this.listeners.length; i++) {
				this.currSwfNode = insecNode;
				this.listeners[i].call();
			}
		}
		return nsIContentPolicy.ACCEPT;
	},
	shouldProcess : function(contentType, contentLocation, requestOrigin,
			insecNode, mimeType, extra) {
		return nsIContentPolicy.ACCEPT;
	},
	// 添加一个侦听加载swf的侦听器
	addListener : function(listener) {
		if (this.listeners.indexOf(listener) < 0) {
			this.listeners.push(listener);
		}
	},
	// 删除一个侦听加载swf的侦听器
	removeListener : function(listener) {
		var t = this.listeners.indexOf(listener);
		if (t >= 0)
			this.listeners.splice(t, 1);
	}
};

if (XPCOMUtils.generateNSGetFactory) {
	var NSGetFactory = XPCOMUtils.generateNSGetFactory( [ FIContentPolicy ]);
} else {
	var NSGetModule = XPCOMUtils.generateNSGetModule( [ FIContentPolicy ]);
}
