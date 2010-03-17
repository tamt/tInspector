package cn.itamt.utils.inspector.ui {
	import cn.itamt.utils.inspector.data.InspectTarget;
	import cn.itamt.utils.inspector.events.InspectorFilterEvent;
	import cn.itamt.utils.inspector.output.DisplayObjectInfoOutPuter;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;		

	/**
	 * @author tamt
	 */
	public class LiveInspectView extends BaseInspectorView {
		public static const ID : String = 'LiveInspector';

		private var _des : TextField;
		//矩形
		private var _mBtn : Sprite;
		private var _bar : OperationBar;

		public var outputer : DisplayObjectInfoOutPuter;

		public function LiveInspectView() : void {
			super();
			//			this.mouseChildren = this.mouseEnabled = false;
		}

		private var inited : Boolean;

		/**
		 * 当Inspector开启时
		 */
		override public function onTurnOn() : void {
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
			_bar.addEventListener(OperationBar.PRESS_INFO, onPressInfo);			_bar.addEventListener(OperationBar.PRESS_FILTER, onPressFilter);			_bar.addEventListener(OperationBar.DB_CLICK_MOVE, onClickReset);
			
			if(outputer == null) {
				this.outputer = new DisplayObjectInfoOutPuter();
			}
		}

		
		/**
		 * 当Inspector关闭时
		 */
		override public function onTurnOff() : void {
			inited = false;
			dispose();
		}

		/**
		 * 当Inspector查看某个目标显示对象时.
		 */
		override public function onInspect(ele : InspectTarget) : void {
			target = ele;
			update();
			
			if(_bar.stage == null)this.viewContainer.addChild(_bar);
			_bar.validate(target.displayObject);
		}

		/**
		 * 当Inspector实时查看某个目标显示对象时
		 */
		override public function onLiveInspect(ele : InspectTarget) : void {
			this._inspector.stage.addChild(this.viewContainer);
			
			target = ele;
			update(true);
			
			if(_bar.stage)this.viewContainer.removeChild(_bar);
			_bar.validate(target.displayObject);
		}

		/**
		 * 返回这个InspectorView的id, 在tInspector中, 通过id来管理各个InspectorView.
		 */
		override public function getInspectorViewClassID() : String {
			return 'BaseInspectorView';
		}

		private var rect : Rectangle;
		//目标的注册点
		private var reg : Point;
		//目标父容器的注册点
		private var upReg : Point;

		public function update(isLiveMode : Boolean = false) : void {
			if(!contains(_des))this.viewContainer.addChild(_des);
			if(!contains(_mBtn))this.viewContainer.addChild(_mBtn);
			
			rect = target.displayObject.getBounds(this.viewContainer.stage);
			reg = target.displayObject.localToGlobal(new Point(0, 0));
			if(target.displayObject.parent) {
				upReg = target.displayObject.parent.localToGlobal(new Point(0, 0));
			} else {
				upReg = null;
			}
			
			_des.htmlText = outputer.output(target.displayObject);// '[' + ClassTool.getShortClassName(target.displayObject) + ']' + '[x: ' + target.displayObject.x + ', y: ' + target.displayObject.y + '][w: ' + int(target.displayObject.width) + ', h: ' + int(target.displayObject.height) + '][r: ' + int(target.displayObject.rotation) + ']';
			_des.x = rect.x - .5;
			_des.y = rect.y - _des.height + .5;
			
			if(isLiveMode) {
				this.drawMbtn();
				_mBtn.mouseChildren = _mBtn.mouseEnabled = true;
				
				resetTransformPointBtns();
			} else {
				this.drawMbtn(0, 0x636C02);
				_mBtn.mouseChildren = _mBtn.mouseEnabled = false;
				
				drawTransformPointBtns();
			}

			_bar.x = rect.x - .5;
			_bar.y = _des.y - _bar.barHeight;
		}

		private function onClickInspect(evt : MouseEvent) : void {
			this._inspector.inspect(target.displayObject);
		}

		private var drager : Sprite = new Sprite();
		private var dist : Point;

		private function onStartMove(evt : Event) : void {
			this.viewContainer.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			dist = target.displayObject.localToGlobal(new Point(0, 0));
			
			drager.x = viewContainer.mouseX;
			drager.y = viewContainer.mouseY;
			drager.startDrag(true);
			
			dist.x = drager.x - dist.x;
			dist.y = drager.y - dist.y;
		}

		private function onStopMove(evt : Event = null) : void {
			this.viewContainer.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			drager.stopDrag();
		}

		private function onMouseMove(evt : MouseEvent = null) : void {
			var pt : Point = new Point(drager.x - dist.x, drager.y - dist.y);
			pt = target.displayObject.parent.globalToLocal(pt);
			target.displayObject.x = pt.x;
			target.displayObject.y = pt.y;
			
			this.update();
		}

		private function onCloseBar(evt : Event = null) : void {
			if(this.viewContainer.stage)this.viewContainer.parent.removeChild(this.viewContainer);
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
				this.update();
			}
		}

		private var tBtnTL : LiveTransformPointBtn, tBtnTR : LiveTransformPointBtn, tBtnBL : LiveTransformPointBtn, tBtnBR : LiveTransformPointBtn;

		/**
		 * 绘制变形点按钮.
		 */
		private function drawTransformPointBtns() : void {
			//			if(tBtnTL == null) {
			//				tBtnTL = new LiveScalePointBtn(null, null, onScaleTransform);
			//				this.viewContainer.addChild(tBtnTL);			//			}
			if(tBtnTR == null) {
				tBtnTR = new LiveRotatePointBtn(null, null, onRotateTransform);				this.viewContainer.addChild(tBtnTR);			}
			//			if(tBtnBL == null) {
			//				tBtnBL = new LiveRotatePointBtn();			//				this.viewContainer.addChild(tBtnBL);			//			}
			if(tBtnBR == null) {
				tBtnBR = new LiveScalePointBtn(null, null, onScaleTransform);				this.viewContainer.addChild(tBtnBR);
			}			//			var tl : Point = rect.topLeft;
			//			tBtnTL.x = tl.x;
			//			tBtnTL.y = tl.y;
			var tmp : Rectangle = this.target.displayObject.getBounds(this.target.displayObject);
			var tl : Point = this.target.displayObject.localToGlobal(tmp.topLeft);
			var tr : Point = this.target.displayObject.localToGlobal(new Point(tmp.right, tmp.top));
			var bl : Point = this.target.displayObject.localToGlobal(new Point(tmp.left, tmp.bottom));
			var br : Point = this.target.displayObject.localToGlobal(tmp.bottomRight);

			tBtnBR.x = br.x;
			tBtnBR.y = br.y;
			
			tBtnTR.x = tr.x;
			tBtnTR.y = tr.y;
			//			var bl : Point = new Point(rect.left, rect.bottom);
//			tBtnBL.x = bl.x;
//			tBtnBL.y = bl.y;
		}

		/**
		 * 重设变形点按钮
		 */
		private function resetTransformPointBtns() : void {
			if(tBtnTL && tBtnTL.parent)this.tBtnTL.parent.removeChild(tBtnTL);
			if(tBtnTR && tBtnTR.parent)this.tBtnTR.parent.removeChild(tBtnTR);
			if(tBtnBL && tBtnBL.parent)this.tBtnBL.parent.removeChild(tBtnBL);
			if(tBtnBR && tBtnBR.parent)this.tBtnBR.parent.removeChild(tBtnBR);
			
			tBtnTL = null;
			tBtnTR = null;
			tBtnBL = null;
			tBtnBR = null;
		}

		private function drawMbtn(alpha : Number = .3, bColor : uint = 0xff0000) : void {
			_mBtn.graphics.clear();
			_mBtn.graphics.lineStyle(2, bColor, 1, false, 'normal', 'square', 'miter');
			_mBtn.graphics.beginFill(0xff0000, alpha);
			
			var tmp : Rectangle = this.target.displayObject.getBounds(this.target.displayObject);
			var tl : Point = this.target.displayObject.localToGlobal(tmp.topLeft);			var tr : Point = this.target.displayObject.localToGlobal(new Point(tmp.right, tmp.top));			var bl : Point = this.target.displayObject.localToGlobal(new Point(tmp.left, tmp.bottom));			var br : Point = this.target.displayObject.localToGlobal(tmp.bottomRight);
			_mBtn.graphics.moveTo(tl.x, tl.y);
			_mBtn.graphics.lineTo(tr.x, tr.y);			_mBtn.graphics.lineTo(br.x, br.y);			_mBtn.graphics.lineTo(bl.x, bl.y);			_mBtn.graphics.lineTo(tl.x, tl.y);
			
			_mBtn.graphics.beginFill(0xff0000, alpha);
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
			if(upReg) {
				_mBtn.graphics.lineStyle(2, 0x0000ff, 1, false, 'normal', 'square', 'miter');
				_mBtn.graphics.moveTo(upReg.x - 4, upReg.y);
				_mBtn.graphics.lineTo(upReg.x + 4, upReg.y);
				_mBtn.graphics.moveTo(upReg.x, upReg.y - 4);
				_mBtn.graphics.lineTo(upReg.x, upReg.y + 4);
			}
		}

		private function onRotateTransform(btn : LiveTransformPointBtn) : void {
			var lp : Point = this.target.displayObject.globalToLocal(btn.lastMousePt);
			var or : Number = Math.atan2(lp.y, lp.x);
			var nr : Number = Math.atan2(this.target.displayObject.mouseY, this.target.displayObject.mouseX);
			
			var dif : Number = ((nr - or) * 180 / Math.PI) % 360;
			if (dif != dif % 180) {
				dif = (dif < 0) ? dif + 360 : dif - 360;
			}

			this.target.displayObject.rotation += dif;
			
			this.update();
		}

		/**
		 * 缩放变形.
		 */
		private function onScaleTransform(btn : LiveTransformPointBtn) : void {			var pt : Point = new Point(this.target.displayObject.parent.mouseX, this.target.displayObject.parent.mouseY);
			var lp : Point = this.target.displayObject.parent.globalToLocal(btn.lastMousePt);

			switch(btn) {
//				case tBtnTL:
				//					target.displayObject.width = tmp.right - this.target.displayObject.parent.mouseX;
				//					target.displayObject.height = tmp.bottom - this.target.displayObject.parent.mouseY;
				//					break;
				case tBtnBR:
					target.displayObject.width += pt.x - lp.x;
					target.displayObject.height += pt.y - lp.y;
					break;
					/*
				case tBtnTR:
					break;
				case tBtnBL:
					break;
					 * 
					 */
			}
					
			this.update();
		}

		/**
		 * 單擊查看顯示對象結構
		 */
		private function onPressStructure(evt : Event) : void {
			_inspector.registerViewById('StructurePanel');
		}

		/**
		 * 單擊查看詳細信息
		 */
		private function onPressInfo(evt : Event) : void {
			_inspector.registerViewById('PropertyPanel');
		}

		/**
		 * 單擊查看詳細信息
		 */
		private function onPressFilter(evt : Event) : void {
			//			_inspector.setInspectFilter(this.target.displayObject['constructor'] as Class);
			_inspector.stage.dispatchEvent(new InspectorFilterEvent(InspectorFilterEvent.CHANGE, this.target.displayObject['constructor'] as Class));
		}

		/**
		 * 自定义信息的输出
		 */
		override public function setInfoOutputer(outputer : DisplayObjectInfoOutPuter) : void {
			this.outputer = outputer;
		}

		public function dispose() : void {
			if(this.viewContainer) {
				this.viewContainer.graphics.clear();
				//			this.viewContainer.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				if(this.viewContainer.stage) {
					this.viewContainer.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
					this.viewContainer.stage.removeChild(this.viewContainer);
				}
			}
			
			if(_des)if(_des.parent)_des.parent.removeChild(_des);
		
			target = null;
			
			outputer.dispose();
		
			_mBtn.removeEventListener(MouseEvent.CLICK, onClickInspect);
			
			_bar.removeEventListener(OperationBar.DOWN_MOVE, this.onStartMove);
			_bar.removeEventListener(OperationBar.UP_MOVE, this.onStopMove);
			_bar.removeEventListener(OperationBar.PRESS_CLOSE, onCloseBar);
			_bar.removeEventListener(OperationBar.PRESS_PARENT, onPressParent);
			_bar.removeEventListener(OperationBar.PRESS_CHILD, onPressChild);
			_bar.removeEventListener(OperationBar.PRESS_BROTHER, onPressBrother);			_bar.removeEventListener(OperationBar.PRESS_STRUCTURE, onPressStructure);			_bar.removeEventListener(OperationBar.PRESS_INFO, onPressInfo);
		}
	}
}
