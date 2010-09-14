package cn.itamt.dedo.parser {
	import cn.itamt.dedo.data.DBrushesCollection;
	import cn.itamt.dedo.data.DMapsCollection;
	import cn.itamt.dedo.data.DTileCategoriesCollection;
	import cn.itamt.dedo.data.DTilesCollection;

	/**
	 * @author itamt[at]qq.com
	 */
	public interface IDedoParser {
		function parse(data : *, onComplete : Function = null) : Boolean;

		function getProjectName() : String;

		function getProjectVersion() : String;

		function getProjectCellWidth() : uint;

		function getProjectCellHeight() : uint;

		function getTiles() : DTilesCollection;

		function getTileCategories() : DTileCategoriesCollection;

		function getMaps() : DMapsCollection;

		function getBrushes() : DBrushesCollection;

		function getAnimations() : XML;
	}
}
