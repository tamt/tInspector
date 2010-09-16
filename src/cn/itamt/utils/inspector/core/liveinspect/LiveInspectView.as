package cn.itamt.utils.inspector.core.liveinspect {
	import cn.itamt.utils.DisplayObjectTool;
	import cn.itamt.utils.inspector.core.BaseInspectorPlugin;
	import cn.itamt.utils.inspector.core.IInspector;
	import cn.itamt.utils.inspector.core.InspectTarget;
	import cn.itamt.utils.inspector.events.InspectorFilterEvent;
	import cn.itamt.utils.inspector.output.DisplayObjectInfoOutPuter;
	import cn.itamt.utils.inspector.output.InspectorOutPuterManager;
	import cn.itamt.utils.inspector.plugins.InspectorPluginId;
	import cn.itamt.utils.inspector.ui.InspectorTextField;

	import com.senocular.display.TransformTool;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 * @author tamt
	 */
	public class LiveInspectView extends BaseInspectorPlugin {
		//显示信息文本
		private var _des : TextField;
		//覆盖在查看对象之上的矩形按钮
		private var _mBtn : Sprite;
		//显示查看对象区域的矩形(会一直置顶)
		private var _mFrame : Shape;
		//操作菜单条
		private var _bar : OperationBar;
		//用于变形
		private var _tfm : TransformTool;
		//
		private var inited : Boolean;

		public function LiveInspectView() : void {
			super();
			
			outputerManager = new InspectorOutPuterManager();
		}

		//////////////////////////////////////
		//////////override interfaces/////////
		//////////////////////////////////////
		override public function getPluginId() : String {
			return InspectorPluginId.LIVE_VIEW;
		}

		override public function onRegister(inspector : IInspector) : void {
			super.onRegister(inspector);
			
			_icon = new LiveInspectButton();
		}

		/**
		 * 当Inspector开启时
		 */
		override public function onActive() : void {
			super.onActive();
			
			this._inspector.startLiveInspect();
			
			if(inited)return;
			inited = true;
			
			this.viewContainer = new Sprite();
			this.viewContainer.mouseEnabled = false;

			_des = InspectorTextField.create('', 0xffffff, 13);
			_des.background = true;
			_des.backgroundColor = 0x636C02;
			_des.border = true;
			_des.borderColor = 0x636C02;
			_des.cacheAsBitmap = true;
			_des.autoSize = 'left';
			this.viewContainer.addChild(_des);
		
			_mBtn = new Sprite();
			_mBtn.buttonMode = true;
			this.viewContainer.addChild(_mBtn);
			
			//显示查看对象区域的矩形(会一直置顶)
			_mFrame = new Shape();
			
			//变形器
			_tfm = new TransformTool();
			_tfm.addEventListener(TransformTool.TRANSFORM_TARGET, function(evt : Event):void {
				update();
			});
			_tfm.addControl(new ResetTransofrmControl());
			_tfm.raiseNewTargets = false;
			_tfm.moveEnabled = false;
			//			_tfm.moveNewTargets = true;
			_tfm.outlineEnabled = false;
			//			_tfm.cursorsEnabled = false;
			_tfm.setSkin(TransformTool.SCALE_TOP_LEFT, new Sprite());
			_tfm.setSkin(TransformTool.SCALE_TOP_RIGHT, new Sprite());
			_tfm.setSkin(TransformTool.SCALE_BOTTOM_RIGHT, new LiveScalePointBtn());
			_tfm.setSkin(TransformTool.SCALE_BOTTOM_LEFT, new Sprite());
			_tfm.setSkin(TransformTool.SCALE_TOP, new Sprite());
			_tfm.setSkin(TransformTool.SCALE_RIGHT, new LiveScalePointBtn());
			_tfm.setSkin(TransformTool.SCALE_BOTTOM, new LiveScalePointBtn());
			_tfm.setSkin(TransformTool.SCALE_LEFT, new Sprite());
			_tfm.setSkin(TransformTool.ROTATION_TOP_RIGHT, new LiveRotatePointBtn());
			_tfm.setSkin(TransformTool.ROTATION_BOTTOM_LEFT, new Sprite());
			_tfm.setSkin(TransformTool.ROTATION_TOP_LEFT, new Sprite());
			_tfm.setSkin(TransformTool.ROTATION_BOTTOM_RIGHT, new Sprite());
			this.viewContainer.addChild(_tfm);
			
			//------操作条------
			_bar = new OperationBar();
			_bar.init();
			//------------------

			_mBtn.addEventListener(MouseEvent.CLICK, onClickInspect);
			
			_bar.addEventListener(OperationBar.DOWN_MOVE, onStartMove);
			_bar.addEventListener(OperationBar.UP_MOVE, onStopMove);
			_bar.addEventListener(OperationBar.PRESS_CLOSE, onCloseBar);
			_bar.addEventListener(OperationBar.PRESS_PARENT, onPressParent);
			_bar.addEventListener(OperationBar.PRESS_CHILD, onPressChild);
			_bar.addEventListener(OperationBar.PRESS_BROTHER, onPressBrother);
			_bar.addEventListener(OperationBar.PRESS_STRUCTURE, onPressStructure);
			_bar.addEventListener(OperationBar.PRESS_INFO, onPressInfo);
			_bar.addEventListener(OperationBar.PRESS_FILTER, onPressFilter);
			_bar.addEventListener(OperationBar.DB_CLICK_MOVE, onClickReset);
		}

		
		/**
		 * 当Inspector关闭时
		 */
		override public function onUnActive() : void {
			super.onUnActive();
			
			this._inspector.stopLiveInspect();
			
			inited = false;
			
			if(this.viewContainer) {
				this.viewContainer.graphics.clear();
				//			this.viewContainer.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				if(this.viewContainer.stage) {
					this.viewContainer.stage.removeEventListener(Event.ENTER_FRAME, onMouseMove);
					this.viewContainer.stage.removeChild(this.viewContainer);
				}
				if(this._mFrame.stage)this._mFrame.stage.removeChild(this._mFrame);
			}
			
			if(_des)if(_des.parent)_des.parent.removeChild(_des);
		
			target = null;
			_tfm.target = null;
		
			_mBtn.removeEventListener(MouseEvent.CLICK, onClickInspect);
			
			_bar.removeEventListener(OperationBar.DOWN_MOVE, this.onStartMove);
			_bar.removeEventListener(OperationBar.UP_MOVE, this.onStopMove);
			_bar.removeEventListener(OperationBar.PRESS_CLOSE, onCloseBar);
			_bar.removeEventListener(OperationBar.PRESS_PARENT, onPressParent);
			_bar.removeEventListener(OperationBar.PRESS_CHILD, onPressChild);
			_bar.removeEventListener(OperationBar.PRESS_BROTHER, onPressBrother);
			_bar.removeEventListener(OperationBar.PRESS_STRUCTURE, onPressStructure);
			_bar.removeEventListener(OperationBar.PRESS_INFO, onPressInfo);
		}

		override public function contains(child : DisplayObject) : Boolean {
			if(viewContainer) {
				return viewContainer == child || viewContainer.contains(child) || _mFrame == child;
			} else {
				return false;
			}
		}

		/**
		 * 当Inspector查看某个目标显示对象时.
		 */
		override public function onInspect(ele : InspectTarget) : void {
			target = ele;
			_tfm.target = null;
			_tfm.target = target.displayObject;
			update();

			if(_bar.stage == null)this.viewContainer.addChild(_bar);
			_bar.validate(target.displayObject);
			
			//
			//			DisplayObjectTool.swapToTop(this.viewContainer);
		}

		/**
		 * 当Inspector实时查看某个目标显示对象时
		 */
		override public function onLiveInspect(ele : InspectTarget) : void {
			if(this.viewContainer.stage == null)this._inspector.stage.addChild(this.viewContainer);
			this._inspector.stage.addChild(this._mFrame);
			
			target = ele;
			_tfm.target = null;
			update(true);
			
			if(_bar.stage)this.viewContainer.removeChild(_bar);
			_bar.validate(target.displayObject);
		}

		/**
		 * 需要更新某个显示对象时.
		 */
		override public function onUpdate(target : InspectTarget = null) : void {
			_bar.validate(target.displayObject);
			
			if(target == this.target) {
				_tfm.target = null;
				_tfm.target = this.target.displayObject;
				update();
			}
		}

		//////////////////////////////////////
		//////////////////////////////////////
		//////////////////////////////////////
		//////////////////////////////////////
		//////////private functions///////////
		//////////////////////////////////////
		//////////////////////////////////////
		//////////////////////////////////////
		//////////////////////////////////////

		private var rect : Rectangle;
		//目标的注册点
		private var reg : Point;
		//目标父容器的注册点
		private var parentReg : Point;

		/**
		 * 更新显示
		 */
		private function update(isLiveMode : Boolean = false) : void {
			if(!contains(_des))this.viewContainer.addChild(_des);
			if(!contains(_mBtn))this.viewContainer.addChild(_mBtn);
			
			rect = target.displayObject.getBounds(this.viewContainer.stage);
			reg = target.displayObject.localToGlobal(new Point(0, 0));
			if(target.displayObject.parent) {
				parentReg = target.displayObject.parent.localToGlobal(new Point(0, 0));
			} else {
				parentReg = null;
			}
			
			var outputer : DisplayObjectInfoOutPuter = outputerManager.getOutputerByInstance(target.displayObject);
			_des.htmlText = outputer.output(target.displayObject);
			_des.x = rect.x - .5;
			_des.y = rect.y - _des.height + .5;
			
			if(isLiveMode) {
				this.drawMbtn();
				_mBtn.mouseChildren = _mBtn.mouseEnabled = true;
			} else {
				this.drawMbtn(0, 0x636C02);
				_mBtn.mouseChildren = _mBtn.mouseEnabled = false;
			}

			_bar.x = rect.x - .5;
			_bar.y = _des.y - _bar.barHeight;
		}

		private function onClickInspect(evt : MouseEvent) : void {
			this._inspector.inspect(target.displayObject);
		}

		private var lp : Point;

		private function onStartMove(evt : Event) : void {
			this.viewContainer.stage.addEventListener(Event.ENTER_FRAME, onMouseMove);
			lp = new Point(_tfm.mouseX, _tfm.mouseY);
			
			if(this.viewContainer.parent)DisplayObjectTool.swapToTop(this.viewContainer);
		}

		private function onStopMove(evt : Event = null) : void {
			this.viewContainer.stage.removeEventListener(Event.ENTER_FRAME, onMouseMove);
		}

		private function onMouseMove(evt : Event = null) : void {
			var toolMatrix : Matrix = _tfm.toolMatrix;
			toolMatrix.tx += _tfm.mouseX - lp.x;
			toolMatrix.ty += _tfm.mouseY - lp.y;
			_tfm.toolMatrix = toolMatrix;
			_tfm.apply();
			
			lp.x = _tfm.mouseX;
			lp.y = _tfm.mouseY;
			
			this.update();
		}

		private function onCloseBar(evt : Event = null) : void {
			if(this.viewContainer.stage)this.viewContainer.parent.removeChild(this.viewContainer);
			if(this._mFrame.stage)this._mFrame.parent.removeChild(this._mFrame);
			//
			this._inspector.startLiveInspect();
		}

		private function onPressParent(evt : Event) : void {
			if(target) {
				if(target.displayObject.parent) {
					this._inspector.inspect(target.displayObject.parent);
				}
			}
		}

		private function onPressChild(evt : Event) : void {
			if(target) {
				if(target.displayObject is DisplayObjectContainer) {
					this._inspector.inspect((target.displayObject as DisplayObjectContainer).getChildAt(0));
				}
			}
		}

		private function onPressBrother(evt : Event) : void {
			if(target) {
				if(target.displayObject.parent) {
					var container : DisplayObjectContainer = target.displayObject.parent;
					var i : int = container.getChildIndex(target.displayObject);
					var t : int = (++i) % (container.numChildren);
					this._inspector.inspect(container.getChildAt(t));
				}
			}
		}

		/**
		 * 单击重置时
		 */
		private function onClickReset(evt : Event) : void {
			if(target) {
				target.resetTarget();
				if(_tfm) {
					_tfm.target = null;
					_tfm.target = target.displayObject;
				}
				this.update();
			}
		}

		private function drawMbtn(alpha : Number = .2, bColor : uint = 0xff0000) : void {
			_mBtn.graphics.clear();
			_mBtn.graphics.lineStyle(2, bColor, 1, false, 'normal', 'square', 'miter');
			_mBtn.graphics.beginFill(0xff0000, 0);
			
			var tmp : Rectangle = this.target.displayObject.getBounds(this.target.displayObject);
			var tl : Point = this.target.displayObject.localToGlobal(tmp.topLeft);
			var tr : Point = this.target.displayObject.localToGlobal(new Point(tmp.right, tmp.top));
			var bl : Point = this.target.displayObject.localToGlobal(new Point(tmp.left, tmp.bottom));
			var br : Point = this.target.displayObject.localToGlobal(tmp.bottomRight);
			_mBtn.graphics.moveTo(tl.x, tl.y);
			_mBtn.graphics.lineTo(tr.x, tr.y);
			_mBtn.graphics.lineTo(br.x, br.y);
			_mBtn.graphics.lineTo(bl.x, bl.y);
			_mBtn.graphics.lineTo(tl.x, tl.y);
			
			_mBtn.graphics.beginFill(0xff0000, 0);
			_mBtn.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			
			//注册点十字形绘制.
			_mBtn.graphics.lineStyle(1, bColor, 1, false, 'normal', 'square', 'miter');
			_mBtn.graphics.drawCircle(reg.x, reg.y, 5);
			_mBtn.graphics.lineStyle(2, bColor, 1, false, 'normal', 'square', 'miter');
			_mBtn.graphics.moveTo(reg.x - 3, reg.y);
			_mBtn.graphics.lineTo(reg.x + 3, reg.y);
			_mBtn.graphics.moveTo(reg.x, reg.y - 3);
			_mBtn.graphics.lineTo(reg.x, reg.y + 3);
			
			_mBtn.graphics.endFill();
			
			//父容器注册点十字形
			if(parentReg) {
				_mBtn.graphics.lineStyle(2, 0x0000ff, 1, false, 'normal', 'square', 'miter');
				_mBtn.graphics.moveTo(parentReg.x - 4, parentReg.y);
				_mBtn.graphics.lineTo(parentReg.x + 4, parentReg.y);
				_mBtn.graphics.moveTo(parentReg.x, parentReg.y - 4);
				_mBtn.graphics.lineTo(parentReg.x, parentReg.y + 4);
			}
			
			//
			_mFrame.graphics.clear();
			_mFrame.graphics.lineStyle(2, bColor, 1, false, 'normal', 'square', 'miter');
			//			_mFrame.graphics.beginFill(0xff0000, alpha);
			//			_mFrame.graphics.moveTo(tl.x, tl.y);
			//			_mFrame.graphics.lineTo(tr.x, tr.y);
			//			_mFrame.graphics.lineTo(br.x, br.y);
			//			_mFrame.graphics.lineTo(bl.x, bl.y);
			//			_mFrame.graphics.lineTo(tl.x, tl.y);
			_mFrame.graphics.beginFill(0xff0000, alpha);
			_mFrame.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			_mFrame.graphics.endFill();
		}

		/**
		 * 單擊查看顯示對象結構
		 */
		private function onPressStructure(evt : Event) : void {
			_inspector.pluginManager.activePlugin(InspectorPluginId.STRUCT_VIEW);
		}

		/**
		 * 單擊查看詳細信息
		 */
		private function onPressInfo(evt : Event) : void {
			_inspector.pluginManager.activePlugin(InspectorPluginId.PROPER_VIEW);
		}

		/**
		 * 單擊查看詳細信息
		 */
		private function onPressFilter(evt : Event) : void {
			//			_inspector.setInspectFilter(this.target.displayObject['constructor'] as Class);
			_inspector.stage.dispatchEvent(new InspectorFilterEvent(InspectorFilterEvent.CHANGE, this.target.displayObject['constructor'] as Class));
		}
	}
}
