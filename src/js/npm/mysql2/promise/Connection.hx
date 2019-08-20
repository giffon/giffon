package js.npm.mysql2.promise;

import haxe.Constraints;
#if (haxe_ver >= 4)
import js.lib.Promise;
#else
import js.Promise;
#end

extern class Connection {
    public function connect():Promise<Dynamic>;

    @:overload(function(sql:String, values:Dynamic):Promise<QueryOutcome> {})
    @:overload(function(options:Dynamic):Promise<QueryOutcome> {})
    @:overload(function(options:Dynamic, values:Dynamic):Promise<QueryOutcome> {})
    public function query(sql:String):Promise<QueryOutcome>;

    @:overload(function(sql:String, values:Dynamic):Promise<QueryOutcome> {})
    @:overload(function(options:Dynamic):Promise<QueryOutcome> {})
    @:overload(function(options:Dynamic, values:Dynamic):Promise<QueryOutcome> {})
    public function execute(sql:String):Promise<QueryOutcome>;

    public function escape(v:Dynamic):String;

    public function escapeId(v:String, ?dot:Bool):String;

    public function pause():Void;
    public function resume():Void;

    public function beginTransaction():Promise<Dynamic>;
    public function commit():Promise<Dynamic>;
    public function rollback():Promise<Dynamic>;

    public function ping():Promise<Dynamic>;

    public function release():Void;
    public function end():Promise<Dynamic>;

    public function destroy():Void;

    public function changeUser(options:{
        ?user:String,
        ?password:String,
        ?charset:String,
        ?database:String,
    }):Promise<Dynamic>;

    public var config:{
        var queryFormat:Function;
    }
}