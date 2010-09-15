package cn.itamt.dedo {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;

	/**
	 * @author itamt[at]qq.com
	 */
	public class DedoRendererEngine {

		protected var bgBmd : BitmapData;

		public const cos : Number = Math.cos(26.565 * Math.PI / 180);
		public const sin : Number = Math.sin(26.565 * Math.PI / 180);
		public var s : Number;

		public function DedoRendererEngine() : void {
		}

		public function setBg(bmd : BitmapData) : void {
			bgBmd = bmd;
			s = Math.sqrt(bmd.width * bmd.width + bmd.height * bmd.height) / 2;
		}

		public function render(dedo : Dedo, view : Sprite) : void {
			for(var j : int = 0;j < dedo.coords.height;j++) {
				for(var i : int = 0;i < dedo.coords.width;i++) {
					var tile : Bitmap = new Bitmap(bgBmd);
					tile.x = transX(i, j, dedo.coords.get(i, j));
					tile.y = transY(i, j, dedo.coords.get(i, j));
					view.addChild(tile);
				}
			}
		}

		public function transX(posX : uint, posY : uint, posZ : uint = 0) : Number {
			return (posX - posY) * cos * s;
		}

		public function transY(posX : uint, posY : uint, posZ : uint = 0) : Number {
			return (posX + posY - posZ) * sin * s;
		}
	}
}
