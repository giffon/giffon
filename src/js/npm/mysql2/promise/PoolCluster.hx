package js.npm.mysql2.promise;

import haxe.Constraints;

extern class PoolCluster {
    @:overload(function(name:String, config:Dynamic):Void {})
    public function add(config:Dynamic):Void;

    public function remove(name:String):Void;

    @:overload(function(name:String):Promise<Connection> {})
    @:overload(function(name:String, p:String):Promise<Connection> {})
    public function getConnection():Promise<Connection>;

    public function on(event:String, callb:Function):Void;

    public function of(pattern:String, ?selector:String):Pool;

    public function end():Promise<Void>;
}