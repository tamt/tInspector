package  
{
	import cn.itamt.display.tSprite;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.engine.TextLine;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.BlockProgression;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flash.text.engine.TextRotation;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class NiuboziDemo extends tSprite
	{
		static private const markup:String = "Mozilla（应该是在上周）修改了关于附加组件的策略，Flash Inspector所有未审核过的版本全部被禁用了。Flash Inspector 0.1.7是Mozilla唯一审核过的一个版本。坦白讲这挺挫伤对Flash Inspector开发的积极性，因为Flash Inspector被审核很难通过，而一个不为人知不为人用的东西，做了有虾米意义呢？";
		
		protected var _controller:ContainerController;
		protected var _textFlow:TextFlow;
		protected var _fmt:TextLayoutFormat;

		public function NiuboziDemo() 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			super();
		}
		
		override protected function onAdded():void {
			
			_controller = new ContainerController(this, this.stage.stageWidth, this.stage.stageHeight);
			
			_fmt = new TextLayoutFormat();
			_fmt.fontSize = 28;
			_fmt.fontFamily = "微软雅黑"
			_fmt.blockProgression = BlockProgression.RL;
			_fmt.textRotation = TextRotation.ROTATE_0;
			
			_textFlow = TextConverter.importToFlow(markup, TextConverter.PLAIN_TEXT_FORMAT);
			_textFlow.format = _fmt;
			_textFlow.flowComposer.addController(_controller);
			_textFlow.flowComposer.updateAllControllers();
			
			this.stage.addEventListener(Event.RESIZE, onResizeStage);
			
			update();
		}
		
		override protected function onRemoved():void {
			this.stage.removeEventListener(Event.RESIZE, onResizeStage);
		}
				
		private function onResizeStage(e:Event):void 
		{
			_controller.setCompositionSize(this.stage.stageWidth - 10, this.stage.stageHeight - 10);
			_textFlow.flowComposer.updateAllControllers();
			
			update();
		}
		
		private function update():void {
			for (var i:int = 0; i < this.numChildren; i++) {
				var textLine:TextLine = this.getChildAt(i) as TextLine;
				if (i % 2 == 1) {
					textLine.rotation = 180;
					textLine.y = textLine.height;
					textLine.x += _fmt.fontSize - .3*_fmt.fontSize;
				}
			}
		}
		
	}

}