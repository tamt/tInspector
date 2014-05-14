package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;

	import msc.controls.text.mCmdTextInput;
	import msc.events.mTextEvent;

	import flash.display.Shape;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.text.TextFormat;

	/**
	 * @author itamt[at]qq.com
	 */
	public class InspectSearchBar extends mCmdTextInput {
		protected var icon : Shape;

		public function InspectSearchBar() {
			super();
		
			this.mouseEnabled = false;
		}

		override protected function init() : void {
			super.init();
			
			icon = new Shape();
			drawIcon();
			addChild(icon);
			
			drawBg();
			
			clearWhenEnter = true;
			
			var tfm : TextFormat = new TextFormat();
			tfm.font = 'Verdana';
			tfm.leftMargin = tfm.rightMargin = 3;
			
			this._tf.textColor = 0xffffff;
			this._tf.border = false;
			this._tf.defaultTextFormat = tfm;
			
			tfm.size = 10;
			this._matchText.border = false;
			this._matchText.textColor = 0x99cc00;
			this._matchText.background = true;
			//			this._matchText.backgroundColor = InspectorColorStyle.DEFAULT_BG;
			this._matchText.backgroundColor = 0;
			this._matchText.alpha = 1;
			//			this._matchText.mouseEnabled = true;
			this._matchText.defaultTextFormat = tfm;
			this._matchText.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
		}

		override protected function setMatchText(matchArr : Array = null) : void {
			_matchText.text = '';
			if(matchArr) {
				for each(var match:String in matchArr) {
					_matchText.appendText(match + '\n');
				}
				
				if(matchArr.length > 0) {
					var t : int = _matchText.length;
					_matchText.appendText("\n" + InspectorLanguageManager.getStr("SearchBtnHelp"));
					var tfm : TextFormat = new TextFormat(null, null, 0xcccccc);
					tfm.leading = 5;
					_matchText.setTextFormat(tfm, t, _matchText.length);
				}
			}
			
			this.relayout();
		}

		override protected function selectMatchWord(index : int) : void {
			var word : String = _matchArr[index];
			var beginIndex : int = _matchText.text.search(new RegExp('\\b' + word + '\\b'));
			_matchText.setTextFormat(new TextFormat(null, null, null, false, null, false));
			_matchText.setTextFormat(new TextFormat(null, null, null, false, null, true), beginIndex, beginIndex + word.length);
			
			dispatchEvent(new mTextEvent(mTextEvent.SELECT, word));
		}

		override public function relayout() : void {
			if(!_inited)return;
			
			drawBg();
			
			this._tf.x = icon.x + icon.width + 5;
			this._tf.height = _h;
			this._tf.width = _w - icon.width - icon.x - 5;
			
			if(this._matchText) {
				this._matchText.y = this._tf.y - this._matchText.height - 5;
			}
		}

		//////////////////////////////////////
		//////////private functions///////////
		//////////////////////////////////////
		private function drawIcon() : void {
			with(icon) {
				graphics.clear();
				// Fills:
				graphics.lineStyle();
				graphics.beginFill(0x282828);
				graphics.moveTo(16.000000, 0.000000);
				graphics.curveTo(21.000000, 0.000000, 21.000000, 5.000000);
				graphics.lineTo(21.000000, 16.000000);
				graphics.curveTo(21.000000, 21.000000, 16.000000, 21.000000);
				graphics.lineTo(5.000000, 21.000000);
				graphics.curveTo(0.000000, 21.000000, 0.000000, 16.000000);
				graphics.lineTo(0.000000, 5.000000);
				graphics.curveTo(0.000000, 0.000000, 5.000000, 0.000000);
				graphics.lineTo(16.000000, 0.000000);
				graphics.endFill();
				// Lines:
				graphics.lineStyle(3.000000, 0xffffff);
				graphics.moveTo(16.400000, 16.600000);
				graphics.lineTo(11.650000, 11.850000);
				graphics.lineTo(11.650000, 11.900000);
				graphics.curveTo(10.450000, 13.000000, 8.750000, 13.000000);
				graphics.curveTo(7.100000, 13.000000, 5.850000, 11.750000);
				graphics.curveTo(4.650000, 10.550000, 4.650000, 8.850000);
				graphics.curveTo(4.650000, 7.100000, 5.850000, 5.950000);
				graphics.curveTo(7.100000, 4.650000, 8.750000, 4.650000);
				graphics.curveTo(10.500000, 4.650000, 11.750000, 5.950000);
				graphics.curveTo(13.000000, 7.100000, 13.000000, 8.850000);
				graphics.curveTo(13.000000, 10.550000, 11.750000, 11.750000);
				graphics.lineTo(11.650000, 11.850000);
				graphics.lineTo(10.650000, 10.800000);
			}
			icon.y = -1.5;
		}

		private function drawBg() : void {
			graphics.clear();
			graphics.lineStyle(4.000000, 0x282828);
			graphics.beginGradientFill('linear', [0x82a001,0x667e01], [1,1], [0,255], new Matrix(0, 0, 0, 0, 100, 0));
			graphics.drawRoundRect(icon.width + 5, 0, _w - icon.width, _h, 5);
			graphics.endFill();
		}

		public function getWordDict() : String {
			return _dictionary;	
		}

		public function setWordDict(dict : String) : void {
			_dictionary = dict;
		}
	}
}
