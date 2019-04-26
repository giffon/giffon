package giffon;

class Utils {
    static public function env(varName:String, defaultValue:String):String {
        return switch (Sys.getEnv(varName)) {
            case null: defaultValue;
            case v: v;
        }
    }

    static public function tee<T>(v:T, ?pos:haxe.PosInfos):T {
        haxe.Log.trace(v, pos);
        return v;
    }
}