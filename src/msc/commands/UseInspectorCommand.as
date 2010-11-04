package msc.commands {
	import cn.itamt.utils.Inspector;

	import org.robotlegs.mvcs.Command;

	/**
	 * 注意这个Command是和RobotLegs配套使用的。
	 * @author itamt@qq.com
	 */
	public class UseInspectorCommand extends Command {
		override public function execute() : void {
			Inspector.getInstance().init(contextView);
		}
	}
}
