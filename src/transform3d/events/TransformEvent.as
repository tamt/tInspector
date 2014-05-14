package transform3d.events 
{
	import flash.events.Event;
	
	/**
	 * events
	 * @author tamt
	 */
	public class TransformEvent extends Event
	{
		public static const UPDATE:String = "transform_3d_tool_update";
		public static const REGISTRATION:String = "transform_3d_tool_registration_update";
		
		public function TransformEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
	}

}
