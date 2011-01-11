/* prefutils.js   v1.1
 *  v1.0 (2005) Initial version
 *  v1.1 (20110103) Removed the note about the code being not final,
 *                  since it worked fine for 5 years.
 *
 * Wrapper for Mozilla preferences XPCOM components.
 * Copyright (c) 2005 Nickolay Ponomarev <asqueella@gmail.com>
 *
 * You may use this code in any way you want, but please send your changes back
 * to me if you think they may be useful to anybody else. Also please change
 * the object's name if you change the code before using it in an extension.
 *
 * Also if you decide to use it intact in your code, please drop me a line.
 *
 * Quick Examples:
 *  var gMyPrefs = new PrefsWrapper("extensions.myextension.");
 *  var lastname = gMyPrefs.getUnicharPref("user.lastname");
 *  // or call any nsIPrefBranch method:
 *  var age = gMyPrefs.getIntPref("user.age");
 *  // or a nsPreferences-like variant (with built-in exception handling):
 *  var middlename = gMyPrefs.getUnicharPrefDef("user.middlename", "default");
 *  // get wrapper for a sub-branch with:
 *  var branch = gMyPrefs.getSubBranch("user.");
 *
 * Documentation is available at http://mozilla.doslash.org/prefutils
 */

// do not define the same version twice
if(typeof(PrefsWrapper1) != "function") {
function PrefsWrapper1(aRoot)
{
  const CI = Components.interfaces;
  this.prefSvc = Components.classes["@mozilla.org/preferences-service;1"]
                 .getService(CI.nsIPrefService);
  this.prefSvc.QueryInterface(CI.nsIPrefBranch);
  this.branch = this.prefSvc.getBranch(aRoot);

  this.prefSvc.QueryInterface(CI.nsIPrefBranchInternal);
  this.branch.QueryInterface(CI.nsIPrefBranchInternal);

  // "inherit" from nsIPrefBranch, re-assembling __proto__ chain as follows:
  //    this, nsIPrefBranch, PrefsWrapper1.prototype, Object.prototype
  this.branch.__proto__ = PrefsWrapper1.prototype;
  this.__proto__ = this.branch;

  // Create "get*PrefDef" methods, which return specified default value
  // when an exception occurs - similar to nsPreferences.
  if(!("getIntPrefDef" in PrefsWrapper1.prototype)) {
    var types = ["Int", "Char", "Bool", "Unichar", "File"];
    for(var i in types) {
      PrefsWrapper1.prototype["get" + types[i] + "PrefDef"] = new Function(
        "aPrefName", "aDefValue",
          "try { return this.get" + types[i] + "Pref(aPrefName);\n" + 
          "} catch(e) {} return aDefValue;");
    }
  }
}

PrefsWrapper1.prototype = {
  getSubBranch: function(aSubpath) {
    return new PrefsWrapper1(this.branch.root + aSubpath);
  },

  // unicode strings
  getUnicharPref: function(aPrefName) {
    return this.branch.getComplexValue(aPrefName, 
      Components.interfaces.nsISupportsString).data;
  },
  setUnicharPref: function(aPrefName, aValue) {
    var str = Components.classes["@mozilla.org/supports-string;1"]
      .createInstance(Components.interfaces.nsISupportsString);
    str.data = aValue;
    this.branch.setComplexValue(aPrefName, 
      Components.interfaces.nsISupportsString, str);
  },

  // for strings with default value stored in locale's .properties file
  getLocalizedUnicharPref: function(aPrefName) {
    return this.branch.getComplexValue(aPrefName,
      Components.interfaces.nsIPrefLocalizedString).data;
  },

  // store nsILocalFile in prefs
  setFilePref: function(aPrefName, aValue) {
    this.branch.setComplexValue(aPrefName, Components.interfaces.nsILocalFile, 
      aValue);
  },
  getFilePref: function(aPrefName) {
    return this.branch.getComplexValue(aPrefName, 
      Components.interfaces.nsILocalFile);
  },

  // aRelTo - relative to what directory (f.e. "ProfD")
  setRelFilePref: function(aPrefName, aValue, aRelTo) {
    var relFile = Components.classes["@mozilla.org/pref-relativefile;1"]
      .createInstance(Components.interfaces.nsIRelativeFilePref);
    relFile.relativeToKey = aRelTo;
    relFile.file = aValue;
    this.branch.setComplexValue(aPrefName, 
      Components.interfaces.nsIRelativeFilePref, relFile);
  },
  getRelFilePref: function(aPrefName) {
    return this.branch.getComplexValue(aPrefName, 
      Components.interfaces.nsIRelativeFilePref).file;
  },

  // don't throw an exception if the pref doesn't have a user value
  clearUserPrefSafe: function(aPrefName) {
    try {
      this.branch.clearUserPref(aPrefName);
    } catch(e) {}
  }
}
}
