package giffon;

class Utils {
    #if (sys || hxnodejs)
    static public function env(varName:String, defaultValue:String):String {
        return switch (Sys.getEnv(varName)) {
            case null: defaultValue;
            case v: v;
        }
    }
    #end

    static public function tee<T>(v:T, ?pos:haxe.PosInfos):T {
        haxe.Log.trace(v, pos);
        return v;
    }

    macro static public function typeof(v:Dynamic) {
        return macro untyped __js__("(typeof {0})", $v);
    }
}