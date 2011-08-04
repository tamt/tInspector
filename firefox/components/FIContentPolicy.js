Components.utils.import('resource://gre/modules/XPCOMUtils.jsm');

const
nsIContentPolicy = Components.interfaces.nsIContentPolicy;
const
nsISupports = Components.interfaces.nsISupports;

function FIContentPolicy() {
	this.wrappedJSObject = this;
}

FIContentPolicy.prototype = {
	classDescription : 'My Hello World Javascript XPCOM Component',
	classID : Components.ID('{0A538808-BE5D-11E0-9450-F4304924019B}'),
	contractID : '@fi.itamt.com/helloworld;1',
	_xpcom_categories : [ {
		category : 'content-policy'
	} ],
	QueryInterface : XPCOMUtils.generateQI( [ nsIContentPolicy ]),

	// nsIContentPolicy interface implementation
	shouldLoad : function(contentType, contentLocation, requestOrigin,
			insecNode, mimeTypeGuess, extra) {
		return nsIContentPolicy.ACCEPT;
	},
	shouldProcess : function(contentType, contentLocation, requestOrigin,
			insecNode, mimeType, extra) {
		return nsIContentPolicy.ACCEPT;
	},
	hello : function(){
		return 'hello';
	}
};

if (XPCOMUtils.generateNSGetFactory) {
	var NSGetFactory = XPCOMUtils.generateNSGetFactory( [ FIContentPolicy ]);
} else {
	var NSGetModule = XPCOMUtils.generateNSGetModule( [ FIContentPolicy ]);
}
