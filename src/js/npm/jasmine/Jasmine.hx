package js.npm.jasmine;

import haxe.Constraints;
import haxe.extern.*;

@:native("jasmine")
extern class Jasmine {
    static public var DEFAULT_TIMEOUT_INTERVAL:Int;
    static public var MAX_PRETTY_PRINT_ARRAY_LENGTH:Int;
    static public var MAX_PRETTY_PRINT_CHARS:Int;
    static public var MAX_PRETTY_PRINT_DEPTH:Int;
    static public function addCustomEqualityTester(tester:Function):Void;
    static public function addMatchers(matchers:Dynamic):Void;
    static public function addSpyStrategy(name:String, factory:Function):Void;
    static public function any(clazz:Function):Matcher;
    static public function anything():Matcher;
    static public function arrayContaining(sample:Array<Dynamic>):Matcher;
    static public function arrayWithExactContents(sample:Array<Dynamic>):Matcher;
    static public function clock():Clock;
    static public function createSpy(?name:String, ?originalFn:Function):Spy;
    static public function createSpyObj(?baseName:String, methodNames:Dynamic):Dynamic;
    static public function empty():Matcher;
    static public function falsy():Matcher;
    static public function getEnv():Env;
    static public function notEmpty():Matcher;
    static public function objectContaining(sample:Dynamic):Matcher;
    static public function stringMatching(expected:Dynamic):Matcher;
    static public function truthy():Matcher;
}