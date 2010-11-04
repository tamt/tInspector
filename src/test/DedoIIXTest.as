package test {
	import asunit.framework.TestSuite;

	/**
	 * @author itamt[at]qq.com
	 */
	public class DedoIIXTest extends TestSuite {
		public function DedoIIXTest() {
			super();

			addTest(new IIXParserTest("testIIXSetup"));
			// addTest(new IIXParserTest("testIIXProjectVersion"));// addTest(new IIXParserTest("testIIXProjectName"));// addTest(new IIXParserTest("testIIXProjectSize"));
		}
	}
}
