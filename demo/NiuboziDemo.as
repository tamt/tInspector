package  
{
	import cn.itamt.display.tSprite;
	import cn.itamt.utils.Debug;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.engine.TextLine;
	import flash.text.engine.TextLineCreationResult;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.edit.EditManager;
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
		protected var _controller2:ContainerController;
		protected var _textFlow:TextFlow;
		protected var _textFlow2:TextFlow;
		protected var _fmt:TextLayoutFormat;
		protected var _fmt2:TextLayoutFormat;
		
		protected var _container:Sprite;
		protected var _container2:Sprite;

		public function NiuboziDemo() 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			super();
		}
		
		override protected function onAdded():void {
			
			_container = new Sprite();
			_container2 = new Sprite();
			addChild(_container);
			addChild(_container2);
			
			_controller = new ContainerController(_container, this.stage.stageWidth, this.stage.stageHeight);
			_controller2 = new ContainerController(_container2, this.stage.stageWidth, this.stage.stageHeight);
			
			_fmt = new TextLayoutFormat();
			_fmt.blockProgression = BlockProgression.RL;
			_fmt.textRotation = TextRotation.ROTATE_0;
			
			_textFlow = TextConverter.importToFlow(markup, TextConverter.PLAIN_TEXT_FORMAT);
			_textFlow.format = _fmt;
			_textFlow.flowComposer.addController(_controller);
			_textFlow.flowComposer.updateAllControllers();
			
			_fmt2 = new TextLayoutFormat();
			_fmt2.blockProgression = BlockProgression.RL;
			_fmt2.textRotation = TextRotation.ROTATE_180;
			_fmt2.baselineShift = -12;
			
			_textFlow2 = TextConverter.importToFlow(markup, TextConverter.PLAIN_TEXT_FORMAT);
			_textFlow2.format = _fmt2;
			_textFlow2.flowComposer.addController(_controller2);
			_textFlow2.flowComposer.updateAllControllers();
			
			this.stage.addEventListener(Event.RESIZE, onResizeStage);
			update();
		}
		
		override protected function onRemoved():void {
			this.stage.removeEventListener(Event.RESIZE, onResizeStage);
		}
		
		private function onResizeStage(e:Event):void 
		{
			_controller.setCompositionSize(this.stage.stageWidth, this.stage.stageHeight);
			_controller2.setCompositionSize(this.stage.stageWidth, this.stage.stageHeight);
			_textFlow.flowComposer.updateAllControllers();
			_textFlow2.flowComposer.updateAllControllers();
			
			update();
		}
		
		private function update():void {
			for (var i:int = 0; i < _container.numChildren; i++) {
				var textLine:TextLine;
				if (i % 2 == 0) {
					(_container.getChildAt(i) as TextLine).visible = true;
					(_container2.getChildAt(i) as TextLine).visible = false;
				}else {
					(_container.getChildAt(i) as TextLine).visible = false;
					(_container2.getChildAt(i) as TextLine).visible = true;
				}
				//textLine.textBlock.lineRotation = TextRotation.ROTATE_0;
			}
		}
		
	}

}