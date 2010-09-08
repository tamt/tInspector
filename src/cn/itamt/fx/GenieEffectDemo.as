package cn.itamt.fx {
	import fl.controls.CheckBox;
	import fl.controls.ComboBox;
	import fl.controls.Slider;
	import fl.data.DataProvider;

	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;

	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;

	/**
	 * 
	 * @author itamt@qq.com
	 * 
	 */	
	public  class GenieEffectDemo extends Sprite {

		private const IMAGE_URL : String = "window.png";

		private var bdWindow : BitmapData;

		private var spBack : Sprite;

		private var spContainer : Sprite;

		private var imgWidth : Number;

		private var imgHeight : Number;

		private var imgX : Number;

		private var imgY : Number;

		private var dotSize : Number;

		private var maxRight : Number;

		private var maxBottom : Number;

		private var minTop : Number;

		private var h_res : int;
		private var v_res : int;

		private var vertices : Vector.<Number>;
		private var tPts : Array;

		private var indices : Vector.<int>;

		private var uvtData : Vector.<Number>;

		//各点的tween运动采用不同的持续时间
		public var cb_dDuration : CheckBox;
		//各点的tween运动采用相同的持续时间
		public var cb_dDelay : CheckBox;
		//ease类型
		public var cb_ease : ComboBox;
		public var cb_inOut : ComboBox;

		//背景
		public var bg : MovieClip;

		//时间
		public var slider_duration : Slider;

		
		public function GenieEffectDemo() {
		   
			stage.scaleMode = StageScaleMode.NO_SCALE;
		   
			var loader : Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImgLoad);
			loader.load(new URLRequest(IMAGE_URL));

			cb_ease.dataProvider = new DataProvider(new Array({label:'Back'}, {label:'Bounce'}, {label:'Circ'}, {label:'Cubic'}, {label:'Elastic'}, {label:'Expo'}, {label:'Linear'}, {label:'Quad'}, {label:'Quart'}, {label:'Quint'}, {label:'Sine'}, {label:'Strong'}));
			cb_ease.selectedIndex = 10;
			cb_inOut.dataProvider = new DataProvider(new Array({label:'.easein'}, {label:'.easeout'}, {label:'.easeinout'}));
			cb_inOut.selectedIndex = 1;
			
			cb_dDelay.selected = true;
			
			slider_duration.minimum = 0;
			slider_duration.snapInterval = .1;
			slider_duration.maximum = 1;
			slider_duration.value = .5;
		}

		private function onImgLoad(evt : Event) : void {
			bdWindow = ((evt.target as LoaderInfo).content as Bitmap).bitmapData;

			imgWidth = bdWindow.width;

			imgHeight = bdWindow.height;
		   
			spBack = new Sprite();
		     
			spContainer = new Sprite();
		   
			this.addChild(spBack);
		   
			spBack.addChild(spContainer);
		   
			h_res = 10;
			v_res = 20;
		     
			setUpGummy();
		   
			setUpData();
		   
			setUpListeners();
		}

		private function setUpData() : void {
			
			var j : int;
			
			var i : int;
			
			var indStep : int = 0;
		
			var hStep : Number = imgWidth / h_res;
			
			var vStep : Number = imgHeight / v_res;
			
			vertices = new Vector.<Number>();
			
			uvtData = new Vector.<Number>();
		     
			indices = new Vector.<int>();
			
			tPts = new Array;
		   
			for(j = 0;j <= v_res;j++) {
				tPts[j] = [];
				for(i = 0;i <= h_res;i++) {
					tPts[j][i] = new Point(imgX + i * hStep, imgY + j * vStep);
					if(j < v_res && i < h_res) {
						vertices.push(imgX + i * hStep, imgY + j * vStep, imgX + (i + 1) * hStep, imgY + j * vStep, imgX + (i + 1) * hStep, imgY + (j + 1) * vStep, imgX + i * hStep, imgY + (j + 1) * vStep);
						uvtData.push(i / h_res, j / v_res, (i + 1) / h_res, j / v_res, (i + 1) / h_res, (j + 1) / v_res, i / h_res, (j + 1) / v_res);
				
						indices.push(indStep, indStep + 1, indStep + 3, indStep + 1, indStep + 2, indStep + 3);
					
						indStep += 4;
					}
				}
			}
			
			renderView();
		}

		private function setUpGummy() : void {
		
			imgX = 50;

			imgY = 50;
		   
			dotSize = 14;
		   
			maxRight = 620 - 1.5 * dotSize;

			maxBottom = 500 - 1.5 * dotSize;

			minTop = 60 + 1.5 * dotSize;
		}

		private function renderView() : void {
		
			spContainer.graphics.clear();
		
			//			spContainer.graphics.lineStyle(1);

			spContainer.graphics.beginBitmapFill(bdWindow);
		
			spContainer.graphics.drawTriangles(vertices, indices, uvtData);
		
			spContainer.graphics.endFill();
		}

		private function setUpListeners() : void {		
			bg.addEventListener(MouseEvent.CLICK, resDown);
		}

		private var _hide : Boolean = true;

		private function resDown(e : MouseEvent) : void {
		
			var j : int;
		
			var i : int;
		
			var pt : Point;
		
			var hStep : Number = imgWidth / h_res;
		
			var vStep : Number = imgHeight / v_res;
		
			var tweens : Array = [];
		
			var delay : Number;
			if(_hide) {
				for(j = 0;j <= v_res;j++) {
					for(i = 0;i <= h_res;i++) {
						pt = tPts[j][i];
						delay = (pt.y - imgY) / 1000;
						//						tweens.push(new TweenLite(tPts[j][i], cb_dDuration.selected ? delay : .3, {delay:cb_dDelay.selected ? delay : 0, y:e.stageY}));
						tweens.push(new TweenLite(tPts[j][i], slider_duration.value, {ease:EaseLookup.find(cb_ease.selectedLabel + cb_inOut.selectedLabel), delay:cb_dDelay.selected ? delay : 0, x:e.stageX, y:e.stageY}));
					}
				}
			} else {
				for(j = 0;j <= v_res;j++) {
					for(i = 0;i <= h_res;i++) {
						pt = tPts[j][i];
						delay = (imgY - (imgY + j * vStep - pt.y)) / 1000;
						tweens.push(new TweenLite(tPts[j][i], slider_duration.value, {ease:EaseLookup.find(cb_ease.selectedLabel + cb_inOut.selectedLabel), x:imgX + i * hStep, y:imgY + j * vStep, delay:cb_dDelay.selected ? delay : 0}));
//						tweens.push(new TweenLite(tPts[j][i], cb_dDuration.selected ? delay : .3, {x:imgX + i * hStep, y:imgY + j * vStep, delay:cb_dDelay.selected ? delay : 0}));
					}
				}
			}
			
			new TimelineLite({tweens:tweens, onUpdate:this.onTweening});
		
			_hide = !_hide;
		}

		private function onTweening() : void {
		
			vertices = new Vector.<Number>();
		
			var j : int, i : int;
			for(j = 0;j < v_res;j++) {
				for(i = 0;i < h_res;i++) {
					vertices.push(tPts[j][i].x, tPts[j][i].y, tPts[j][i + 1].x, tPts[j][i + 1].y, tPts[j + 1][i + 1].x, tPts[j + 1][i + 1].y, tPts[j + 1][i].x, tPts[j + 1][i].y);
				}
			}
		
			this.renderView();
		}
	}
}