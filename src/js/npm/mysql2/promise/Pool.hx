package js.npm.mysql2.promise;

import haxe.Constraints;

extern class Pool {
    @:overload(function(sql:String, values:Dynamic):Promise<Dynamic> {})
    @:overload(function(options:Dynamic):Promise<Dynamic> {})
    @:overload(function(options:Dynamic, values:Dynamic):Promise<Dynamic> {})
    public function query(sql:String):Promise<Dynamic>;

    @:overload(function(sql:String, values:Dynamic):Promise<Dynamic> {})
    @:overload(function(options:Dynamic):Promise<Dynamic> {})
    @:overload(function(options:Dynamic, values:Dynamic):Promise<Dynamic> {})
    public function execute(sql:String):Promise<Dynamic>;

    public function getConnection():Promise<Connection>;

    public function escape(v:Dynamic):String;

    public function escapeId(v:String, ?dot:Bool):String;

    public function on(event:String, callb:Function):Void;

    public function end():Promise<Void>;
}