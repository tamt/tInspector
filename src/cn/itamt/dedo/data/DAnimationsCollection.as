package cn.itamt.dedo.data {
	/**
	 * @author itamt[at]qq.com
	 */
	public class DAnimationsCollection extends DCollection {
		private var _ids : Vector.<uint>;
		private var _names : Vector.<String>;
		private var _types : Vector.<uint>;
		private var _delays : Vector.<uint>;
		private var _tiles : Vector.<Vector.<uint>>;

		public function DAnimationsCollection() {
			super();

			_ids = new Vector.<uint>();
			_names = new Vector.<String>();
			_types = new Vector.<uint>();
			_delays = new Vector.<uint>();
			_tiles = new Vector.<Vector.<uint>>();
		}

		public function setAnimation(index : uint, id : uint, name : String, type : uint, delay : uint, frames : Vector.<uint>):void {
			_ids 	[index] = id;
			_names  [index] = name;
			_types  [index] = type;
			_delays [index] = delay;
			_tiles  [index] = frames;
		}

		public function getAnimation():void {
		}
	}
}
