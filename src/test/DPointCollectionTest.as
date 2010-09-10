package test {
	import asunit.framework.TestCase;

	import cn.itamt.dedo.data.DPoint;
	import cn.itamt.dedo.data.DPointCollection;

	import flash.system.System;

	/**
	 * @author itamt[at]qq.com
	 */
	public class DPointCollectionTest extends TestCase {

		public function DPointCollectionTest(testMethod : String = null) {
			super(testMethod);
		}

		protected override function setUp() : void {
		}

		protected override function tearDown() : void {
		}

		public function testUseMemory() : void {
			var nums : uint = 100000;
			
			var dcUseMemory : uint = System.totalMemory;
			new DPointCollection(nums);
			dcUseMemory = System.totalMemory - dcUseMemory;
			
			var ptsUseMemory : uint = System.totalMemory;
			var pts : Vector.<DPoint> = new Vector.<DPoint>();
			for(var i : int = 0;i < nums;i++) {
				pts.push(new DPoint());
			}
			ptsUseMemory = (System.totalMemory - ptsUseMemory);
			
			assertTrue("使用DPointCollection占用更少的内存", ptsUseMemory > dcUseMemory);
		}
	}
}
