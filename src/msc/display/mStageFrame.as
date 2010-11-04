package msc.display {
	import flash.display.Stage;
	import flash.events.Event;

	/**
	 * @author tamt
	 */
	public class mStageFrame extends mSprite {
		private var _ow : int;
		private var _oh : int;

		private var _stage : Stage;

		public function mStageFrame(stage : Stage) {
			_stage = stage;
			_ow = _stage.stageWidth;
			_oh = _stage.stageHeight;
		}

		override protected function init() : void {
			drawFrame();
			
			_stage.addEventListener(Event.RESIZE, onStageResize);
			_stage.addEventListener(Event.ADDED_TO_STAGE, onSthAdded);
		}

		override protected function destroy() : void {
			this.graphics.clear();
			
			_stage.removeEventListener(Event.RESIZE, onStageResize);
			_stage.removeEventListener(Event.ADDED_TO_STAGE, onSthAdded);
		}

		private function onSthAdded(evt : Event) : void {
			if(evt.target != this) {
				if(_stage.getChildIndex(this) != _stage.numChildren - 1) {
					_stage.setChildIndex(this, _stage.numChildren - 1);
				}
			}
		}

		private function onStageResize(evt : Event) : void {
			drawFrame();
		}

		private function drawFrame() : void {
			this.graphics.clear();
			this.graphics.beginFill(0x0);
			this.graphics.drawRect((_ow - _stage.stageWidth) / 2, (_oh - _stage.stageHeight) / 2, _stage.stageWidth, _stage.stageHeight);			this.graphics.drawRect(0, 0, _ow, _oh);
			this.graphics.endFill();
		}
	}
}
