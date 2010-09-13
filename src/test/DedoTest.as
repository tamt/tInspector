package test {
	import asunit.framework.TestSuite;

	/**
	 * @author itamt[at]qq.com
	 */
	public class DedoTest extends TestSuite {
		public function DedoTest() {
			super();
			
			addTest(new DPointCollectionTest("testUseMemory"));			addTest(new TileMapperParserTest("testTilesWithSampleXML"));			addTest(new TileMapperParserTest("testParseNameWithSampleXML"));			addTest(new TileMapperParserTest("testMapsWithSampleXML"));			addTest(new TileMapperParserTest("testMapLayersWithSampleXML"));
		}
	}
}
