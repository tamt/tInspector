package cn.itamt.mxp {
	import cn.itamt.fx.WobbleEffect;
	import cn.itamt.utils.DisplayObjectTool;
	import cn.itamt.utils.inspector.ui.InspectorStageReference;

	import com.eclecticdesignstudio.motion.easing.Back;
	import com.eclecticdesignstudio.motion.easing.Cubic;
	import com.eclecticdesignstudio.motion.easing.Elastic;
	import com.eclecticdesignstudio.motion.easing.Expo;
	import com.eclecticdesignstudio.motion.easing.IEasing;
	import com.eclecticdesignstudio.motion.easing.Linear;
	import com.eclecticdesignstudio.motion.easing.Quad;
	import com.eclecticdesignstudio.motion.easing.Quart;
	import com.eclecticdesignstudio.motion.easing.Quint;
	import com.eclecticdesignstudio.motion.easing.Sine;

	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	
	use namespace tamt_mxp_internal;

	//组件图标
	[IconFile("genieeffector.png")]

	/**
	 * @author itamt[at]qq.com
	 */
	public class GenieEffector extends MovieClip {

		private static const STATS_NORMAL : String = "stats_normal";		private static const STATS_MINIZIE : String = "stats_minizie";

		//组件定义相关
		
		//组件显示框
		public var boundingBox_mc : MovieClip;

		protected var _targetName : String;
		private var _smooth : Boolean = true;

		[Inspectable(type="String")]

		/**
		 * 添加这个属性, 这样在ide中组件拖动到一个元件上时, 会自动为这个组件的_targetInstanceName进行设置.
		 */
		public function get _targetInstanceName() : String {
			return _targetName;
		}

		public function set _targetInstanceName(targetName : String) : void {
			try {
				this._targetName = targetName;
				target = parent.getChildByName(_targetName) as InteractiveObject;
				if(target == null) {
					throw new Error("targetInstance not found, or is not a InteractiveObject(Sprite, MovieClip, SimpleButton...)");
				}
			} catch (error : Error) {
				throw new Error("targetInstance not found, or is not a InteractiveObject(Sprite, MovieClip, SimpleButton...)");
			}
		}

		
		protected var _segmentsv : uint = 6;

		[Inspectable(defaultValue=6,type="Number")]

		public function set segmentsv(val : uint) : void {
			if(val > 0) {
				_segmentsv = val;
				if(_eff) {
					_eff.segmentsv = _segmentsv;
					_eff.dispose();
					_eff.apply();
				}
			}
		}

		public function get segmentsv() : uint {
			return _segmentsv;
		}

		
		protected var _segmentsh : uint = 6;

		[Inspectable(defaultValue=6,type="Number")]

		public function set segmentsh(val : uint) : void {
			if(val > 0) {
				_segmentsh = val;
				if(_eff) {
					_eff.segmentsh = _segmentsh;
					_eff.dispose();
					_eff.apply();
				}
			}
		}

		public function get segmentsh() : uint {
			return _segmentsh;
		}

		protected var _ease : String = "Back.easeOut";

		[Inspectable(defaultValue="Back.easeOut",type="String", enumeration="Back,Cubic,Elastic,Expo,Linear,Quad,Quart,Quint,Sine")]

		public function set ease(val : String) : void {
			_ease = val;
			
			var arr : Array = [Back.easeOut,Cubic.easeOut,Elastic.easeOut,Expo.easeOut,Linear.easeNone,Quad.easeOut,Quart.easeOut,Quint.easeOut,Sine.easeOut];
			var fun : IEasing = arr["Back,Cubic,Elastic,Expo,Linear,Quad,Quart,Quint,Sine".split(",").indexOf(val)];
			if(_eff) {
				_eff.ease = fun;
			}
		}

		public function get ease() : String {
			return _ease;
		}

		protected var _duration : Number = .6;

		[Inspectable(defaultValue=.6, type="Number")]

		public function set duration(val : Number) : void {
			_duration = val;
			if(_eff) {
				_eff.duration = _duration;
			}
		}

		public function get duration() : Number {
			return _duration;
		}

		[Inspectable(defaultValue=true, type="Boolean")]

		public function get smooth() : Boolean {
			return _smooth;
		}

		public function set smooth(smooth : Boolean) : void {
			_smooth = smooth;
			if(_eff) {
				_eff.smooth = smooth;
			}
		}

		protected var _grid : Boolean;

		[Inspectable(defaultValue=false, type="Boolean")]

		/**
		 * 是否显示格线
		 */
		public function set grid(val : Boolean) : void {
			_grid = val;
			if(_eff)_eff.grid = _grid;
		}

		public function get grid() : Boolean {
			return _grid;
		}

		protected var _dragTriggerName : String;

		[Inspectable(type="String")]

		//触发窗口拖动的对象名称
		public function set dragTriggerName(val : String) : void {
			if(val == "")val = null;
			_dragTriggerName = val;
			
			if(_dragTriggerName != null) {	
				if(_target) {
					var trigger : * = DisplayObjectTool.getChildByNameFrom(parent, val) as InteractiveObject;
					if(trigger)this.dragTrigger = trigger as InteractiveObject;
				}
			} else {
				if(_target)this.dragTrigger = this.target;
			}
		}

		public function get dragTriggerName() : String {
			return _dragTriggerName;
		}

		/**
		 * 触发最小化的对象
		 */
		protected var _minimizeTriggerName : String;

		[Inspectable(type="String")]

		public function set minimizeTriggerName(val : String) : void {
			if(val == "")val = null;
			this._minimizeTriggerName = val;
			
			if(_minimizeTriggerName != null) {	
				if(_target) {
					var trigger : * = DisplayObjectTool.getChildByNameFrom(parent, val) as InteractiveObject;
					if(trigger)this.miniTrigger = trigger as InteractiveObject;
				}
			} else {
				if(_target)this.miniTrigger = null;
			}
		}

		public function get minimizeTriggerName() : String {
			return _minimizeTriggerName;
		}

		/**
		 * 触发最大化的对象
		 */
		protected var _maximizeTriggerName : String;

		[Inspectable(type="String")]

		public function set maximizeTriggerName(val : String) : void {
			if(val == "")val = null;
			this._maximizeTriggerName = val;
			if(_maximizeTriggerName != null) {	
				if(_target) {
					var trigger : * = DisplayObjectTool.getChildByNameFrom(parent, val) as InteractiveObject;
					if(trigger)this.maxiTrigger = trigger as InteractiveObject;
				}
			} else {
				if(_target)this.maxiTrigger = null;
			}
		}

		public function get maximizeTriggerName() : String {
			return _maximizeTriggerName;
		}

		/**
		 * 用于初始化的一个参数
		 */
		[Inspectable(defaultValue="true", verbose=1,type="String", category="Other", enumeration="true")]

		public function set init(val : String) : void {
			//调用初初始化
			if(_target == null) {
			} else {
				if(_target.stage) {
					setupEffect();
				} else {
					_target.addEventListener(Event.ADDED_TO_STAGE, onTargetAdded);
				}
			}
		}

		/*
		protected var _autoSeg : Boolean;

		[Inspectable(defaultValue=false, type="Boolean")]

		public function get autoSeg() : Boolean {
		return _autoSeg;
		}

		public function set autoSeg(autoSeg : Boolean) : void {
		_autoSeg = autoSeg;
		}
		 * 
		 */

		/////////////////////////////////////////////////////		/////////////////////////////////////////////////////		/////////////////////////////////////////////////////

		protected var _target : InteractiveObject;

		public function set target(val : InteractiveObject) : void {
			_target = val;
		}

		public function get target() : InteractiveObject {
			return _target;
		}

		/**
		 * 拖动的触发源.
		 */
		protected var _dragTrigger : InteractiveObject;

		public function set dragTrigger(val : InteractiveObject) : void {
			if(dragTrigger) {
				dragTrigger.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				if(dragTrigger.stage)dragTrigger.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				dragTrigger.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			}
			
			_dragTrigger = val;
		}

		public function get dragTrigger() : InteractiveObject {
			return _dragTrigger;
		}

		/**
		 * 最小化的触发源.
		 */
		protected var _miniTrigger : InteractiveObject;

		public function set miniTrigger(val : InteractiveObject) : void {
			_miniTrigger = val;
		}

		public function get miniTrigger() : InteractiveObject {
			return _miniTrigger;
		}

		/**
		 * 最大化的触发源.
		 */
		protected var _maxiTrigger : InteractiveObject;

		public function set maxiTrigger(val : InteractiveObject) : void {
			_maxiTrigger = val;
		}

		public function get maxiTrigger() : InteractiveObject {
			return _maxiTrigger;
		}

		protected var _eff : WobbleEffect;

		/**
		 * 存储target位置/大小的rect
		 */
		protected var _targetRect : Rectangle;

		protected var _stats : String = STATS_NORMAL;

		protected var _dragProxy : Sprite;

		//////////////////////////////////////
		////////////constructor///////////////
		//////////////////////////////////////

		public function GenieEffector() {
			boundingBox_mc.visible = false;
			addChild(boundingBox_mc);
			boundingBox_mc = null;
			
			_dragProxy = new Sprite();
		}

		private function onTargetAdded(event : Event) : void {
			_target.removeEventListener(Event.ADDED_TO_STAGE, onTargetAdded);
			this.setupEffect();
		}

		private function setupEffect() : void {
			InspectorStageReference.referenceTo(_target.stage);
			
			this._dragProxy.x = _target.x;
			this._dragProxy.y = _target.y;
			
			_targetRect = _target.getRect(_target.stage);
			
			dragTrigger.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			dragTrigger.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			dragTrigger.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			if(miniTrigger) {
				miniTrigger.addEventListener(MouseEvent.CLICK, onClickMize);
			}
			
			if(maxiTrigger) {
				if(maxiTrigger != miniTrigger) {
					maxiTrigger.addEventListener(MouseEvent.CLICK, onClickMize);
				}
			}
		}

		private function onClickMize(event : MouseEvent) : void {
			if(event.target == miniTrigger) {
				if(miniTrigger == maxiTrigger) {
					if(_stats == STATS_MINIZIE) {
						this.maximize();
					} else {
						this.minimize();
					}
				} else {
					this.minimize();
				}
			}else if(event.target == maxiTrigger) {
				this.maximize();
			}
		}

		private function mouseUpHandler(evt : MouseEvent) : void {
			//			_target.stopDrag();
			if(_eff) {
				_eff.onUp(evt);
				onDraging();
				_dragProxy.removeEventListener(Event.ENTER_FRAME, onDraging);
				_dragProxy.stopDrag();
			
				_targetRect = _target.getRect(_target.stage);
			}
		}

		private function onDraging(evt : Event = null) : void {
			_target.x = _dragProxy.x;
			_target.y = _dragProxy.y;
		}

		private function mouseDownHandler(evt : MouseEvent) : void {
			_target.visible = false;

			var rect : Rectangle = InspectorStageReference.getStageBounds();
			//			_target.startDrag(false/*, new Rectangle(rect.left - evt.stageX, rect.top - evt.stageY, rect.width, rect.height)*/);
			_dragProxy.x = _target.x;
			_dragProxy.y = _target.y;
			_dragProxy.startDrag(false);
			_dragProxy.addEventListener(Event.ENTER_FRAME, onDraging);
			
			if(_eff) {
				_eff.dispose();
				_eff.removeEventListener(Event.COMPLETE, onEffComplete);
			}
			
			_eff = new WobbleEffect(_target);
			
			this.duration = this.duration;
			this.ease = this.ease;
			this.segmentsv = this.segmentsv;			this.segmentsh = this.segmentsh;
			this.grid = this.grid;
			this.smooth = this.smooth;
			
			_eff.apply();
			_eff.addEventListener(Event.COMPLETE, onEffComplete);
			
			_eff.onDown(evt);
		}

		private function onEffComplete(event : Event) : void {
			if(_stats == STATS_NORMAL) {
				_target.visible = true;
			}else if(_stats == STATS_MINIZIE) {
				_target.visible = false;
			}
			_eff.visible = false;
//			_eff.dispose();
//			_eff.removeEventListener(Event.COMPLETE, onEffComplete);
//			_eff = null;
		}

		public function setSize(w : Number, h : Number) : void {
			var tf : TextField = new TextField();
			tf.text = w + "," + h;
			this.addChild(tf);
		}

		public function minimize() : void {
			if(_stats == STATS_MINIZIE)return;
			
			_target.visible = false;
			_stats = STATS_MINIZIE;
			
			var targetRect : Rectangle;
			if(this.maxiTrigger) {
				targetRect = this.maxiTrigger.getRect(this._target.stage);
			}else if(this.miniTrigger) {
				targetRect = this.miniTrigger.getRect(this._target.stage);
			}
			
			if(_eff) {
				_eff.resize(targetRect);
			} else {
				_eff = new WobbleEffect(_target);
			
				this.duration = this.duration;
				this.ease = this.ease;
				this.segmentsv = this.segmentsv;				this.segmentsh = this.segmentsh;
				this.grid = this.grid;
			
				_eff.apply();
				_eff.addEventListener(Event.COMPLETE, onEffComplete);
				
				_eff.resize(targetRect);
			}
			_eff.visible = true;
		}

		public function maximize() : void {
			if(_stats == STATS_NORMAL)return;
			
			_stats = STATS_NORMAL;
			
			if(_eff) {
				if(_eff.moving)return;
				_eff.resize(this._targetRect);
			} else {
				_eff = new WobbleEffect(_target);
			
				this.duration = this.duration;
				this.ease = this.ease;
				this.segmentsh = this.segmentsh;				this.segmentsv = this.segmentsv;
				this.grid = this.grid;
			
				_eff.apply();
				_eff.addEventListener(Event.COMPLETE, onEffComplete);
				
				_eff.resize(this._targetRect);
			}
			_eff.visible = true;
		}

		public function get isLivePreview() : Boolean {
			return (parent != null && getQualifiedClassName(parent) == "fl.livepreview::LivePreviewParent");
		}
	}
}
