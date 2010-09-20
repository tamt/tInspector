package msc.commands {
	import org.robotlegs.mvcs.Command;

	import flash.display.StageScaleMode;

	/**
	 * 注意这个Command是和RobotLegs配套使用的。
	 * @author itamt[at]qq.com
	 */
	public class ConfigStageCommand extends Command {
		override public function execute() : void {
			contextView.stage.scaleMode = StageScaleMode.NO_SCALE;
		}
	}
}
