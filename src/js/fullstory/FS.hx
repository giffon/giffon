package js.fullstory;

/**
    https://help.fullstory.com/hc/en-us/sections/360003732794-JavaScript-API
**/
@:native("FS")
extern class FS {
    @:overload(function(b:Bool):Void {})
    static public function identify(uid:String, ?userVars:Dynamic):Void;

    static public function setUserVars(userVars:Dynamic):Void;

    static public function consent(userConsents:Bool = true):Void;

    @:overload(function(msg:String):Void {})
    static public function log(type:String, msg:String):Void;

    static public function getCurrentSessionURL(?now:Bool):String;

    static public function clearUserCookie(?onlyIdentified:Bool):String;

    static public function shutdown():Void;

    static public function restart():Void;

    static public function event(eventName:String, eventProperties:Dynamic):Void;
}