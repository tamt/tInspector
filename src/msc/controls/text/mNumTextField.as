package msc.controls.text {
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextField;

	/**
	 * 数字框
	 * @author itamt@qq.com
	 */
	public class mNumTextField extends TextField {
		//是否已经被初始化
		protected var _inited : Boolean;

		//闪烁持续时间（帧数）
		public var alarmRemain : uint;
		//是否在输入值超出范围时闪烁边框
		public var showAlarmWhenOverFlow : Boolean = true;

		public function mNumTextField() {
			addEventListener(Event.ADDED_TO_STAGE, onAdded, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved, false, 0, true);
			
			//限制使只能输入数字
			this.restrict = '-.0-9';
		}

		private function onAdded(evt : Event) : void {
			if(_inited)return;
			_inited = true;
			init();
		}

		private function onRemoved(evt : Event) : void {
			_inited = false;
			destroy();
		}

		private var _max : Number = Infinity;
		private var _min : Number = -Infinity;

		public function set maxNum(value : Number) : void {
			if(!isNaN(value)) {
				_max = value;
			} else {
				_max = 0;
			}
		}

		public function get maxNum() : Number {
			return _max;
		}

		public function set minNum(value : Number) : void {
			if(!isNaN(value)) {
				_min = value;
			} else {
				_min = 0;
			}
		}

		public function get minNum() : Number {
			return _min;
		}

		protected function init() : void {
			this.addEventListener(TextEvent.TEXT_INPUT, onInput, false, 0, true);			this.addEventListener(Event.CHANGE, onChange, false, 0, true);
		}

		private function onChange(evt : Event) : void {
			if(!this.text.length) {
				evt.preventDefault();
				evt.stopImmediatePropagation();
			}
		}

		private function onInput(evt : TextEvent) : void {
			var cur : Number = Number(this.text + evt.text);
			if(cur < _min) {
				alarm();
				evt.preventDefault();
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, true, true, '小于最小值'));
			}else if(cur > _max) {
				alarm();
				evt.preventDefault();
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, true, true, '大于最大值'));
			}
		}

		/**
		 * alarm~alarm~想起“盟军敢死队” -_-|||
		 * 
		 * 当用户输入值超出取值范围时，显示警告（闪烁边框）。
		 */
		private function alarm() : void {
			if(!alarmRemain) {
				var oBorder : Boolean = this.border;
				var oColor : uint = this.borderColor;
				border = true;
				if(!oBorder)borderColor = 0xff0000;
				addEventListener(Event.ENTER_FRAME, function(evt : Event) : void {
					border = !border;
					if (--alarmRemain <= 0) {
						border = oBorder;
						borderColor = oColor;
						removeEventListener(Event.ENTER_FRAME, arguments.callee);
					}
				});
			}
			alarmRemain = 6;
		}

		/**
		 * 销毁
		 */
		protected function destroy() : void {
			this.removeEventListener(TextEvent.TEXT_INPUT, onInput);
			this.removeEventListener(Event.CHANGE, onChange);
		}
	}
}
