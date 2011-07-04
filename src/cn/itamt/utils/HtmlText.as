package
{
	/**
	 * @author tamt
	 */
	public class HtmlText
	{
		private var _html : String;
		private var _text : String;
		private var _reg : RegExp = /<(?)[^>]*>/g;
		private var _textIndexs : Array;

		public function HtmlText(html : String)
		{
			this._html = html;
			this._text = this._html.replace(/<(?)[^>]*>/g, "");

			_textIndexs = [];
			var myPattern : RegExp = /<(?)[^>]*>/g;
			var str : String = _html;
			var result : Object = myPattern.exec(str);
			while (result != null)
			{
				_textIndexs.push({index:result.index, length:result[0].length});
				result = myPattern.exec(str);
			}
		}

		/**
		 * @param startTextIndex	開始截取位置(text字符串索引)
		 * @param endTextIndex		結束截取位置(text字符串索引)
		 * @return	html字符串
		 */
		public function slice(startTextIndex : Number = 0, endTextIndex : Number = 0) : String
		{
			var startIndex : Number = textIndex2StrIndex(startTextIndex);
			var endIndex : Number = textIndex2StrIndex(endTextIndex);
			var startStr : String = _html.slice(0, startIndex);
			var bodyStr : String = _html.slice(startIndex, endIndex);
			var endStr : String = _html.slice(endIndex);
			return extractTagStr(startStr) + bodyStr + extractTagStr(endStr);
		}

		/**
		 * 把text索引還原成在原html串的索引
		 */
		private function textIndex2StrIndex(textIndex : int) : int
		{
			var strIndex : int = textIndex;
			for (var i : int = 0; i < _textIndexs.length; i++)
			{
				if (_textIndexs[i].index <= strIndex)
				{
					strIndex += _textIndexs[i].length;
				}
				else
				{
					break;
				}
			}

			return strIndex;
		}

		/**
		 * 提取一段html串中的tag
		 */
		private function extractTagStr(str : String) : String
		{
			var result : Array = str.match(_reg);
			if (result && result.length)
			{
				return result.join("");
			}
			return "";
		}

		public function get html() : String
		{
			return _html;
		}

		public function set html(html : String) : void
		{
			_html = html;
		}

		public function get text() : String
		{
			return _text;
		}
	}
}
