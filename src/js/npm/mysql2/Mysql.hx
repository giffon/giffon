package js.npm.mysql2;

import haxe.Constraints;
import haxe.extern.*;

typedef ConnectionOptions = {
    @:optional var host:String;
    @:optional var port:Int;
    @:optional var localAddress:String;
    @:optional var socketPath:String;
    var user:String;
    var password:String;
    @:optional var database:String;
    @:optional var charset:String;
    @:optional var timezone:String;
    @:optional var connectTimeout:Float;
    @:optional var stringifyObjects:Bool;
    @:optional var insecureAuth:Bool;
    @:optional var typeCast:Bool;
    @:optional var queryFormat:Function;
    @:optional var supportBigNumbers:Bool;
    @:optional var bigNumberStrings:Bool;
    @:optional var dateStrings:Bool;
    @:optional var debug:Bool;
    @:optional var trace:Bool;
    @:optional var multipleStatements:Bool;
    @:optional var flags:Array<String>;
    @:optional var ssl:Dynamic;
};

typedef PoolOptions = {
    > ConnectionOptions,
    @:optional var acquireTimeout:Float;
    @:optional var waitForConnections:Bool;
    @:optional var connectionLimit:Int;
    @:optional var queueLimit:Int;
}

typedef PoolClusterOptions = {
    @:optional var canRetry:Bool;
    @:optional var removeNodeErrorCount:Int;
    @:optional var restoreNodeTimeout:Float;
    @:optional var defaultSelector:String;
}

@:jsRequire("mysql2")
extern class Mysql {
    static public function createConnection(options:EitherType<String, ConnectionOptions>, callb:Function):Void;
    static public function createPool(options:PoolOptions, callb:Function):Void;
    static public function createPoolCluster(options:PoolClusterOptions, callb:Function):Void;
    static public function raw(v:String):Dynamic;
    static public function escape(v:Dynamic):String;
    static public function escapeId(v:String, ?dot:Bool):String;
    static public function format(sql:String, inserts:Array<Dynamic>):String;
}