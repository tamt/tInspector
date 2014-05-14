package transform3d.controls 
{
	
	import transform3d.cursors.CustomMouseCursor;
	import transform3d.consts.Transform3DMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author tamt
	 */
	public class DimentionControl2D extends Control2D implements IDimentionControl
	{
		//display valule text
		public var showValue:Boolean;
		
		//value of this control
		protected var _value:Number = 0;
		public function get value():Number {
			return _value;
		}
		
		//is mouse on this control?
		protected var _isOnMouse:Boolean = false;
		//textfile for showing the value of this control
		protected var _textfield:TextField;
		//mouse cursor of this control
		protected var _cursor:DisplayObject;
		//store mouse position
		protected var _mousePoint:Point;
		protected var _mousePoint3D:Point;
		protected var _globalMousePoint:Point;
		//store mouse position at when start drag
		protected var _startDragPoint:Point;
		//store mouse position at when start drag in 3D coordinates
		protected var _startDragPoint3D:Point;
		//store mouse position at when stop drag
		protected var _stopDragPoint:Point;
		//is control draged current?
		protected var _draging:Boolean;
		//is control actived curren
		protected var _actived:Boolean;
		/**
		 * is control actived current.
		 */
		public function get actived():Boolean {
			return _actived;
		}
		
		//control graphics container
		protected var _sp:Shape;
		/**
		 * control graphics container
		 */
		public function get shape():DisplayObject {
			return _sp;
		}
		
		protected var _style:Style;
		public function get style():Style {
			return _style;
		}
		/**
		 * the style use in control graphics drawing
		 */
		public function set style(val:Style):void{
			_style = val;
			//redraw control graphics if it is inited(displayed)
			if (_inited) this.draw();
		}
		
		/**
		 * transform mode of control
		 */
		protected var _mode:uint;
		public function get mode():uint {
			return _mode;
		}
		public function set mode(val:uint):void {
			if (Transform3DMode.isInvalidMode(val)) return;
			
			_mode = val;
			
			if (_inited) {
				//update control graphics
				clear();
				draw();
			}
		}
		
		/**
		 * control's skin
		 */
		protected var _skin:DisplayObject;
		public function get skin():DisplayObject {
			return _skin;
		}
		public function set skin(val:DisplayObject):void {
			if (_skin) {
				//if has skin already, clear skin listeners first
				clearListenersToSkin();
			}
			_skin = val;
			if (_skin) {
				//build listeners on skin
				buildListenersToSkin();
			}
		}
		
		//-------------------------
		//--------constructor------
		//-------------------------
		public function DimentionControl2D() 
		{
			_style = new Style(0x0000ff, .5, 0, 1, 1);
		}
		
		//-------------------------
		//-----basic functions-----
		//-------------------------
		
		override protected function onAdded(e:Event = null):void 
		{	
			super.onAdded(e);
			
			//control Shape
			if (_sp == null) {
				_sp = new Shape();
				this.addChild(_sp);
			}
			
			if (_textfield == null) {
				//create TextField to display value
				_textfield = new TextField();
				_textfield.autoSize = "left";
				_textfield.mouseEnabled = _textfield.mouseWheelEnabled = _textfield.visible = false;
			}
			
			//addChild(_textfield);
			
			//listen mouse event.
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//listen mouse event on Stage.
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onOtherMouseUp);
			
			//act as "roll over" when mouse hit this control
			if (this.hitTestPoint(this.stage.mouseX, this.stage.mouseY, true)) {
				this.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
			}
			
			//if has skin, build listeners on skin.
			if (_skin) this.buildListenersToSkin();
			
			//store current mouse point
			_mousePoint = new Point(mouseX, mouseY);
			_mousePoint3D = _mousePoint.clone();
			_globalMousePoint = new Point(stage.mouseX, stage.mouseY);
			
			//draw graphics in this control
			this.draw();
		}
		
		override protected function onRemoved(e:Event = null):void {
			this.clear();
			
			_mousePoint = null;
			_mousePoint3D = null;
			_globalMousePoint = null;
			_startDragPoint = null;
			_startDragPoint3D = null;
			_stopDragPoint = null;
			
			this.removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);			
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			if (this.stage) {
				this.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				this.stage.removeEventListener(MouseEvent.MOUSE_UP, onOtherMouseUp);
			}
			
			if (_skin) this.clearListenersToSkin();
			
			super.onRemoved(e);
		}

		override public function dispose():void {
			onRemoved();
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			
			_cursor = null;
			
			super.dispose();
		}
		
		//----------------------------
		//------private functions-----
		//----------------------------
		private function onMouseDown(evt:MouseEvent):void {
			//start listen mouse event on stage
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			//sotre current position of mouse
			this._mousePoint.x = this.mouseX;
			this._mousePoint.y = this.mouseY;
			this._mousePoint3D = _mousePoint.clone();
			this._globalMousePoint.x = this.stage.mouseX;
			this._globalMousePoint.y = this.stage.mouseY;
			
			//mark draging true
			this._draging = true;
			//store start drag point
			this._startDragPoint = this._mousePoint.clone();
			this._startDragPoint3D = this._mousePoint3D.clone();
			
			//lock mouse cursor
			if (CustomMouseCursor.cursor == _cursor) {
				CustomMouseCursor.lock();
			}
			
			//mark control active
			_actived = true;
			
			//call start drag
			this.onStartDrag();
			
			//dispatch control active
			this.dispatchEvent(new Event(Event.ACTIVATE, true));
		}
		
		/**
		 * on mouse up on Stage
		 * @param	evt
		 */
		private function onMouseUp(evt:MouseEvent):void {
			//clear listeners of mouse event on Stage
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			//store the current position of mouse
			this._mousePoint.x = this.mouseX;
			this._mousePoint.y = this.mouseY;
			this._mousePoint3D = _mousePoint.clone();
			this._globalMousePoint.x = this.stage.mouseX;
			this._globalMousePoint.y = this.stage.mouseY;
			
			//mark draging false
			this._draging = false;
			//store stop drag point
			this._stopDragPoint = this._mousePoint.clone();
			
			//clear mouse cursor
			if (!this._isOnMouse && CustomMouseCursor.cursor == _cursor) {
				CustomMouseCursor.unlock();
				CustomMouseCursor.clear();
			}
			
			//show mouse cursor
			if (this._isOnMouse) {
				CustomMouseCursor.show(_cursor);
			}
			
			//mark control inactive
			_actived = false;
			
			//call stop drag function
			this.onStopDrag();
			
			//dispatch control deactive event.
			this.dispatchEvent(new Event(Event.DEACTIVATE, true));
		}
		
		/**
		 * on mouse up on Stage
		 * @param	evt
		 */
		private function onOtherMouseUp(evt:MouseEvent):void {
			if (evt.target == this) return;
			if (this._isOnMouse) {
				if (_cursor && !_draging) {
					CustomMouseCursor.unlock();
					CustomMouseCursor.show(_cursor);
				}
			}
		}
		
		/**
		 * on mouse move on Stage
		 * @param	evt
		 */
		private function onMouseMove(evt:MouseEvent):void {
			this._mousePoint.x = this.mouseX;
			this._mousePoint.y = this.mouseY;
			this._mousePoint3D = _mousePoint.clone();
			this._globalMousePoint.x = this.stage.mouseX;
			this._globalMousePoint.y = this.stage.mouseY;
			
			this.onDraging();
			
			this.dispatchEvent(new Event(Event.CHANGE, true));
		}
		
		/**
		 * on mouse roll over this control
		 * @param	evt
		 */
		private function onRollOver(evt:MouseEvent = null):void {
			this._isOnMouse = true;
			if (_cursor && !_draging)CustomMouseCursor.show(_cursor);
		}
		
		/**
		 * on mouse roll out this control
		 * @param	evt
		 */
		private function onRollOut(evt:MouseEvent = null):void {
			this._isOnMouse = false;
			//clear mouse cursor
			if (CustomMouseCursor.cursor == _cursor && !_draging) {
				CustomMouseCursor.unlock();
				CustomMouseCursor.clear();
			}
		}
		
		/**
		 * setup listeners on skins
		 * @param	evt
		 */
		protected function buildListenersToSkin():void {
			//listen skin mouse action
			_skin.addEventListener(MouseEvent.ROLL_OVER, onRollSkinOver);
			_skin.addEventListener(MouseEvent.ROLL_OUT, onRollSkinOut);
			_skin.addEventListener(MouseEvent.MOUSE_DOWN, onSkinMouseDown);
			
			//will act like "roll over" target if mouse being on skin
			if (_skin.hitTestPoint(this.stage.mouseX, this.stage.mouseY, true)) {
				_skin.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
			}
		}
		
		/**
		 * clear listeners on skins
		 * @param	evt
		 */
		protected function clearListenersToSkin():void {
			_skin.removeEventListener(MouseEvent.ROLL_OVER, onRollSkinOver);
			_skin.removeEventListener(MouseEvent.ROLL_OUT, onRollSkinOut);
			_skin.removeEventListener(MouseEvent.MOUSE_DOWN, onSkinMouseDown);
		}
		
		/**
		 * on mouse roll over skin
		 * @param	evt
		 */
		private function onRollSkinOver(evt:MouseEvent = null):void {
			evt.stopImmediatePropagation();
			evt.preventDefault();
			this.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER, true));
		}
		
		/**
		 * on mouse roll out skin
		 * @param	evt
		 */
		private function onRollSkinOut(evt:MouseEvent = null):void {
			evt.stopImmediatePropagation();
			evt.preventDefault();
			this.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT, true));
		}
		
		/**
		 * on mouse down on skin
		 * @param	evt
		 */
		private function onSkinMouseDown(evt:MouseEvent = null):void {
			evt.stopImmediatePropagation();
			evt.preventDefault();
			this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN, true));
		}
		//------------------------------
		//------protected functions-----
		//------------------------------
		
		/**
		 * draw the control graphics
		 */
		protected function draw():void {
		}
		
		/**
		 * clear the control graphics
		 */
		protected function clear():void {
			_sp.graphics.clear();
		}
		
		/**
		 * when user start drag the registration point
		 */
		protected function onStartDrag():void {
			if(showValue)_textfield.visible = true;
		}
		
		/**
		 * when user draging the registration point
		 */
		protected function onDraging():void {
		}
		
		/**
		 * when user stop drag the registration point
		 */
		protected function onStopDrag():void {
			_textfield.text = "";
			_textfield.visible = false;
			_value = 0;
		}
		
		//------------------------------
		//---------public functions-----
		//------------------------------
		/**
		 * set this control's cursor when mouse interact
		 * @param	dp
		 */
		public function setCursor(dp:DisplayObject):void {
			_cursor = dp;
			if (CustomMouseCursor.cursor == _cursor) CustomMouseCursor.show(_cursor);
		}
		
	}

}