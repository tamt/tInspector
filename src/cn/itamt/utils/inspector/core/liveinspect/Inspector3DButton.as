package cn.itamt.utils.inspector.core.liveinspect
{
	import cn.itamt.utils.inspector.lang.InspectorLanguageManager;
	import cn.itamt.utils.inspector.ui.InspectorButton;

	import flash.display.DisplayObject;
	import flash.display.Shape;

	/**
	 * @author tamt
	 */
	public class Inspector3DButton extends InspectorButton
	{
		public function Inspector3DButton():void
		{
			super();

			_tip=InspectorLanguageManager.getStr('Transform3D');
		}

		override protected function buildOverState():DisplayObject
		{
			var sp:Shape=new Shape();
			with (sp)
			{
				// 背景
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();

				graphics.lineStyle(3, 0x99cc00);
				graphics.moveTo(11.500000, 13.800000);
				graphics.lineTo(5.000000, 17.200000);
				graphics.lineTo(11.200000, 13.200000);
				graphics.lineTo(11.550000, 5.850000);
				graphics.lineTo(11.850000, 13.250000);
				graphics.lineTo(18.050000, 17.200000);
				graphics.lineTo(11.500000, 13.800000);
			}
			return sp;
		}

		override protected function buildDownState():DisplayObject
		{
			var sp:Shape=new Shape();
			with (sp)
			{
				// 背景
				graphics.beginFill(0, 1);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();

				graphics.lineStyle(3, 0xffffff);
				graphics.moveTo(11.500000, 13.800000);
				graphics.lineTo(5.000000, 17.200000);
				graphics.lineTo(11.200000, 13.200000);
				graphics.lineTo(11.550000, 5.850000);
				graphics.lineTo(11.850000, 13.250000);
				graphics.lineTo(18.050000, 17.200000);
				graphics.lineTo(11.500000, 13.800000);
			}
			return sp;
		}

		override protected function buildUpState():DisplayObject
		{
			var sp:Shape=new Shape();
			with (sp)
			{

				// 背景
				graphics.beginFill(0, 0);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();

				graphics.lineStyle(3, 0xffffff);
				graphics.moveTo(11.500000, 13.800000);
				graphics.lineTo(5.000000, 17.200000);
				graphics.lineTo(11.200000, 13.200000);
				graphics.lineTo(11.550000, 5.850000);
				graphics.lineTo(11.850000, 13.250000);
				graphics.lineTo(18.050000, 17.200000);
				graphics.lineTo(11.500000, 13.800000);
			}
			return sp;
		}

		override protected function buildUnenabledState():DisplayObject
		{
			var sp:Shape=new Shape();
			with (sp)
			{

				// 背景
				graphics.beginFill(0, 0);
				graphics.drawRoundRect(0, 0, 23, 23, 10, 10);
				graphics.endFill();

				graphics.lineStyle(3, 0x000000);
				graphics.moveTo(11.500000, 13.800000);
				graphics.lineTo(5.000000, 17.200000);
				graphics.lineTo(11.200000, 13.200000);
				graphics.lineTo(11.550000, 5.850000);
				graphics.lineTo(11.850000, 13.250000);
				graphics.lineTo(18.050000, 17.200000);
				graphics.lineTo(11.500000, 13.800000);
			}
			return sp;
		}
	}
}
