package cn.itamt.dedo.factory {
	import cn.itamt.dedo.DedoProject;
	import cn.itamt.dedo.parser.IDedoParser;

	/**
	 * @author itamt[at]qq.com
	 */
	public class DedoProjectFactory {

		public function DedoProjectFactory() : void {
		}

		public function create() : DedoProject {
			var project : DedoProject = new DedoProject();
			return project;
		}

		public function createProjectUseParser(parser : IDedoParser) : DedoProject {
			return create();
		}
	}
}