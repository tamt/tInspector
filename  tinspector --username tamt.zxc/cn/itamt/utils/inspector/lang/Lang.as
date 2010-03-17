package cn.itamt.utils.inspector.lang {

	/**
	 * 为方便以后语言文件做成外部载入的, 语言格式使用纯字符(而不是xml格式).
	 * @author itamt@qq.com
	 */
	public class Lang {
		/**
		 * 语言xml格式:
			<lang>
				<![CDATA[
					LiveRotate		=	拖動 旋轉
					LiveScale		=	拖動縮放
					SubmmitBug		=	提交bug
					InspectChild	=	查看自顯示對象
					Refresh			=	刷新
					Property		=	屬性
					ViewProperties	=	查看對象的屬性
					ViewMethods		=	查看對象的方法
				]]>
			</lang>;
		 */
		public var file : XML;

		protected var _data : Object;
		protected var _builded : Boolean;

		protected function build() : void {
			_data = {};
			
			var str : String = file.toString();
			var rExp : RegExp = new RegExp("\\b\\S*\\s*=\\s*.*\\s", "g");
			var matches : Array = str.match(rExp);
			var item : String;
			for(var i : int = 0;i < matches.length;i++) {
				item = matches[i];
				var prop : String = trim(item.slice(0, item.indexOf("=")));
				var value : String = trim(item.slice(item.indexOf("=") + 1));
				_data[prop] = value;
			}
		}

		public function getTipValueString(tipStr : String) : String {
			if(!_builded)this.build();
			return String(_data[tipStr]);
		}

		private function trim(source : String, removeChars : String = ' \n\t\r') : String {
			var pattern : RegExp = new RegExp('^[' + removeChars + ']+|[' + removeChars + ']+$', 'g');
			return source.replace(pattern, '');
		}
	}
}
