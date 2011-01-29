package  
{
	import cn.itamt.utils.Debug;
	import flash.display.Sprite;
	import fl.controls.Button;
	import flash.events.Event;
	import flash.events.ErrorEvent;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class DebugErrorMessageDemo extends Sprite 
	{
		
		public var error_btn:Button;
		public var debug_tf:TextField;
		
		public function DebugErrorMessageDemo() 
		{
			
			this.stage.scaleMode = "noScale";
			this.stage.align = "TL";
			
			//点击按钮时触发一个错误.
			error_btn.addEventListener(MouseEvent.CLICK, onClickError);
			
			//侦听全局异常.
			if (this.root.loaderInfo.hasOwnProperty("uncaughtErrorEvents")) {
				Debug.trace("has uncaughtErrorEvents");
				//IEventDispatcher(this.stage.loaderInfo["uncaughtErrorEvents"]).addEventListener("uncaughtError", uncaughtErrorHandler);
				IEventDispatcher(this.loaderInfo["uncaughtErrorEvents"]).addEventListener("uncaughtError", uncaughtErrorHandler);
				//IEventDispatcher(this.loaderInfo["uncaughtErrorEvents"]).addEventListener("uncaughtError", uncaughtErrorHandler);
			}
		}

		function onClickError(evt:MouseEvent):void {
			//触发一个错误
			trace(this["undefinedParameter"]);
		}
		
		function uncaughtErrorHandler(evt:ErrorEvent):void {
			//取消默认的错误弹框
			evt.preventDefault();
			
			//输出错误信息
			debug_tf.appendText(evt["error"].getStackTrace() + "\n===================\n");
		}
		
	}

}