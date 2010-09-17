package msc.display {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 支持9格缩放的位图
	 * @author itamt[at]qq.com
	 */
	public class Scale9GridBitmap extends Bitmap {
		private var _scale9Grid : Rectangle;
		private var _originalBmd : BitmapData;

		private var _w : Number;
		private var _h : Number;

		private var _tl : BitmapData;
		private var _tc : BitmapData;
		private var _tr : BitmapData;
		private var _ml : BitmapData;
		private var _mc : BitmapData;
		private var _mr : BitmapData;
		private var _bl : BitmapData;		private var _bc : BitmapData;		private var _br : BitmapData;

		public function Scale9GridBitmap(bitmapData : BitmapData = null, scale9Grid : Rectangle = null, pixelSnapping : String = "auto", smoothing : Boolean = false) {
			super(bitmapData.clone(), pixelSnapping, smoothing);
			
			_originalBmd = bitmapData.clone();
			_w = _originalBmd.width;
			_h = _originalBmd.height;
			
			this.scale9Grid = scale9Grid;
		}

		/**
		 * 把一个9格矩形校正
		 */
		private function correctGridRect(rect : Rectangle) : Rectangle {
			var minMargin : uint = 1;
			if(rect.left < 1)rect.left = minMargin;			if(rect.top < 1)rect.top = minMargin;
			if(rect.right > _originalBmd.width - minMargin)rect.right = _originalBmd.width - minMargin; 			if(rect.bottom > _originalBmd.height - minMargin)rect.bottom = _originalBmd.height - minMargin; 
			return rect;
		}

		/**
		 * 根据当前的9格矩形计算出9格的位图数据
		 */
		private function build9GridBmds() : void {
			if(_tl != null)_tl.dispose();			if(_tc != null)_tc.dispose();			if(_tr != null)_tr.dispose();			if(_ml != null)_ml.dispose();			if(_mc != null)_mc.dispose();			if(_mr != null)_mr.dispose();			if(_bl != null)_bl.dispose();			if(_bc != null)_bc.dispose();			if(_br != null)_br.dispose();
			
			//顶三格的位图数据
			_tl = new BitmapData(_scale9Grid.x, _scale9Grid.y);
			_tl.copyPixels(_originalBmd, new Rectangle(0, 0, _scale9Grid.x, _scale9Grid.y), new Point());
			_tc = new BitmapData(_scale9Grid.width, _scale9Grid.y);
			_tc.copyPixels(_originalBmd, new Rectangle(_scale9Grid.x, 0, _scale9Grid.width, _scale9Grid.y), new Point());	
			_tr = new BitmapData(_originalBmd.width - _scale9Grid.right, _scale9Grid.y);
			_tr.copyPixels(_originalBmd, new Rectangle(_scale9Grid.right, 0, _originalBmd.width - _scale9Grid.right, _scale9Grid.y), new Point());
			
			//中三格的位图数据
			_ml = new BitmapData(_scale9Grid.x, _scale9Grid.height);
			_ml.copyPixels(_originalBmd, new Rectangle(0, _scale9Grid.y, _scale9Grid.x, _scale9Grid.height), new Point());
			_mc = new BitmapData(_scale9Grid.width, _scale9Grid.height);
			_mc.copyPixels(_originalBmd, _scale9Grid, new Point());
			_mr = new BitmapData(_originalBmd.width - _scale9Grid.right, _scale9Grid.height);
			_mr.copyPixels(_originalBmd, new Rectangle(_scale9Grid.right, _scale9Grid.y, _originalBmd.width - _scale9Grid.right, _scale9Grid.height), new Point());
			
			//底三格的位图数据
			_bl = new BitmapData(_scale9Grid.x, _originalBmd.height - _scale9Grid.bottom);
			_bl.copyPixels(_originalBmd, new Rectangle(0, _scale9Grid.bottom, _scale9Grid.x, _originalBmd.height - _scale9Grid.bottom), new Point());
			_bc = new BitmapData(_scale9Grid.width, _originalBmd.height - _scale9Grid.bottom);
			_bc.copyPixels(_originalBmd, new Rectangle(_scale9Grid.x, _scale9Grid.bottom, _scale9Grid.width, _originalBmd.height - _scale9Grid.bottom), new Point());
			_br = new BitmapData(_originalBmd.width - _scale9Grid.right, _originalBmd.height - _scale9Grid.bottom);
			_br.copyPixels(_originalBmd, new Rectangle(_scale9Grid.right, _scale9Grid.bottom, _originalBmd.width - _scale9Grid.right, _originalBmd.height - _scale9Grid.bottom), new Point());
		}

		private function draw() : void {
			this.bitmapData.dispose();
			this.bitmapData = new BitmapData(_w, _h, true, 0x00ffffff);
			
			
			//顶三格的绘制
			this.bitmapData.draw(_tl);			this.bitmapData.draw(_tc, new Matrix((_w - _tl.width - _tr.width) / _tc.width, 0, 0, 1, _tl.width), null, null, new Rectangle(_tl.width, 0, _w - _tl.width - _tr.width, _tl.height));			this.bitmapData.draw(_tr, new Matrix(1, 0, 0, 1, _w - _tr.width), null, null, new Rectangle(_w - _tr.width, 0, _tr.width, _tr.height));
						
			//中三格的绘制
			this.bitmapData.draw(_ml, new Matrix(1, 0, 0, (_h - _tl.height - _bl.height) / _ml.height, 0, _tl.height), null, null, new Rectangle(0, _tl.height, _ml.width, _h - _tl.height - _bl.height));
			this.bitmapData.draw(_mc, new Matrix((_w - _tl.width - _tr.width) / _tc.width, 0, 0, (_h - _tl.height - _bl.height) / _ml.height, _tl.width, _tc.height), null, null, new Rectangle(_tl.width, _tl.height, _w - _tl.width - _tr.width, _h - _tl.height - _bl.height));
			this.bitmapData.draw(_mr, new Matrix(1, 0, 0, (_h - _tr.height - _br.height) / _mr.height, _w - _mr.width, _tr.height), null, null, new Rectangle(_w - _mr.width, _tr.height, _mr.width, _h - _tr.height - _br.height));
						
			//底三格的绘制
			this.bitmapData.draw(_bl, new Matrix(1, 0, 0, 1, 0, _h - _bl.height), null, null, new Rectangle(0, _h - _bl.height, _bl.width, _bl.height));
			this.bitmapData.draw(_bc, new Matrix((_w - _bl.width - _br.width) / _bc.width, 0, 0, 1, _bl.width, _h - _bl.height), null, null, new Rectangle(_bl.width, _h - _bl.height, _w - _bl.width - _br.width, _bc.height));
			this.bitmapData.draw(_br, new Matrix(1, 0, 0, 1, _w - _br.width, _h - _br.height), null, null, new Rectangle(_w - _br.width, _h - _br.height, _br.width, _br.height));
		}

		//////////////////////////////////////
		////////////override funcions/////////
		//////////////////////////////////////
		override public function set width(val : Number) : void {
			_w = val;	
			draw();
		}

		override public function set height(val : Number) : void {
			_h = val;
			draw();
		}

		override public function set scale9Grid(rect : Rectangle) : void {
			_scale9Grid = correctGridRect(rect);
			
			super.scale9Grid = _scale9Grid;
			
			this.build9GridBmds();
			this.draw();
		}
	}
}
