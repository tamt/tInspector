/**
 * Hi-ReS! Stats v1.2
 * Copyright (c) 2008 Mr.doob, Theo @ hi-res.net
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 * How to use:
 * 
 * 	addChild( new Stats() );
 * 
 * version log:
 * 
 *	08.02.15		1.2		Mr.doob			+ Class renamed to Stats (previously FPS)
 *	08.01.05		1.2		Mr.doob			+ Click changes the fps of flash (half up increases,
 * 										   half down decreases)
 *	08.01.04		1.1		Mr.doob & Theo		+ Log shape shape for the Mem
 * 										+ More room for the MS
 * 										+ Shameless ripoff of Park Studio's one look :P
 * 	07.12.13		1.0		Mr.doob			+ First version
 **/
package cn.itamt.utils.inspector.plugins.stats {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	public class Stats extends Sprite {
		private var graph : BitmapData;
		private var format : TextFormat;
		private var fpsText : TextField;
		private var msText : TextField;
		private var memText : TextField;
		private var fs : Number = 0;
		private var fps : Number = 0;
		private var timer : Number = 0;
		private var ms : Number = 0;
		private var msPrev : Number = 0;
		private var mem : Number = 0;

		public function Stats():void {
			graph = new BitmapData(70, 50, false, 0x333);
			var gBitmap : Bitmap = new Bitmap(graph);
			gBitmap.y = 35;
			addChild(gBitmap);

			format = new TextFormat("_sans", 9);

			graphics.beginFill(0x333)
			graphics.drawRect(0, 0, 70, 50)
			graphics.endFill()

			fpsText = new TextField();
			fpsText.width = 60;
			fpsText.selectable = false;
			fpsText.textColor = 0xFFFF00;
			fpsText.text = "FPS: ";
			fpsText.setTextFormat(format);
			addChild(fpsText);

			msText = new TextField();
			msText.width = 60;
			msText.y = 10;
			msText.selectable = false;
			msText.textColor = 0x00FF00;
			msText.text = "MS: ";
			msText.setTextFormat(format);
			addChild(msText);

			memText = new TextField();
			memText.width = 60;
			memText.y = 20;
			memText.selectable = false;
			memText.textColor = 0x00FFFF;
			memText.text = "MEM: ";
			memText.setTextFormat(format);
			addChild(memText);

			fpsText.height = msText.height = memText.height = 20;

			addEventListener(MouseEvent.CLICK, mouseHandler);
			addEventListener(Event.ENTER_FRAME, update);
		}

		private function mouseHandler(e : MouseEvent):void {
			if (this.mouseY > this.height * .35)
				stage.frameRate--
			else
				stage.frameRate++

			fpsText.text = "FPS: " + fps + " / " + stage.frameRate;
			fpsText.setTextFormat(format);
		}

		private function update(e : Event):void {
			timer = getTimer();

			++fs;

			if( timer - 1000 > msPrev ) {
				msPrev = timer;

				var fsGraph : Number = Math.min(50, 50 / stage.frameRate * fs);
				fps = Math.min(stage.frameRate, fs);

				mem = Number((System.totalMemory / 1048576).toFixed(3));

				var memGraph : Number = Math.min(50, Math.sqrt(Math.sqrt(mem * 5000))) - 2;

				graph.scroll(1, 0);
				graph.fillRect(new Rectangle(0, 0, 1, graph.height), 0x333);
				graph.setPixel(0, graph.height - fsGraph, 0xFFFF00);
				graph.setPixel(0, graph.height - ((timer - ms) * .5 << 0), 0x00FF00);
				graph.setPixel(0, graph.height - memGraph, 0x00FFFF);

				fpsText.text = "FPS: " + fps + " / " + stage.frameRate;
				fpsText.setTextFormat(format);

				memText.text = "MEM: " + mem;
				memText.setTextFormat(format);

				fs = 0;
			}

			msText.text = "MS: " + (timer - ms);
			msText.setTextFormat(format);
			ms = timer;
		}
	}
}