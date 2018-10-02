package js.npm.mysql;

import haxe.Constraints;

extern class PoolCluster {
    @:overload(function(name:String, config:Dynamic):Void {})
    public function add(config:Dynamic):Void;

    public function remove(name:String):Void;

    @:overload(function(name:String, callb:Function):Void {})
    @:overload(function(name:String, p:String, callb:Function):Void {})
    public function getConnection(callb:Function):Void;

    public function on(event:String, callb:Function):Void;

    public function of(pattern:String, ?selector:String):Pool;

    public function end(?callb:Function):Void;
}