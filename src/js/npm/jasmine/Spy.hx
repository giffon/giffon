package js.npm.jasmine;

import haxe.extern.*;

extern class Spy {
    static public var callData:{
        public var object:Dynamic;
        public var invocationOrder:Float;
        public var args:Array<Dynamic>;
    };
    public var and:SpyStrategy;
    public function withArgs(args:Rest<Dynamic>):SpyStrategy;
}