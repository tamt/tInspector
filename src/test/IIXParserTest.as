package test {
	import asunit.framework.TestCase;

	import cn.itamt.dedo.parser.IIXParser;

	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	/**
	 * @author itamt[at]qq.com
	 */
	public class IIXParserTest extends TestCase {
		private var iix : ByteArray;
		private var parser : IIXParser;

		public function IIXParserTest(testMethod : String = null, iix : ByteArray = null) {
			super(testMethod);

			this.iix = iix;
		}

		override protected function setUp():void {
			if(this.iix == null) {
				this.callAfterLoadIIX(setUp);
			} else {
				if(parser == null) {
					parser = new IIXParser();
					parser.parse(this.iix);
				}
			}
		}

		public function testIIXSetup():void {
			this.setUp();
		}

		public function testIIXProjectVersion():void {
			if(this.parser == null) {
				this.callAfterLoadIIX(testIIXProjectVersion);
			} else {
				assertEqualsArrays(["4.0"], [this.parser.getProjectVersion()]);
			}
		}

		public function testIIXProjectName():void {
			if(this.parser == null) {
				this.callAfterLoadIIX(testIIXProjectName);
			} else {
				assertEqualsArrays(["nDedo"], [this.parser.getProjectName()]);
			}
		}

		public function testIIXProjectSize():void {
			if(this.parser == null) {
				this.callAfterLoadIIX(testIIXProjectSize);
			} else {
				assertEqualsArrays([32], [this.parser.getProjectCellWidth()]);
				// assertEqualsArrays([32, 32], [this.parser.getProjectCellWidth(), this.parser.getProjectCellHeight()]);
			}
		}

		private function callAfterLoadIIX(fun : Function):void {
			var loader : URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.load(new URLRequest("nDedo.iix"));
			loader.addEventListener(Event.COMPLETE, function(event : Event):void {
				iix = (event.target as URLLoader).data as ByteArray;
				setUp();
				fun.call();
			});
		}
	}
}
