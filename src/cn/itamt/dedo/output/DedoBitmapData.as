package cn.itamt.dedo.output {

	/**
	 * 这是Dedo的最终位图数据,使用中以文件(.dbd)的形式预先由编辑器生成.
	 * 【注意】这个东东并不存储地图的tile,而是为了让Flash能够更快渲染出最终图形而设计出来的.它的每个字节直接存储颜色值.例如:[dedo_screen_width][dedo_screen_height][0xaa1133ff][0x3399ffaa]...
	 * @author itamt[at]qq.com
	 */
	public class DedoBitmapData {
		public function DedoBitmapData() : void {
		}
	}
}