package giffon.config;

import giffon.Utils.*;

class DBInfo {
    static public var host(default, never):String = env("DB_HOST", "localhost");
    static public var user(default, never):String = env("DB_USER", "root");
    static public var password(default, never):String = env("DB_PASSWORD", "devroot");
    static public var database(default, never):String = "giffon";
    static public var charset(default, never):String = "utf8mb4_bin";
    static public var salt(default, never):String = env("DB_SALT", "salt");
}