class Utils {
    static public function env(varName:String, defaultValue:String):String {
        return switch (Sys.getEnv(varName)) {
            case null: defaultValue;
            case v: v;
        }
    }
}