fInspectorSWFInjector = function(html) {
	var reg = /<((embed)|(object))((\s+[\w:-]+(\s*=\s*(("[^"]*")|('[^']*')|[^>\s]+))?)*)\s*type="application\/x-shockwave-flash"((\s+[\w:-]+(\s*=\s*(("[^"]*")|('[^']*')|[^>\s]+))?)*)\s*(\/?)>/g;

	if (reg.test(html)) {
		var num = html.match(reg).length;
		while (num--) {
			var match = reg.exec(html);
			var matchStr = match[0];
			// 查询是否含有id属性
			if (matchStr.match(/\s*id=(("[^"]*")|('[^']*'))/)) {
				// 已经有id属性了
				dump("\n has one id");
			} else {
				// 设置一个id
				matchStr = matchStr.substring(0, 7) + "id=\"" + ("finspector_" + new Date().getTime()) + "\"" + matchStr.substring(8);
			}

			// 进行allowFullScreen/allowScriptAccess的设置
			if (matchStr.indexOf("<embed") == 0) {
				matchStr = matchStr.replace(/allowfullscreen="\w+"/ig, "");
				matchStr = matchStr.replace(/allowscriptaccess="\w+"/ig, "");

				matchStr = matchStr.substring(0, 7) + "allowfullscreen=\"true\" allowscriptaccess=\"always\"" + matchStr.substring(7);

				reg.index = reg.lastIndex + (matchStr.length - match[0].length);
				html = html.substring(0, match.index) + matchStr + html.substring(match.index + match[0].length);
			} else if (matchStr.indexOf("<object") == 0) {
				matchStr = matchStr + html.substring(match.index + match[0].length, html.indexOf("</object>", match.index) + 9);

				matchStr = matchStr.replace(/<param name="allowfullscreen" value="\w+">/ig, "");
				matchStr = matchStr.replace(/<param name="allowscriptaccess" value="\w+">/ig, "");

				matchStr = matchStr.substring(0, matchStr.indexOf(">") + 1) + "<param name=\"allowfullscreen\" value=\"true\"><param name=\"allowscriptaccess\" value=\"always\">" + matchStr.substring(matchStr.indexOf(">") + 1);

				html = html.substring(0, match.index) + matchStr + html.substring(html.indexOf("</object>", match.index + 9));
				reg.index = html.indexOf("</object>", match.index + matchStr.length);
			}
		}
	}

	return html;
}