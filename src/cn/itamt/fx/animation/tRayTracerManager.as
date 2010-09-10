package cn.itamt.fx.animation {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;	

	/**
	 * 管理tRayTracer
	 * @author itamt@qq.com
	 */
	public class tRayTracerManager {

		private var srcInstanceMap : Dictionary = new Dictionary();

		private static var _instance : tRayTracerManager;

		public static function getInstance() : tRayTracerManager {
			if(_instance == null)_instance = new tRayTracerManager(new SingletonEnforcer);
			return _instance;
		}

		public function tRayTracerManager(se : SingletonEnforcer) : void {
		}

		public function buildRayTracer(obj : DisplayObject, leg : uint = 0) : tRayTracer {
			
			//-------------------------
			/*
			 * 此段代码的目的是处理动画循环播放时, 同一个src被不断tRayTracer的问题.
			 */
			if(srcInstanceMap[obj]) {
				(srcInstanceMap[obj] as tRayTracer).endAtPrevPoint();
			}
			//--------------------------

			var tracer : tRayTracer = new tRayTracer(obj, leg);
			tracer.addEventListener(Event.COMPLETE, onTracerComplete, false, 0, true);
			srcInstanceMap[obj] = tracer;
			
			return tracer;
		}

		private function onTracerComplete(evt : Event) : void {
			var tracer : tRayTracer = evt.target as tRayTracer;
			if(tracer.parent) {
				tracer.parent.removeChild(tracer);
			}
			tracer.removeEventListener(Event.COMPLETE, onTracerComplete);
			tracer.dispose();
			
			delete srcInstanceMap[tracer];
			
			tracer = null;
		}

		public function dispose() : void {
			srcInstanceMap = null;
		}
	}
}

class SingletonEnforcer {
}