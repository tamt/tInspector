package cn.itamt.utils.inspector.core.inspectfilter {
	import cn.itamt.utils.inspector.core.IInspectorPlugin;
	import flash.display.DisplayObject;
	/**
	 * @author tamt
	 */
	public interface IInspectorFilterManager extends IInspectorPlugin{
		function applyFilter(filter:Class):void;
		function killFilter(filter:Class):void;
		function checkInFilter(target:DisplayObject):Boolean;
		function isFilterActiving(filter:Class):Boolean;
	}
}
