package cn.itamt.mxp {
	import adobe.utils.MMExecute;

	import fl.data.DataProvider;
	import fl.managers.StyleManager;

	import com.liquid.controls.LiquidCheckBox;
	import com.liquid.controls.LiquidComboBox;
	import com.liquid.controls.LiquidTextInput;

	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextFormat;

	/**
	 * @author itamt[at]qq.com
	 */
	public class GenieEffectorCustomUI extends MovieClip {

		public var geffector : GenieEffector;

		public var target_ti : LiquidTextInput;
		public var easeType_cb : LiquidComboBox;
		public var grid_cb : LiquidCheckBox;
		public var smooth_cb : LiquidCheckBox;
		public var duration_ti : LiquidTextInput;
		public var segmentv_ti : LiquidTextInput;		public var segmenth_ti : LiquidTextInput;
		public var dragTrigger_ti : LiquidTextInput;		public var miniTrigger_ti : LiquidTextInput;		public var maxiTrigger_ti : LiquidTextInput;

		protected var _variables : String = "_targetInstanceName,dragTriggerName,duration,ease,grid,maximizeTriggerName,minimizeTriggerName,segmentsh,segmentsv,smooth,init";

		public function GenieEffectorCustomUI() {
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;

			//			var easeStr : String = "Back.easeIn,Back.easeOut,Back.easeInOut,Cubic.easeIn,Cubic.easeOut,Cubic.easeInOut,Elastic.easeIn,Elastic.easeOut,Elastic.easeInOut,Expo.easeIn,Expo.easeOut,Expo.easeInOut,Linear.easeNone,Quad.easeIn,Quad.easeOut,Quad.easeInOut,Quart.easeIn,Quart.easeOut,Quart.easeInOut,Quint.easeIn,Quint.easeOut,Quint.easeInOut,Sine.easeIn,Sine.easeOut,Sine.easeInOut";			var easeStr : String = "Back,Cubic,Elastic,Expo,Linear,Quad,Quart,Quint,Sine";
			var items : Array = easeStr.split(",");
			items.map(function(element : *, index : int, arr : Array):void {
				arr[index] = {data:element, label:element};
			});
			easeType_cb.dataProvider = new DataProvider(items);
			easeType_cb.rowCount = 9;
			StyleManager.setStyle("textFormat", new TextFormat("Verdana", 12));
			
			this.setControls();
			
			this.addEventListener(Event.ENTER_FRAME, init);
		}

		private function init(event : Event) : void {
			this.removeEventListener(Event.ENTER_FRAME, init);

			addEventListener(Event.CHANGE, this.applyValues);
			easeType_cb.addEventListener(Event.CHANGE, this.applyValues);
			
			this.setControls();
		}

		private function setControls() : void {
			target_ti.text = this.getParamValue("_targetInstanceName");
			grid_cb.selected = (this.getParamValue("grid") == "true");
			smooth_cb.selected = (this.getParamValue("smooth") == "true");
			duration_ti.text = this.getParamValue("duration");
			easeType_cb.selectedIndex = int(getParamValue("ease"));
			segmentv_ti.text = this.getParamValue("segmentsv");			segmenth_ti.text = this.getParamValue("segmentsh");
			dragTrigger_ti.text = this.getParamValue("dragTriggerName");			maxiTrigger_ti.text = this.getParamValue("maximizeTriggerName");			miniTrigger_ti.text = this.getParamValue("minimizeTriggerName");
			
			if(dragTrigger_ti.text == "")dragTrigger_ti.text = target_ti.text;
			
			this.applyValues();
		}

		private function getParamValue(paramName : String) : * {
			var i : int = _variables.split(",").indexOf(paramName);
			var jsfl : XML = <jsfl><![CDATA[
				if(fl.getDocumentDOM().selection[0].parameters[&INDEX&].valueType == "List"){
					fl.getDocumentDOM().selection[0].parameters[&INDEX&].listIndex;
				}else{
					fl.getDocumentDOM().selection[0].parameters[&INDEX&].value;
				}
			]]></jsfl>;
			var value : String = MMExecute(jsfl.toString().replace(/&INDEX&/g, i));
			return value;
		}

		private function  setParamValue(paramName : String, value : *, valueType : String = "String") : void {
			var i : int = _variables.split(",").indexOf(paramName);
			if(valueType == "List") {
				MMExecute("fl.getDocumentDOM().selection[0].parameters[" + i + "].listIndex = " + value);
			}else if(valueType == "Boolean") {
				MMExecute("fl.getDocumentDOM().selection[0].parameters[" + i + "].value = " + value);
			}else if(valueType == "Number") {
				MMExecute("fl.getDocumentDOM().selection[0].parameters[" + i + "].value = " + value);
			} else {
				MMExecute("fl.getDocumentDOM().selection[0].parameters[" + i + "].value = \"" + value + "\"");
			}
		}

		private function applyValues(evt : Event = null) : void {
			geffector.grid = grid_cb.selected;
			geffector.smooth = smooth_cb.selected;
			geffector.ease = easeType_cb.selectedItem.data;
			geffector.duration = (isNaN(parseFloat(duration_ti.text)) ? .8 : parseFloat(duration_ti.text));
			geffector.segmentsv = (isNaN(parseFloat(segmentv_ti.text)) ? 8 : parseFloat(segmentv_ti.text));			geffector.segmentsh = (isNaN(parseFloat(segmenth_ti.text)) ? 8 : parseFloat(segmenth_ti.text));
			
			//
			setParamValue("_targetInstanceName", target_ti.text);			setParamValue("dragTriggerName", dragTrigger_ti.text, "String");
			setParamValue("maximizeTriggerName", maxiTrigger_ti.text);			setParamValue("minimizeTriggerName", miniTrigger_ti.text);

			setParamValue("grid", geffector.grid, "Boolean");			setParamValue("smooth", geffector.smooth, "Boolean");			setParamValue("ease", this.easeType_cb.selectedIndex, "List");			setParamValue("duration", geffector.duration, "Number");			setParamValue("segmentsv", geffector.segmentsv, "Number");			setParamValue("segmentsh", geffector.segmentsh, "Number");
		}
	}
}
