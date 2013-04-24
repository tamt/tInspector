package cn.itamt.utils
{
import cn.itamt.utils.inspector.ui.InspectorStageReference;

import flash.geom.Point;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.Stage;
import flash.events.Event;
import flash.geom.Matrix;

/**
 * @author itamt@qq.com
 */
public class DisplayObjectTool
{
    /**
     * 返回显示列表中的某个显示对象在显示对象树当中的级别.
     */
    public static function getDisplayObjectLevel(object:DisplayObject):int
    {
        if (object is Stage) {
            return 0;
        }
        if (object.stage) {
            var i:int = 0;
            while (object.parent) {
                object = object.parent;
                i++;
            }
            return i;
        } else {
            return -1;
        }
    }

    /**
     * 移除显示容器底下, 所有所有的显示对象. 不仅仅是子级.
     */
    public static function removeAllChildren(container:DisplayObjectContainer):void
    {
        while (container.numChildren) {
            if (container.getChildAt(0) is DisplayObjectContainer) {
                removeAllChildren(container.getChildAt(0) as DisplayObjectContainer);
            }
            container.removeChildAt(0);
        }
    }

    /**
     * 遍历某个容器下上的每个显示对象
     * @param fun        针对第个显示对象要执行的方法
     */
    public static function everyDisplayObject(container:DisplayObjectContainer, fun:Function):void
    {
        var num:int = container.numChildren;
        for (var i:int = 0; i < num; i++) {
            if (container.getChildAt(i) is DisplayObjectContainer) {
                everyDisplayObject(container.getChildAt(i) as DisplayObjectContainer, fun);
            }
            fun.call(null, container.getChildAt(i));
        }
    }

    /**
     * 遍历某个容器下的每个显示对象
     * @param container     要遍历的容器
     * @param fun           针对第个显示对象要执行的方法, 该方法需要返回一个布尔值， 如果为true， 中断遍历。
     */
    public static function eachDisplayObject(container:DisplayObjectContainer, fun:Function):Boolean
    {
        var willBreak:Boolean;
        var num:int = container.numChildren;
        for (var i:int = 0; i < num; i++) {
            if (container.getChildAt(i) is DisplayObjectContainer) {
                willBreak = eachDisplayObject(container.getChildAt(i) as DisplayObjectContainer, fun);
                if (willBreak) {
                    return willBreak;
                }
            }
            willBreak = fun.call(null, container.getChildAt(i));
        }

        return willBreak;
    }

    /**
     * 将显示对象置顶.
     */
    public static function swapToTop(obj:DisplayObject):void
    {
        if (obj.stage) {
            var fun:Function;
            obj.stage.invalidate();
            obj.stage.addEventListener(Event.RENDER, fun = function (evt:Event):void
            {
                if (obj != null && obj.stage != null && fun != null) {
                    if (obj.stage) {
                        obj.stage.removeEventListener(Event.RENDER, fun);
                        obj.parent.setChildIndex(obj, obj.parent.numChildren - 1);
                    }
                }
            });
        }
    }

    /**
     * 返回某一个Container下的所有显示对象的个数(包括子/"孙"...显示对象).
     */
    public static function getAllChildrenNum(container:DisplayObjectContainer):uint
    {
        var num:uint = container.numChildren;
        for (var i:int = 0; i < container.numChildren; i++) {
            var child:DisplayObject = container.getChildAt(i);
            if (child is DisplayObjectContainer) {
                num += getAllChildrenNum(child as DisplayObjectContainer);
            }
        }
        return num;
    }

    public static function getChilds(container:DisplayObjectContainer):Array
    {
        var arr:Array = [];
        for (var i:int = 0; i < container.numChildren; i++) {
            arr.push(container.getChildAt(i));
        }

        return arr;
    }

    /**
     * 得到一个显示对象他的全局的旋转角度.
     */
    public static function localRotationToGlobal(child:DisplayObject):Number
    {
        var greed:Number = child.rotation;
        if (child.parent) {
            greed += localRotationToGlobal(child.parent);
        }
        return greed;
    }

    public static function global2LocalMath(child:DisplayObject, c:Number, mathFun:Function):Number
    {
        var num:Number;
        num = c * mathFun.call(null, child.rotation * Math.PI / 180);
        if (child.parent) {
            num *= global2LocalMath(child.parent, num, mathFun);
        }
        return num;
    }

    public static function getConcatenatedMatrix(source:DisplayObject):Matrix
    {
        var m:Matrix = new Matrix();
        var scope:DisplayObject = source;
        while (scope) {
            if (scope is Stage) {
                m.concat(InspectorStageReference.getTransformMatrix());
            } else {
                m.concat(scope.transform.matrix.clone());
            }
            scope = scope.parent as DisplayObject;
        }
        return m;
    }

    /**
     * 由实例名路径来获取对象, 例如通过"panel.mc.btn1"来获取btn1对象
     * @param scope
     * @param val
     * @return
     */
    public static function getChildByNameFrom(scope:DisplayObjectContainer, val:String):DisplayObject
    {
        var target:* = scope;
        var names:Array = val.split(".");
        while (target) {
            var n:String = names.shift();
            if (!(n && (target = target.getChildByName(n)))) {
                break;
            }
        }

        if (target == scope)
            target = null;
        return target;
    }

    private static var engine:MovieClip = new MovieClip();

    public static function callLater(func:Function, args:Array = null, frame:int = 1):void
    {
        engine.addEventListener(Event.ENTER_FRAME, function (event:Event):void
        {
            if (--frame <= 0) {
                engine.removeEventListener(Event.ENTER_FRAME, arguments.callee);
                func.apply(null, args);
            }
        });
    }

    /**
     * project 2d point from one coordinate to another
     */
    public static function localToTarget(local:DisplayObject, pt:Point, target:DisplayObject):Point
    {
        return target.globalToLocal(local.localToGlobal(pt));
    }

    public static function isIn3D(target:DisplayObject):Boolean
    {
        var scope:DisplayObject = target;
        while (scope) {
            if (scope is Stage) {
                return false;
            } else {
                if (scope.transform.matrix == null) return true;
            }
            scope = scope.parent as DisplayObject;
        }
        return false;
    }
}
}