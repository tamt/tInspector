package cn.itamt.utils.inspector.firefox {
	import flash.external.ExternalInterface;

	public function alert(msg : String):void {
		if(ExternalInterface.available) {
			ExternalInterface.call("alert", "[swf]" + msg);
		}
	}
}