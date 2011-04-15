package cn.itamt.display {
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.BlockProgression;
	import flashx.textLayout.formats.TextLayoutFormat;

	import flash.text.engine.TextLine;
	import flash.text.engine.TextRotation;

	/**
	 * 扭脖子文本框
	 * @playerversion 10.0
	 * @version	0.1
	 * @author tamt
	 */
	public class NiuboziTextField extends tSprite
	{

		protected var _controller:ContainerController;
		protected var _textFlow:TextFlow;
		protected var _fmt:TextLayoutFormat;

		private var _text:String;
		private var _width:Number;
		private var _height:Number;

		public function NiuboziTextField(w:Number, h:Number)
		{
			this._width = w;
			this._height = h;
			
			_controller=new ContainerController(this, w, h);

			_fmt=new TextLayoutFormat();
			_fmt.fontSize=28;
			_fmt.fontFamily="微软雅黑";
			_fmt.blockProgression=BlockProgression.RL;
			_fmt.textRotation=TextRotation.ROTATE_0;
		}

		override protected function onAdded():void
		{
			super.onAdded();

			if (_text)
			{
				this.text=_text;
			}
		}

		/**
		 * 设置宽度高度
		 */
		public function setSize(w:Number, h:Number):void
		{
			_width = w;
			_height = h;
			
			if(_inited){
				_controller.setCompositionSize(w, h);
				_textFlow.flowComposer.updateAllControllers();
	
				update();
			}
		}
		
		override public function set width(value:Number):void{
			this.setSize(value, _height);
		}
		
		override public function set height(value:Number):void{
			this.setSize(_width, value);
		}

		/**
		 * 设置文本值
		 */
		public function set text(val:String):void
		{
			_text=val;

			if (_inited)
			{
				if (_textFlow)
				{
					_textFlow.flowComposer.removeAllControllers();
				}

				_textFlow=TextConverter.importToFlow(_text, TextConverter.PLAIN_TEXT_FORMAT);
				_textFlow.format=_fmt;
				_textFlow.flowComposer.addController(_controller);
				_textFlow.flowComposer.updateAllControllers();
				
				update();
			}
		}

		public function get text():String
		{
			return _text;
		}

		private function update():void
		{
			for (var i:int=0; i < this.numChildren; i++)
			{
				var textLine:TextLine=this.getChildAt(i) as TextLine;
				if (i % 2 == 1)
				{
					textLine.rotation=180;
					textLine.y=_controller.compositionHeight;// - textLine.height;
					textLine.x+=_fmt.fontSize - .3 * _fmt.fontSize;
				}
			}
		}

	}
}