package js.npm.jasmine;

import haxe.Constraints;
import haxe.extern.*;

extern class SpyStrategy {
    public var identity:String;
    public function callFake(fn:Function):Void;
    public function callThrough():Void;
    public function exec():Void;
    public function returnValue(value:Dynamic):Void;
    public function returnValues(values:Rest<Dynamic>):Void;
    public function stub():Void;
    public function throwError(something:Dynamic):Void;
}