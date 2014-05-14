package {
import cn.itamt.utils.Inspector;
import cn.itamt.utils.inspector.core.liveinspect.LiveInspectView;
import cn.itamt.utils.inspector.core.propertyview.PropertiesView;
import cn.itamt.utils.inspector.core.structureview.StructureView;
import cn.itamt.utils.inspector.plugins.contextmenu.InspectorRightMenu;
import cn.itamt.utils.inspector.plugins.controlbar.ControlBar;
import cn.itamt.utils.inspector.plugins.deval.DEval;
import cn.itamt.utils.inspector.plugins.deval.DEvalPanel;
import cn.itamt.utils.inspector.plugins.fullscreen.FullScreen;
import cn.itamt.utils.inspector.plugins.gerrorkeeper.GlobalErrorKeeper;
import cn.itamt.utils.inspector.plugins.stats.AppStats;
import cn.itamt.utils.inspector.plugins.swfinfo.SwfInfoView;
import cn.itamt.utils.inspector.plugins.tfm3d.Transform3DController;
import cn.itamt.utils.inspector.plugins.tilt.Tilt;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.system.Security;

/**
 * @author itamt@qq.com
 */
public class tInspectorDemo extends Sprite {
    public function tInspectorDemo() {
        Security.allowDomain("*");

        this.stage.scaleMode = StageScaleMode.NO_SCALE;
        this.stage.align = StageAlign.RIGHT;

        //
        var sp:Sprite = new Sprite();
        sp.graphics.lineStyle(1, 0x00);
        sp.graphics.beginFill(0x770033);
        sp.graphics.drawRect(100, 100, 200, 200);
        sp.graphics.endFill();
        addChild(sp);

        var bar:ControlBar = new ControlBar();
        addChild(bar);

        Inspector.getInstance().init(this);
        var liveInspect:LiveInspectView = new LiveInspectView();
        liveInspect.use3DTransformer(new Transform3DController);
        var property:PropertiesView = new PropertiesView();
        var struct:StructureView = new StructureView();
        var deval:DEvalPanel = new DEvalPanel();
        DEval;

        Inspector.getInstance().pluginManager.registerPlugin(struct);
        Inspector.getInstance().pluginManager.registerPlugin(liveInspect);
        Inspector.getInstance().pluginManager.registerPlugin(property);
        Inspector.getInstance().pluginManager.registerPlugin(bar);
//        Inspector.getInstance().pluginManager.registerPlugin(new FlashConsole());
        Inspector.getInstance().pluginManager.registerPlugin(new InspectorRightMenu());
        Inspector.getInstance().pluginManager.registerPlugin(new FullScreen());
        Inspector.getInstance().pluginManager.registerPlugin(new GlobalErrorKeeper());
        Inspector.getInstance().pluginManager.registerPlugin(new AppStats());
        Inspector.getInstance().pluginManager.registerPlugin(new SwfInfoView());
        Inspector.getInstance().pluginManager.registerPlugin(new Tilt());

        Inspector.getInstance().turnOn(liveInspect.getPluginId());
        // this.stage.align = StageAlign.RIGHT;

        Inspector.getInstance().pluginManager.activePlugin(struct.getPluginId());
        // Inspector.getInstance().pluginManager.activePlugin(deval.getPluginId());

        // deval.setOutputReceiver(this.onDevalOutput);
    }

    private function onDevalOutput(...params):void {
    }
}
}
