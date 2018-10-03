class DBInfo {
    static function env(varName:String, defaultValue:String):String {
        return switch (Sys.getEnv(varName)) {
            case null: defaultValue;
            case v: v;
        }
    }
    static public var host(default, never):String = env("DB_HOST", "localhost");
    static public var user(default, never):String = env("DB_USER", "root");
    static public var password(default, never):String = env("DB_PASSWORD", "devroot");
    static public var database(default, never):String = "giffon";
}