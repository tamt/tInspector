package cn.itamt.dopin {
	import flash.display.BitmapData;
	import flash.filters.BitmapFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;	

	/**
	 * Dopin的位图数据.
	 * @author tamt
	 */
	internal class DopinData {
		private var _originalBmd : BitmapData;

		//原始的位图数据.
		public function get originalBmd() : BitmapData {
			return _originalBmd;
		}

		internal var bmd : BitmapData;

		public function DopinData(originalBmd : BitmapData) {
			_originalBmd = originalBmd;
			bmd = _originalBmd.clone();
		}

		internal function setOriginalBmd(bmd : BitmapData) : void {
			this._originalBmd = bmd;
		}

		internal function setBmd(bmd : BitmapData) : void {
			this.bmd = bmd;
		}

		public function get width() : int {
			return bmd.width;
		}

		public function get height() : int {
			return bmd.height;
		}

		//原始位图和最终成像位图直接的偏移量.(使用滤镜而产生).
		private var _offsetX : int;

		public function get offsetX() : int {
			return _offsetX;
		}

		private var _offsetY : int;

		public function get offsetY() : int {
			return _offsetY;
		}

		/**
		 * 应用滤镜
		 * @return	Boolean		beResized	应用滤镜后, 是否发生了大小变化.
		 */
		internal function applyFilter(filter : BitmapFilter) : Boolean {
			var beResized : Boolean;
			
			var rect : Rectangle = bmd.generateFilterRect(bmd.rect, filter);
			var nbmd : BitmapData;
			if(rect.width > bmd.width || rect.height > bmd.height) {
				nbmd = bmd.clone();
				bmd.dispose();
				bmd = new BitmapData(rect.width, rect.height, true, 0x00ffffff);
				bmd.copyPixels(nbmd, nbmd.rect, new Point(-rect.x, -rect.y), null, null, true);
				bmd.applyFilter(nbmd, nbmd.rect, new Point(-rect.x, -rect.y), filter);
				nbmd.dispose();
				this._offsetX += -rect.x;
				this._offsetY += -rect.y;
				
				beResized = true;
			} else {
				bmd.applyFilter(bmd, bmd.rect, new Point(0, 0), filter);
			}
			
			return beResized;
		}

		//滤镜数组
		private var _filters : Array;

		/**
		 * 应用多个滤镜
		 */
		internal function applyFilters(value : Array = null) : void {
			this.reset();
			this._filters = value;
			if(this._filters) {
				var l : int = this._filters.length;
				for(var i : int = 0;i < l; i++) {
					if(this._filters[i] is BitmapFilter)this.applyFilter(this._filters[i]);
				}
			}
		}

		internal function reset() : void {
			this._offsetX = 0;
			this._offsetY = 0;
			bmd.dispose();
			bmd = originalBmd.clone();
		}

		public function resetRect() : void {
		}

		/**
		 * 销毁对象, 释放内存.
		 */
		public function dispose() : void {
			this._originalBmd.dispose();
			this.bmd.dispose();
		}
	}
}
