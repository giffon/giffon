package js.npm.mysql2.promise;

import haxe.Constraints;

extern class Connection {
    public function connect():Promise<Dynamic>;

    @:overload(function(sql:String, values:Dynamic):Promise<Dynamic> {})
    @:overload(function(options:Dynamic):Promise<Dynamic> {})
    @:overload(function(options:Dynamic, values:Dynamic):Promise<Dynamic> {})
    public function query(sql:String):Promise<Dynamic>;

    @:overload(function(sql:String, values:Dynamic):Promise<Dynamic> {})
    @:overload(function(options:Dynamic):Promise<Dynamic> {})
    @:overload(function(options:Dynamic, values:Dynamic):Promise<Dynamic> {})
    public function execute(sql:String):Promise<Dynamic>;

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