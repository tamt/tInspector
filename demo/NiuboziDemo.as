package  
{
	import cn.itamt.display.NiuboziTextField;
	import cn.itamt.display.tSprite;

	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class NiuboziDemo extends tSprite
	{
		static private const markup:String = "Mozilla（应该是在上周）修改了关于附加组件的策略，Flash Inspector所有未审核过的版本全部被禁用了。Flash Inspector 0.1.7是Mozilla唯一审核过的一个版本。坦白讲这挺挫伤对Flash Inspector开发的积极性，因为Flash Inspector被审核很难通过，而一个不为人知不为人用的东西，做了有虾米意义呢？";
		
		private var nb_tf:NiuboziTextField;

		public function NiuboziDemo() 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			super();
		}
		
		override protected function onAdded():void {
			nb_tf = new NiuboziTextField(this.stage.stageWidth, this.stage.stageHeight);
			nb_tf.text = markup;
			addChild(nb_tf);
			
			this.stage.addEventListener(Event.RESIZE, onResizeStage);
		}
		
		override protected function onRemoved():void {
			this.stage.removeEventListener(Event.RESIZE, onResizeStage);
		}
	
		private function onResizeStage(event : Event) : void {
			nb_tf.setSize(this.stage.stageWidth, this.stage.stageHeight);
		}
		
	}

}