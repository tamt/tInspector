package {
	import cn.itamt.dedo.DedoProject;
	import cn.itamt.dedo.data.DMapBlocksCollection;
	import cn.itamt.dedo.data.DMapCharactersCollection;
	import cn.itamt.dedo.data.DMapOrientation;
	import cn.itamt.dedo.factory.DedoProjectFactory;
	import cn.itamt.dedo.manager.AnimationsManager;
	import cn.itamt.dedo.parser.IIXParser;
	import cn.itamt.dedo.parser.TileMapperParser;
	import cn.itamt.dedo.render.DedoRenderEngine;
	import cn.itamt.keyboard.Shortcut;
	import cn.itamt.keyboard.ShortcutEvent;
	import cn.itamt.keyboard.ShortcutManager;

	import msc.input.KeyCode;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;



	/**
	 * @author itamt[at]qq.com
	 */
	[SWF(backgroundColor="#000000", frameRate="30", width="800", height="480")]
	public class DedoDemo extends Sprite {
		private var project : DedoProject;
		private var renderer : DedoRenderEngine;
		private var canvas : Sprite;

		public function DedoDemo() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			// load an dedo.xml file.
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onXMLLoaded);
			// loader.load(new URLRequest("dedo.xml"));

			var iixLoader : URLLoader = new URLLoader();
			iixLoader.dataFormat = URLLoaderDataFormat.BINARY;
			iixLoader.addEventListener(Event.COMPLETE, onIIXLoaded);
			iixLoader.load(new URLRequest("nDedo.iix"));

			// init render engine.
			renderer = new DedoRenderEngine();
			canvas = new Sprite();
			// canvas.x = canvas.y = 100;
			addChild(this.canvas);

			var shortcutMgr : ShortcutManager = new ShortcutManager();
			shortcutMgr.setStage(this.stage);
			shortcutMgr.registerShortcut(new Shortcut([KeyCode.W]));
			shortcutMgr.registerShortcut(new Shortcut([KeyCode.W, KeyCode.A]));
			shortcutMgr.registerShortcut(new Shortcut([KeyCode.W, KeyCode.D]));
			shortcutMgr.registerShortcut(new Shortcut([KeyCode.S]));
			shortcutMgr.registerShortcut(new Shortcut([KeyCode.S, KeyCode.A]));
			shortcutMgr.registerShortcut(new Shortcut([KeyCode.S, KeyCode.D]));
			shortcutMgr.registerShortcut(new Shortcut([KeyCode.A]));
			shortcutMgr.registerShortcut(new Shortcut([KeyCode.D]));
			// shortcutMgr.addEventListener(ShortcutEvent.FIRE, scrollMap);
			shortcutMgr.addEventListener(ShortcutEvent.FIRE, moveCharacter);
			shortcutMgr.start();

			// this.addChild(new Stats());
		}

		private function scrollMap(event : ShortcutEvent) : void {
			var speed : uint = 32;
			if(event.shortcut.equalKeys([KeyCode.W])) {
				this.renderer.scroll(0, speed);
			} else if(event.shortcut.equalKeys([KeyCode.S])) {
				this.renderer.scroll(0, -speed);
			} else if(event.shortcut.equalKeys([KeyCode.A])) {
				this.renderer.scroll(speed, 0);
			} else if(event.shortcut.equalKeys([KeyCode.D])) {
				this.renderer.scroll(-speed, 0);
			} else if(event.shortcut.equalKeys([KeyCode.W, KeyCode.A])) {
				this.renderer.scroll(speed, speed);
			} else if(event.shortcut.equalKeys([KeyCode.W, KeyCode.D])) {
				this.renderer.scroll(-speed, speed);
			} else if(event.shortcut.equalKeys([KeyCode.S, KeyCode.A])) {
				this.renderer.scroll(speed, -speed);
			} else if(event.shortcut.equalKeys([KeyCode.S, KeyCode.D])) {
				this.renderer.scroll(-speed, -speed);
			}
		}

		private var distanceX : Number = 0;
		private var distanceY : Number = 0;
		private var speed : Number = .2;
		private var moveOri : uint;

		private function moveCharacter(event : ShortcutEvent):void {
			if(Math.abs(distanceX)) {
				return;
			}
			if(Math.abs(distanceY)) {
				return;
			}

			distanceX = distanceY = 0;

			if(event.shortcut.equalKeys([KeyCode.W])) {
				moveOri = DMapOrientation.UP;
				distanceY = -1;
			} else if(event.shortcut.equalKeys([KeyCode.S])) {
				moveOri = DMapOrientation.DOWN;
				distanceY = 1;
			} else if(event.shortcut.equalKeys([KeyCode.A])) {
				moveOri = DMapOrientation.LEFT;
				distanceX = -1;
			} else if(event.shortcut.equalKeys([KeyCode.D])) {
				moveOri = DMapOrientation.RIGHT;
				distanceX = 1;
			}

			// 阻挡格数据
			var blocks : DMapBlocksCollection = project.mapsMgr.getMap(0).blocks;
			var charas : DMapCharactersCollection = project.mapsMgr.getMap(0).characters;
			var anisMgr : AnimationsManager = this.project.animationsMgr;
			var posX : uint = charas.getCharacterX(0);
			var posY : uint = charas.getCharacterY(0);
			var isOutside : Boolean = (posX + distanceX < 0) || ((posX + distanceX) > project.mapsMgr.getMap(0).cellsx - 1) || (posY + distanceY < 0) || ((posY + distanceY) > project.mapsMgr.getMap(0).cellsy - 1);

			if(isOutside || blocks.getPosIsBlock(posX + distanceX, posY + distanceY)) {
				charas.setCharacterFrame(0, anisMgr.getCharacterFrameByOrien(charas.getCharacterImg(0), moveOri));
				distanceX = distanceY = 0;
			}
		}

		private function onEnterFrame(event : Event) : void {
			var charas : DMapCharactersCollection = project.mapsMgr.getMap(0).characters;
			var anisMgr : AnimationsManager = this.project.animationsMgr;
			var moveOriFrameOffset : Number;
			var scrollX : Number = 0, scrollY : Number = 0;
			if(distanceX > 0) {
				distanceX -= speed;
				scrollX = -speed;

				charas.setCharacterX(0, charas.getCharacterX(0) + speed);
				moveOriFrameOffset = distanceX;
			} else if(distanceX < 0) {
				distanceX += speed;
				scrollX = speed;
				charas.setCharacterX(0, charas.getCharacterX(0) - speed);

				moveOriFrameOffset = -distanceX;
			}

			if(distanceY > 0) {
				distanceY -= speed;
				scrollY = -speed;
				charas.setCharacterY(0, charas.getCharacterY(0) + speed);

				moveOriFrameOffset = distanceY;
			} else if(distanceY < 0) {
				distanceY += speed;
				scrollY = speed;
				charas.setCharacterY(0, charas.getCharacterY(0) - speed);

				moveOriFrameOffset = -distanceY;
			}

			if(Math.abs(distanceX) < speed) {
				charas.setCharacterX(0, Math.round(charas.getCharacterX(0)));
			}
			if(Math.abs(distanceY) < speed) {
				charas.setCharacterY(0, Math.round(charas.getCharacterY(0)));
			}

			if(distanceX || distanceY) {
				this.renderer.updateCharacters();

				charas.setCharacterFrame(0, anisMgr.getCharacterFrameByOrien(charas.getCharacterImg(0), moveOri, moveOriFrameOffset));
			}

			if(Math.abs(distanceX) < speed) {
				distanceX = 0;
				if(moveOri == DMapOrientation.LEFT || moveOri == DMapOrientation.RIGHT)
					charas.setCharacterFrame(0, anisMgr.getCharacterFrameByOrien(charas.getCharacterImg(0), moveOri));
			}

			if(Math.abs(distanceY) < speed) {
				distanceY = 0;
				if(moveOri == DMapOrientation.UP || moveOri == DMapOrientation.DOWN)
					charas.setCharacterFrame(0, anisMgr.getCharacterFrameByOrien(charas.getCharacterImg(0), moveOri));
			}

			// if(scrollX || scrollY) {
			//				//  移动方式, 是地图移动还是人物移动.
			// var posX : uint = charas.getCharacterX(0);
			// var posY : uint = charas.getCharacterY(0);
			// if(this.renderer.getViewArea().left >= 0 && this.renderer.getViewArea().right <= this.project.mapsMgr.getMap(0).cellwidth)
			// scrollX = 0;
			// if(this.renderer.getViewArea().top >= 0 && this.renderer.getViewArea().bottom <= this.project.mapsMgr.getMap(0).cellheight)
			// scrollY = 0;
			// if(scrollX || scrollY)
			// this.renderer.scroll(scrollX * 32, scrollY * 32);
			// }
		}

		private function onXMLLoaded(evt : Event) : void {
			var xml : XML = new XML((evt.target as URLLoader).data);
			var factory : DedoProjectFactory = new DedoProjectFactory();
			project = factory.createProjectUseParser(xml, new TileMapperParser());

			// render map on the canvas.
			this.renderer.setViewPort(this.canvas, 800, 480);
			this.renderer.render(project.mapsMgr.getMap(0), project);
			this.renderer.start();
		}

		private function onIIXLoaded(evt : Event) : void {
			var iix : ByteArray = (evt.target as URLLoader).data as ByteArray;
			var factory : DedoProjectFactory = new DedoProjectFactory();
			var parser : IIXParser = new IIXParser();
			project = factory.createProjectUseParser(iix, parser);

			this.renderer.setResourceManager(parser.resourceManager());
			// render map on the canvas.
			this.renderer.setViewPort(this.canvas, 800, 480);
			this.renderer.render(project.mapsMgr.getMap(0), project);
			this.renderer.start();

			// var posX : uint = project.mapsMgr.getMap(0).characters.getCharacterX(0);
			// var posY : uint = project.mapsMgr.getMap(0).characters.getCharacterY(0);
			// this.renderer.scroll(-32 * (posX - this.renderer.getViewArea().width / 2), -32 * (posY - this.renderer.getViewArea().height / 2));

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}
}
