package cn.itamt.dedo.factory {
	import cn.itamt.dedo.DedoProject;
	import cn.itamt.dedo.manager.AnimationsManager;
	import cn.itamt.dedo.manager.BrushesManager;
	import cn.itamt.dedo.manager.MapsManager;
	import cn.itamt.dedo.manager.TilesManager;
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

		public function createProjectUseParser(data : *, parser : IDedoParser) : DedoProject {
			var project : DedoProject = new DedoProject();
			
			parser.parse(data);
			
			project.name = parser.getProjectName();
			project.version = parser.getProjectVersion();
			project.cellwidth = parser.getProjectCellWidth();			project.cellheight = parser.getProjectCellHeight();
			project.tilesMgr = new TilesManager();
			project.mapsMgr = new MapsManager();
			project.brushesMgr = new BrushesManager();
			project.animationsMgr = new AnimationsManager();
			
			return project;
		}
	}
}