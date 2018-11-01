package js.npm.jasmine;

import haxe.Constraints;
import haxe.extern.*;

extern class Matchers {
    public var not:Matchers;
    public function nothing():Void;
    public function toBe(expected:Dynamic):Void;
    public function toBeCloseTo(expected:Float, ?precision:Int):Void;
    public function toBeDefined():Void;
    public function toBeFalsy():Void;
    public function toBeGreaterThan(expected:Float):Void;
    public function toBeGreaterThanOrEqual(expected:Float):Void;
    public function toBeLessThan(expected:Float):Void;
    public function toBeLessThanOrEqual(expected:Float):Void;
    public function toBeNaN():Void;
    public function toBeNegativeInfinity():Void;
    public function toBeNull():Void;
    public function toBePositiveInfinity():Void;
    public function toBeTruthy():Void;
    public function toBeUndefined():Void;
    public function toContain(expected:Dynamic):Void;
    public function toEqual(expected:Dynamic):Void;
    public function toHaveBeenCalled():Void;
    public function toHaveBeenCalledBefore(expected:Spy):Void;
    public function toHaveBeenCalledTimes(expected:Int):Void;
    public function toHaveBeenCalledWith():Void;
    public function toHaveClass(expected:Dynamic):Void;
    public function toMatch(expected:EitherType<String, js.RegExp>):Void;
    public function toThrow(?expected:Dynamic):Void;
    public function toThrowError(?expected:Dynamic, ?message:Dynamic):Void;
    public function toThrowMatching(predicate:Function):Void;
    public function withContext(message:String):Matchers;
}