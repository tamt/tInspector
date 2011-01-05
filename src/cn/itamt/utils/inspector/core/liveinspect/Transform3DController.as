package cn.itamt.utils.inspector.core.liveinspect 
{
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.plugins.tfm3d.ITransform3DController;
	import cn.itamt.utils.inspector.ui.InspectorLabelButton;
	import cn.itamt.utils.inspector.ui.InspectorSymbolBmd;
	import cn.itamt.utils.inspector.ui.InspectorSymbolIcon;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import transform3d.consts.Transform3DMode;
	import transform3d.consts.TransformToolMode;
	import transform3d.controls.Style;
	import transform3d.events.TransformEvent;
	import transform3d.toolbar.IToolButton;
	import transform3d.toolbar.ToolBar;
	import transform3d.Transform3DTool;
	import transform3d.util.Util;
	/**
	 * Transform3DTool controller
	 * @author tamt
	 */
	public class Transform3DController extends Sprite implements ITransform3DController
	{
		private var _tool3d:Transform3DTool;
		private var _target:DisplayObject;
		
		//移动工具按钮
		private var _tToolBtn:TransformToolButton;
		//绽放工具按钮
		private var _sToolBtn:TransformToolButton;
		//旋转工具按钮
		private var _rToolBtn:TransformToolButton;
		//模式按钮
		private var _modeBtn:TransformToolButton;
		//工具条
		private var _bar:ToolBar;
		
		public function Transform3DController()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		private function onRemoved(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			_bar.removeEventListener(MouseEvent.CLICK, onClickToolButton);
			removeChild(_bar);
			_tool3d.removeEventListener(TransformEvent.UPDATE, onTransformUpdate);
			removeChild(_tool3d);
			
			_bar = null;
			_tool3d = null;
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			_tool3d = new Transform3DTool();
			//设置tool3d各个control的鼠标样式
			_tool3d.rotationTool.xCursor = new Bitmap(InspectorSymbolIcon.getIcon(InspectorSymbolIcon.CURSOR_X));
			_tool3d.rotationTool.yCursor = new Bitmap(InspectorSymbolIcon.getIcon(InspectorSymbolIcon.CURSOR_Y));
			_tool3d.rotationTool.zCursor = new Bitmap(InspectorSymbolIcon.getIcon(InspectorSymbolIcon.CURSOR_Z));
			_tool3d.rotationTool.regCursor = new Bitmap(InspectorSymbolIcon.getIcon(InspectorSymbolIcon.CURSOR_REG));
			_tool3d.rotationTool.pCursor = new Bitmap(InspectorSymbolIcon.getIcon(InspectorSymbolIcon.CURSOR_R));
			_tool3d.translationTool.xCursor = new Bitmap(InspectorSymbolIcon.getIcon(InspectorSymbolIcon.CURSOR_X));
			_tool3d.translationTool.yCursor = new Bitmap(InspectorSymbolIcon.getIcon(InspectorSymbolIcon.CURSOR_Y));
			_tool3d.translationTool.zCursor = new Bitmap(InspectorSymbolIcon.getIcon(InspectorSymbolIcon.CURSOR_Z));
			_tool3d.translationTool.regCursor = new Bitmap(InspectorSymbolIcon.getIcon(InspectorSymbolIcon.CURSOR_REG));
			_tool3d.scaleTool.cursor = new Bitmap(InspectorSymbolIcon.getIcon(InspectorSymbolIcon.CURSOR_S));
			_tool3d.scaleTool.regCursor = new Bitmap(InspectorSymbolIcon.getIcon(InspectorSymbolIcon.CURSOR_REG));
			_tool3d.globalTranslationTool.cursor = new Bitmap(InspectorSymbolIcon.getIcon(InspectorSymbolIcon.CURSOR_GT));
			_tool3d.addEventListener(TransformEvent.UPDATE, onTransformUpdate);
			//设置tool的颜色样式
			_tool3d.scaleTool.style = new Style(0x0, 1, 0xffffff, 1, 1);
			_tool3d.scaleTool.size = 5;
			//默认使用tool3d的旋转工具
			//_tool3d.selectTool("scale");
			//_tool3d.selectTool("translation");
			_tool3d.selectTool("rotation");
			_tool3d.selectTool("global translation");
			
			addChild(_tool3d);
			
			//操作菜单条
			_bar = new ToolBar();
			_tToolBtn = new TransformToolButton(InspectorSymbolIcon.getIcon(InspectorSymbolIcon.TOOL3D_T), false);
			_sToolBtn = new TransformToolButton(InspectorSymbolIcon.getIcon(InspectorSymbolIcon.TOOL3D_S), false);
			_rToolBtn = new TransformToolButton(InspectorSymbolIcon.getIcon(InspectorSymbolIcon.TOOL3D_R), false);
			_modeBtn = new TransformToolButton(InspectorSymbolIcon.getIcon(InspectorSymbolIcon.TOOL3D_M), false);
			_tToolBtn.tip = InspectorLanguageManager.getStr("TranslationLabel");
			_sToolBtn.tip = InspectorLanguageManager.getStr("ScaleLabel");
			_rToolBtn.tip = InspectorLanguageManager.getStr("RotationLabel");
			_modeBtn.tip = InspectorLanguageManager.getStr("ModeLabel");
			_bar.addToolButton(_rToolBtn);
			_bar.addToolButton(_sToolBtn);
			_bar.addToolButton(_tToolBtn);
			_bar.addToolButton(_modeBtn, "right");
			addChild(_bar);
			
			//set up select bar tool buttons
			_tToolBtn.active = _tool3d.toolInuse("translation");
			_rToolBtn.active = _tool3d.toolInuse("rotation");
			_sToolBtn.active = _tool3d.toolInuse("scale");
			_modeBtn.active = (_tool3d.mode == Transform3DMode.GLOBAL);
			
			//listen bar select tool
			_bar.addEventListener(MouseEvent.CLICK, onClickToolButton);
			
			//
			if (_target) this.target = _target;
		}
		
		/**
		 * when user select tool/mode of Transform3DTool
		 * @param	evt
		 */
		protected function onClickToolButton(evt:MouseEvent):void {
			if (evt.target is IToolButton) {
				switch(evt.target) {
					case _modeBtn:
						if (_modeBtn.active) {
							this.tool3d.mode = Transform3DMode.INTERNAL;
							_modeBtn.active = false;
						}else {
							this.tool3d.mode = Transform3DMode.GLOBAL;
							_modeBtn.active = true;
						}
						break;
					case _tToolBtn:
						_tToolBtn.active = !_tToolBtn.active;
						_rToolBtn.active = _sToolBtn.active = false;
						break;
					case _rToolBtn:
						_rToolBtn.active = !_rToolBtn.active;
						_tToolBtn.active = _sToolBtn.active = false;
						break;
					case _sToolBtn:
						_sToolBtn.active = !_sToolBtn.active;
						_tToolBtn.active = _rToolBtn.active = false;
						break;
				}
				
				if (_tToolBtn.active) {
					tool3d.selectTool(TransformToolMode.TRANSLATION);
				}else {
					tool3d.deselectTool(TransformToolMode.TRANSLATION);
				}
				
				if (_rToolBtn.active) {
					tool3d.selectTool(TransformToolMode.ROTATION);
				}else {
					tool3d.deselectTool(TransformToolMode.ROTATION);
				}
				
				if (_sToolBtn.active) {
					tool3d.selectTool(TransformToolMode.SCALE);
				}else {
					tool3d.deselectTool(TransformToolMode.SCALE);
				}
				
				if (!(_tToolBtn.active || _rToolBtn.active || _sToolBtn.active)) {
					tool3d.selectTool(TransformToolMode.ROTATION);
					_rToolBtn.active = true;
				}
			}
		}
		
		private function onTransformUpdate(e:TransformEvent = null):void 
		{
			if(target){
				var rect:Rectangle = tool3d.target.getBounds(this);
				_bar.x = rect.x;
				_bar.y = rect.bottom;
				_bar.width = rect.width;
			}
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function convertMX3DtoMX(mx3d:*):Matrix {
			var mx:Matrix = Util.convertMX3DtoMX(this.target.displayObject.transform.matrix3D);
			return mx;
		}
		
		public function get tool3d():Transform3DTool { return _tool3d; }
		
		public function get target():DisplayObject { return _target; }
		
		public function set target(value:DisplayObject):void 
		{
			_target = value;
			
			if (_tool3d) {
				_tool3d.target = target;
				onTransformUpdate();
			}
		}
		
	}

}