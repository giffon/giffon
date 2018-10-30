package js.npm.jasmine;

import haxe.Constraints;
import haxe.extern.*;

@:native("global")
extern class Global {
    static public function afterAll(?func:Function, ?timeout:Int):Void;
    static public function afterEach(?func:Function, ?timeout:Int):Void;
    static public function beforeAll(?func:Function, ?timeout:Int):Void;
    static public function beforeEach(?func:Function, ?timeout:Int):Void;
    static public function describe(description:String, specDefinitions:Function):Void;
    static public function expect(actual:Dynamic):Matchers;
    static public function expectAsync(actual:Dynamic):AsyncMatchers;
    static public function fail(?error:Dynamic):Void;
    static public function fdescribe(description:String, specDefinitions:Function):Void;
    static public function fit(description:String, testFunction:Function, ?timeout:Int):Void;
    static public function it(description:String, ?testFunction:Function, ?timeout:Int):Void;
    static public function pending(?message:String):Void;
    static public function spyOn(obj:Dynamic, methodName:String):Spy;
    static public function spyOnAllFunctions(obj:Dynamic):Dynamic;
    static public function spyOnProperty(obj:Dynamic, propertyName:String, ?accessType:String):Spy;
    static public function xdescribe(description:String, specDefinitions:Function):Void;
    static public function xit(description:String, ?testFunction:Function):Void;
}