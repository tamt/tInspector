package msc.revision {
	import flash.utils.Dictionary;

	/**
	 * 文本版本数据
	 * @author itamt[at]qq.com
	 */
	public class mRevisionData {
		protected var fileRevDict : Dictionary;
		protected var revFileDict : Dictionary;

		protected var rootPath : String;
		protected var compressedStr : String;

		public function mRevisionData() : void {
			fileRevDict = new Dictionary(true);
			revFileDict = new Dictionary(true);
		}

		/**
		 * 设置revison.xml的压缩后的字符串，格式如下：
		 * 
		 * 版本号|目录|文件名1,文件名2,...
		 * 
		 * 例如：
		 * 2194|images/door|2.swf,3.swf,1.swf
		 * 2193|images/cityWar|2.swf,3.swf,1.swf
		 */
		public function setRevCompressedStr(str : String) : void {
			this.compressedStr = str;
			
			//			Debug.trace('[mRevisionData][setRevCompressedStr]' + str);
			var arr : Array = str.split('\n');
			var i : int = arr.length;
			while(i--) {
				if(arr[i].length) {
					var itemStr : Array = arr[i].split('|');
					var r : int = int(itemStr[0]);
					var p : String = itemStr[1];
					//补全路径后的"/"
					if(p.length)if(p.substr(-1) != "/")p += "/";
					
					if(rootPath != null) {
						if(rootPath.length) {
							var boolR : Boolean = (rootPath.substr(-1) == "/");
							var boolP : Boolean = (p.substr(0, 1) == "/");
							if(boolP && boolR) {
								p = rootPath.slice(0, -1) + p;
							}else if(boolP != boolR) {
								p = rootPath + p;
							} else {
								p = rootPath + '/' + p;
							}
						}
					}
					
					var fs : Array = itemStr[2].split(',');
					var j : int = fs.length;
					while(j--) {
						if(fs[j].length) {
							fileRevDict[p + fs[j]] = r;
							revFileDict[r] = p + fs[j];
							
//							Debug.trace(r + "::" + (p + fs[j]));
						}
					}
				}
			}
			
//			Debug.trace('========================================');
		}

		/**
		 * 设置根路径
		 */
		public function setRootPath(path : String = null) : void {
			if(path != null) {
				rootPath = path;
				
				if(compressedStr != null) {
					fileRevDict = new Dictionary(true);
					revFileDict = new Dictionary(true);
					
					this.setRevCompressedStr(this.compressedStr);
				}
			}
		}

		/**
		 * 得到一个文件的版本
		 */
		public function getFileRevision(fileUrl : String = null) : int {
			if(fileUrl == null)return 0;
			return fileRevDict[fileUrl];
		}
	}
}
