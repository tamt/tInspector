package cn.itamt.utils.inspector.firefox.setting {
	import cn.itamt.utils.Debug;
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.plugins.InspectorPluginId;
	import cn.itamt.utils.inspector.ui.InspectorStageReference;
	import cn.itamt.utils.inspector.ui.InspectorTextField;
	import cn.itamt.utils.inspector.ui.InspectorViewPanel;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.external.ExternalInterface;

	/**
	 * @author itamt[at]qq.com
	 */
	public class fInspectorSetting extends InspectorViewPanel {

		private var _pluginList : Sprite;
		private var tip_tf : InspectorTextField;

		public function fInspectorSetting(w : Number = 190, h : Number = 240, autoDisposeWhenRemove : Boolean = true, resizeable : Boolean = false, closeable : Boolean = true) {
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;

			this.x = this.y = 5;

			InspectorStageReference.referenceTo(this.stage);
			super(InspectorLanguageManager.getStr("FunctionSetting"), w, h, autoDisposeWhenRemove, resizeable, closeable);

			tip_tf = InspectorTextField.create(InspectorLanguageManager.getStr("PluginSelectorTip"), 0xffffff, 12);
			this.addChild(tip_tf);

			// 使面板不能拖动
			this.bg.mouseEnabled = this.bg.mouseChildren = false;

			init();
		}

		public function init():void {
			_pluginList = new Sprite();
			_pluginList.graphics.lineTo(0, 0);
			this.setContent(_pluginList);

			var arr:Array;
			if(fInspectorConfig.getPlugins() == null) {
				arr = [InspectorPluginId.APPSTATS_VIEW, InspectorPluginId.FULL_SCREEN, InspectorPluginId.GLOBAL_ERROR_KEEPER, InspectorPluginId.RELOAD_APP, InspectorPluginId.DOWNLOAD_ALL, InspectorPluginId.SWFINFO_VIEW, InspectorPluginId.FLASH_FIREBUG];
				fInspectorConfig.setPlugins(arr);
				for each (var pluginName : String in arr) {
					fInspectorConfig.setEnablePlugin(pluginName);
				}
				fInspectorConfig.save();
			}
			Debug.trace('[fInspectorSetting][init]' + fInspectorConfig.getPlugins());

			arr = fInspectorConfig.getPlugins();
			for(var i : int = 0; i < arr.length; i++) {
				var renderer : fInspectorPluginItemRenderer = new fInspectorPluginItemRenderer();
				renderer.data = arr[i];
				renderer.label = InspectorLanguageManager.getStr(arr[i]);
				renderer.y = _pluginList.height + 2;
				renderer.enable = fInspectorConfig.getPluginEnable(arr[i]);
				_pluginList.addChild(renderer);
			}

			this._pluginList.addEventListener(Event.SELECT, onSelectPlugin);
			this._pluginList.addEventListener("pluginHelp", onPluginHelp);
		}

		override public function relayout():void {
			super.relayout();

			tip_tf.width = 180;
			tip_tf.height = tip_tf.textHeight + 4;
			tip_tf.x = _padding.left;
			tip_tf.y = this._height - tip_tf.height - _padding.bottom;
		}

		override protected function onClickClose(evt : Event):void {
			evt.stopImmediatePropagation();

			fInspectorConfig.save();

			// 调用Firefox中的关闭面板函数
			if(ExternalInterface.available) {
				ExternalInterface.call("fInspector.closeSettingPanel");
			}
		}

		/*************************************
		 *********private functions***********
		 ************************************/

		private function onSelectPlugin(event : Event) : void {
			var item : fInspectorPluginItemRenderer;
			if(event.target is fInspectorPluginItemRenderer) {
				item = event.target as fInspectorPluginItemRenderer;
				if(item.enable) {
					fInspectorConfig.setEnablePlugin(item.data);
				} else {
					fInspectorConfig.setDisablePlugin(item.data);
				}
			}

			Debug.trace('[fInspectorSetting][onSelectPlugin]enabled: ' + fInspectorConfig.getEnablePlugins());
			Debug.trace('[fInspectorSetting][onSelectPlugin]all: ' + fInspectorConfig.getPlugins());

			fInspectorConfig.save();
		}

		private function onPluginHelp(event : Event) : void {
			var item : fInspectorPluginItemRenderer;
			if(event.target is fInspectorPluginItemRenderer) {
				item = event.target as fInspectorPluginItemRenderer;

				// 调用Firefox中的显示plugin的说明。
				if(ExternalInterface.available) {
					ExternalInterface.call("fInspector.showFlashInspectorPluginGuide", item.data);
				}
			}
		}
	}
}
