package js.npm.pino;

import haxe.extern.EitherType;
import haxe.extern.Rest;
import haxe.Constraints;

typedef SonicBoom = Dynamic;

@:jsRequire("pino")
extern class Pino {
    @:selfCall
    public function new(?options:Dynamic, ?destination:Dynamic):Void;

    @:overload(function(?mergingObject:Dynamic, ?message:String, interpolationValues:Rest<Dynamic>):Void {})
    public function trace(?message:String, interpolationValues:Rest<Dynamic>):Void;

    @:overload(function(?mergingObject:Dynamic, ?message:String, interpolationValues:Rest<Dynamic>):Void {})
    public function debug(?message:String, interpolationValues:Rest<Dynamic>):Void;

    @:overload(function(?mergingObject:Dynamic, ?message:String, interpolationValues:Rest<Dynamic>):Void {})
    public function info(?message:String, interpolationValues:Rest<Dynamic>):Void;

    @:overload(function(?mergingObject:Dynamic, ?message:String, interpolationValues:Rest<Dynamic>):Void {})
    public function warn(?message:String, interpolationValues:Rest<Dynamic>):Void;

    @:overload(function(?mergingObject:Dynamic, ?message:String, interpolationValues:Rest<Dynamic>):Void {})
    public function error(?message:String, interpolationValues:Rest<Dynamic>):Void;

    @:overload(function(?mergingObject:Dynamic, ?message:String, interpolationValues:Rest<Dynamic>):Void {})
    public function fatal(?message:String, interpolationValues:Rest<Dynamic>):Void;

    public function child(bindings:Dynamic):Pino;
    public function bindings():Dynamic;
    public function flush():Void;
    public var level:String;
    public function islevelenabled(level:EitherType<String,Int>):Bool;
    public var levelVal:Int;
    public var levels:Dynamic;
    public var version:String;
    public var LOG_VERSION:Float;


    static public function destination(?target:Dynamic):SonicBoom;
    static public function extreme(?target:Dynamic):SonicBoom;
    @:native("final") static public function _final(logger:Pino, ?handler:Dynamic):EitherType<Function, Pino>;
    static public var stdSerializers:Dynamic;
    static public var stdTimeFunctions:Dynamic;
    static public var symbols:Dynamic;
    static public var version:String;
    static public var LOG_VERSION:Float;
}