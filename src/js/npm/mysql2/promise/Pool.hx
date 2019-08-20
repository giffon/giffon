package js.npm.mysql2.promise;

import haxe.Constraints;
#if (haxe_ver >= 4)
import js.lib.Promise;
#else
import js.Promise;
#end

extern class Pool {
    @:overload(function(sql:String, values:Dynamic):Promise<QueryOutcome> {})
    @:overload(function(options:Dynamic):Promise<QueryOutcome> {})
    @:overload(function(options:Dynamic, values:Dynamic):Promise<QueryOutcome> {})
    public function query(sql:String):Promise<QueryOutcome>;

    @:overload(function(sql:String, values:Dynamic):Promise<QueryOutcome> {})
    @:overload(function(options:Dynamic):Promise<QueryOutcome> {})
    @:overload(function(options:Dynamic, values:Dynamic):Promise<QueryOutcome> {})
    public function execute(sql:String):Promise<QueryOutcome>;

    public function getConnection():Promise<Connection>;

    public function escape(v:Dynamic):String;

    public function escapeId(v:String, ?dot:Bool):String;

    public function on(event:String, callb:Function):Void;

    public function end():Promise<Void>;
}