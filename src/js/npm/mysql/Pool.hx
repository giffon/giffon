package js.npm.mysql;

import haxe.Constraints;

extern class Pool {
    @:overload(function(sql:String, values:Dynamic, callb:Function):Void {})
    @:overload(function(options:Dynamic, callb:Function):Void {})
    @:overload(function(options:Dynamic, values:Dynamic, callb:Function):Void {})
    public function query(sql:String, callb:Function):Void;

    public function escape(v:Dynamic):String;

    public function escapeId(v:String, ?dot:Bool):String;

    public function on(event:String, callb:Function):Void;

    public function end(?callb:Function):Void;
}