package cn.itamt.utils {
import cn.itamt.utils.inspector.core.IInspector;
import cn.itamt.utils.inspector.core.IInspectorPlugin;
import cn.itamt.utils.inspector.core.IInspectorPluginManager;
import cn.itamt.utils.inspector.core.InspectTarget;
import cn.itamt.utils.inspector.core.InspectorPluginManager;
import cn.itamt.utils.inspector.core.inspectfilter.IInspectorFilterManager;
import cn.itamt.utils.inspector.core.inspectfilter.InspectorFilterManager;
import cn.itamt.utils.inspector.core.liveinspect.LiveInspectView;
import cn.itamt.utils.inspector.core.propertyview.PropertiesView;
import cn.itamt.utils.inspector.core.structureview.StructureView;
import cn.itamt.utils.inspector.plugins.controlbar.ControlBar;
import cn.itamt.utils.inspector.plugins.tfm3d.Transform3DController;
import cn.itamt.utils.inspector.popup.InspectorPopupManager;
import cn.itamt.utils.inspector.popup.InspectorTipsManager;
import cn.itamt.utils.inspector.ui.InspectorStageReference;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Stage;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Point;
import flash.utils.Dictionary;

/**
 * @author tamt
 * @example
 *    <code>
 *        Inspector.init(...);
 *    </code>
 */
public class Inspector extends EventDispatcher implements IInspector {
    public static const VERSION:String = '1.3.2';
    private static var _instance:Inspector;
    private var _root:DisplayObjectContainer;

    public function get root():DisplayObjectContainer {
        return _root;
    }

    private var _stage:Stage;

    public function get stage():Stage {
        return _stage;
    }

    private var _filterManager:IInspectorFilterManager;

    public function get filterManager():IInspectorFilterManager {
        return _filterManager;
    }

    private var _pluginMgr:IInspectorPluginManager;

    public function get pluginManager():IInspectorPluginManager {
        return _pluginMgr;
    }

    private var _curLiveInspectEle:InspectTarget;
    private var _curInspectEle:InspectTarget;

    public function getCurInspectTarget():InspectTarget {
        return _curInspectEle;
    }

    public function getCurLiveInspectTarget():InspectTarget {
        return _curLiveInspectEle;
    }

    private var _inited:Boolean;

    public function Inspector(sf:SingletonEnforcer) {
        super();

        if (sf == null) {
            throw new Error('use Inspector.getInstance() to play.');
        }

        _filterManager = new InspectorFilterManager();

        _pluginMgr = new InspectorPluginManager(this);
    }

    public static function getInstance():Inspector {
        if (_instance == null) {
            _instance = new Inspector(new SingletonEnforcer());
        }

        return _instance;
    }

    /**
     * init tInspector
     */
    public function init(root:DisplayObjectContainer):void {
        if (_inited)
            return;
        _inited = true;

        this._root = root;
        this._stage = root.stage;

        if (this._stage == null) {
            throw new Error("Set inspector's stage before you call inspector.init(); ");
            return;
        }

        this._root.addEventListener("allComplete", function (evt:Event):void {
            //trace("hello");
        });

        InspectorStageReference.referenceTo(this._stage);

        this.pluginManager.registerPlugin(_filterManager);
    }

    /**
     * turn on tInspector, with plugin(s) want to use
     * @param    ...paras  plugin IDs
     */
    public function turnOn(...paras):void {
        if (_isOn)
            return;
        _isOn = true;
        _curLiveInspectEle = null;
        _curInspectEle = null;

        // 鼠標tip相关
        InspectorTipsManager.init();
        InspectorPopupManager.init();

        // 调用各个模块的onTurnOn
        var plugins:Array = this.pluginManager.getPlugins();
        for each(var plugin:IInspectorPlugin in plugins) {
            plugin.onTurnOn();
        }

        for (var i:int = 0; i < paras.length; i++) {
            this.pluginManager.activePlugin(String(paras[i]));
        }
    }

    /**
     * turn off tInspector
     */
    public function turnOff():void {
        this.stopLiveInspect();

        InspectorTipsManager.dispose();
        InspectorPopupManager.dispose();

        if (!_isOn)
            return;
        _isOn = false;
        _curLiveInspectEle = null;
        _curInspectEle = null;

        var plugins:Array = this.pluginManager.getPlugins();
        for each(var view:IInspectorPlugin in plugins) {
            // if(view.isActive)view.onUnActive();
            view.onTurnOff();
        }
    }

    public function toggleTurn():void {
        if (_isOn) {
            this.turnOff();
        } else {
            this.turnOn();
        }
    }

    /**
     * is tInspector on?
     */
    private var _isOn:Boolean = false;

    public function get isOn():Boolean {
        return _isOn;
    }

    private var _isLiveInspecting:Boolean = false;

    /**
     * is tinspector in  live inspecting?
     */
    public function get isLiveInspecting():Boolean {
        return _isLiveInspecting;
    }

    /**
     * start live inspect
     */
    public function startLiveInspect():void {
        if (!_isLiveInspecting) {
            _curLiveInspectEle = null;

            _isLiveInspecting = true;
            this.stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);

            var plugins:Array = this.pluginManager.getPlugins();
            for each(var view:IInspectorPlugin in plugins) {
                if (view.isActive)
                    view.onStartLiveInspect();
            }
        }
    }

    /**
     * stop live inspect
     */
    public function stopLiveInspect():void {
        _isLiveInspecting = false;
        this.stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);

        _curLiveInspectEle = null;

        var plugins:Array = this.pluginManager.getPlugins();
        for each(var view:IInspectorPlugin in plugins) {
            if (view.isActive)
                view.onStopLiveInspect();
        }
    }

    /**
     * check whther the target is valid? if it is plugin or contained by the plugin...
     */
    public function isInspectView(target:DisplayObject):Boolean {
        var plugins:Array = this.pluginManager.getPlugins();
        for each(var view:IInspectorPlugin in plugins) {
            if (view.contains(target)) {
                return true;
            }
        }
        return InspectorPopupManager.contains(target);
    }

    /**
     * live inspect(mouse inspect) a target. this method is called by LiveInspectView when use live inspect(mouse inspect).
     * @param ele                    inspect target
     * @param checkIsInspectorView    check whether the target is invalid(containded by any plugin)
     */
    public function liveInspect(ele:DisplayObject, checkIsInspectorView:Boolean = true):void {
        // bug: this (if) cause the live overlay not shown until overlay another object
        if (_curLiveInspectEle && _curLiveInspectEle.displayObject == ele) return;

        if (checkIsInspectorView)
            if (isInspectView(ele))
                return;

        _curLiveInspectEle = getInspectTarget(ele);

        var plugins:Array = this.pluginManager.getPlugins();
        for each(var view:IInspectorPlugin in plugins) {
            if (view.isActive)
                view.onLiveInspect(_curLiveInspectEle);
        }
    }

    /**
     * inspect a DisplayObject
     */
    public function inspect(ele:DisplayObject):void {
        if (isInspectView(ele))
            return;

        stopLiveInspect();

        _curInspectEle = getInspectTarget(ele);

        var plugins:Array = this.pluginManager.getPlugins();
        for each(var view:IInspectorPlugin in plugins) {
            if (view.isActive)
                view.onInspect(_curInspectEle);
        }
    }

    /**
     * update all the registered plugins
     */
    public function updateInsectorView():void {
        if (_curInspectEle != null) {
            var plugins:Array = this.pluginManager.getPlugins();
            for each(var view:IInspectorPlugin in plugins) {
                if (view.isActive)
                    view.onUpdate(_curInspectEle);
            }
        }
    }

    private var _tMap:Dictionary;

    /**
     * map "DisplayObject" to "InspectTarget", we use "InspectTarget" in tInspector.
     */
    private function getInspectTarget(target:DisplayObject):InspectTarget {
        if (_tMap == null) {
            _tMap = new Dictionary();
        }

        if (_tMap[target] == null) {
            _tMap[target] = new InspectTarget(target);
        }

        return _tMap[target];
    }

    private function enterFrameHandler(evt:Event = null):void {
        var mousePos:Point = new Point(stage.mouseX, stage.mouseY);
        var objs:Array = stage.getObjectsUnderPoint(mousePos);
        var l:int = objs.length;

        if (l) {
            while (l--) {
                var target:DisplayObject = objs[l];
                if (target == null || !target.stage)
                    continue;
                if (isInspectView(target)) {
//						return;
                    continue;
//						if(liveInspectView.contains(target)) {
//							continue;
//						} else {
//							return;
//						}
                }
                while (target && target.stage) {
                    if (_filterManager.checkInFilter(target)) {
                        liveInspect(target, false);
                        return;
                    } else {
                        if (target.parent && target.parent != this.stage) {
                            target = target.parent;
                        } else {
                            break;
                        }
                    }
                }
            }
        }
    }

    public static function init(root:DisplayObjectContainer, defaultPlugins:Boolean = true):void {
        Inspector.getInstance().init(root);

        if (defaultPlugins) {
            var bar:ControlBar = new ControlBar();
            root.addChild(bar);
            var liveInspect:LiveInspectView = new LiveInspectView();
            liveInspect.use3DTransformer(new Transform3DController);
            var property:PropertiesView = new PropertiesView();
            var struct:StructureView = new StructureView();

            Inspector.getInstance().pluginManager.registerPlugin(struct);
            Inspector.getInstance().pluginManager.registerPlugin(liveInspect);
            Inspector.getInstance().pluginManager.registerPlugin(property);
            Inspector.getInstance().pluginManager.registerPlugin(bar);
        }
    }

    public static function registerPlugin(plugin:IInspectorPlugin):void {
        Inspector.getInstance().pluginManager.registerPlugin(plugin);
    }

    public static function unregisterPlugin(pluginId:String):void {
        Inspector.getInstance().pluginManager.unregisterPlugin(pluginId);
    }

    public static function getPlugin(pluginId : String) : IInspectorPlugin{
        return Inspector.getInstance().pluginManager.getPluginById(pluginId);
    }
}
}
class SingletonEnforcer {
}