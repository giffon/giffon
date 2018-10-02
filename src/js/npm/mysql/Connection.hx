package js.npm.mysql;

import haxe.Constraints;

extern class Connection {
    public function connect():Void;

    @:overload(function(sql:String, values:Dynamic, callb:Function):Void {})
    @:overload(function(options:Dynamic, callb:Function):Void {})
    @:overload(function(options:Dynamic, values:Dynamic, callb:Function):Void {})
    public function query(sql:String, callb:Function):Void;

    public function escape(v:Dynamic):String;

    public function escapeId(v:String, ?dot:Bool):String;

    public function pause():Void;
    public function resume():Void;

    public function beginTransaction(callb:Function):Void;
    public function commit(callb:Function):Void;

    public function ping(callb:Function):Void;

    public function end(?callb:Function):Void;

    public function destroy():Void;

    public function changeUser(options:{
        ?user:String,
        ?password:String,
        ?charset:String,
        ?database:String,
    }, callb:Function):Void;

    public var config:{
        var queryFormat:Function;
    }
}