package cn.itamt.utils.inspector.plugins.game
{
	import As3Math.geo2d.amPoint2d;
	import As3Math.geo2d.amVector2d;

	import QuickB2.misc.acting.qb2FlashSpriteActor;
	import QuickB2.objects.tangibles.qb2Body;
	import QuickB2.objects.tangibles.qb2World;
	import QuickB2.stock.qb2StageWalls;
	import QuickB2.stock.qb2Stock;

	import cn.itamt.utils.inspector.core.BaseInspectorPlugin;
	import cn.itamt.utils.inspector.core.IInspector;
	import cn.itamt.utils.inspector.core.InspectTarget;
	import cn.itamt.utils.inspector.plugins.InspectorPluginId;
	import cn.itamt.utils.inspector.ui.InspectorIconButton;
	import cn.itamt.utils.inspector.ui.InspectorStageReference;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author tamt
	 */
	public class AngryBird extends BaseInspectorPlugin
	{
		[Embed(source="angrybird_23.png")]
		private var ICON : Class;
		private var worldView : Sprite;
		private var world : qb2World;
		private var stage : Stage;

		public function AngryBird()
		{
			super();
			_icon = new InspectorIconButton(new ICON().bitmapData);
		}

		override public function onRegister(inspector : IInspector) : void
		{
			super.onRegister(inspector);
			stage = InspectorStageReference.entity;

			if (!worldView)
			{
				worldView = new Sprite();
				InspectorStageReference.entity.addChild(worldView);
			}

			world = qb2Stock.newDebugWorld(new amVector2d(0, 10), null, InspectorStageReference.entity);

			world.realtimeUpdate = true;
			world.maximumRealtimeStep = 1.0 / 10.0
			// make it so a simulation step is never longer than this.
			world.gravity.y = 10;
			world.defaultPositionIterations = 10;
			world.defaultVelocityIterations = 10;
			world.start();

			var walls : qb2StageWalls = new qb2StageWalls(InspectorStageReference.entity);
			world.addObject(walls);
		}

		override public function onActive() : void
		{
			super.onActive();

			if (_inspector.getCurInspectTarget()) this.breakIt(_inspector.getCurInspectTarget().displayObject);
		}

		private function breakIt(target : DisplayObject) : void
		{
			if (target && target.visible)
			{
				if (target is DisplayObjectContainer)
				{
					if (this.getChildHasChildren(target))
					{
						var container : DisplayObjectContainer = target as DisplayObjectContainer;
						for (var i : int = 0;i < container.numChildren;i++)
						{
							var child : DisplayObject = container.getChildAt(i);
							if (child is DisplayObjectContainer)
							{
								breakIt(child);
							}
						}
					}
					else
					{
						var pos : Point = target.localToGlobal(new Point(0, 0));
						var body : qb2Body = buildWrapper(target);
						body.position.x = pos.x;
						body.position.y = pos.y;

						world.addObject(body);

						target.visible = false;
						
						//
						if(target != _inspector.getCurInspectTarget().displayObject && target.parent && !(target.parent is Stage)){
							this.breakIt(target.parent);
						}
					}
				}
				else
				{
					var pos : Point = target.localToGlobal(new Point(0, 0));
					var body : qb2Body = buildWrapper(target);
					body.position.x = pos.x;
					body.position.y = pos.y;

					world.addObject(body);

					target.visible = false;
				}
			}
		}

		/**
		 * 查找显示对象内拥有Children的Child
		 */
		private function getChildHasChildren(target : DisplayObject) : DisplayObjectContainer
		{
			if (target && target.visible && target is DisplayObjectContainer)
			{
				var container : DisplayObjectContainer = target as DisplayObjectContainer;
				for (var i : int = 0; i < container.numChildren; i++)
				{
					var child:DisplayObject = container.getChildAt(i);
					if (child.visible && child is DisplayObjectContainer)
					{
						return child as DisplayObjectContainer;
					}
				}
			}
			return null;
		}

		override public function onInspect(target : InspectTarget) : void
		{
			super.onInspect(target);
		}

		private function buildWrapper(dp : DisplayObject) : qb2Body
		{
			var bmd : BitmapData = this.snap(dp);
			var bmp : Bitmap = new Bitmap(bmd);
			var wrapper : qb2FlashSpriteActor = new qb2FlashSpriteActor();
			wrapper.addChild(bmp);
			stage.addChild(wrapper);
			dp.visible = false;
			var body : qb2Body = new qb2Body();
			body.actor = wrapper;
			body.addObject(qb2Stock.newRectShape(new amPoint2d(Math.random() * bmp.width, Math.random() * bmp.height), bmp.width, bmp.height, 1));
			body.mass = 1;

			return body;
		}

		protected function snap(dp : DisplayObject) : BitmapData
		{
			var bmd : BitmapData;
			var bounds : Rectangle = dp.getBounds(dp);
			bmd = new BitmapData(bounds.width, bounds.height, true, 0x00ff0000);
			bmd.draw(dp, new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y), null, null, null, true);
			return bmd;
		}

		override public function getPluginId() : String
		{
			return 'AngryBird';
		}

		override public function onUnActive() : void
		{
			super.onUnActive();
			if (worldView)
			{
				if (worldView.parent) worldView.parent.removeChild(worldView);
				worldView = null;
			}
		}
	}
}
