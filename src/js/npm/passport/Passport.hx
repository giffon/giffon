package js.npm.passport;

import haxe.Constraints;

@:jsRequire("passport")
extern class Passport {
    static public function use(strategy:Strategy):Void;
    static public function serializeUser(func:Function):Void;
    static public function deserializeUser(func:Function):Void;
    static public function initialize():Function;
    static public function session():Function;
    static public function authenticate(type:String, opts:Dynamic):Function;
}