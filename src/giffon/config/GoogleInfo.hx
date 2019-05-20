package giffon.config;

import giffon.Utils.*;

class GoogleInfo {
    static public var GOOGLE_CLIENT_ID(default, never) = env("GOOGLE_CLIENT_ID", "gg client id");
    static public var GOOGLE_CLIENT_SECRET(default, never) = env("GOOGLE_CLIENT_SECRET", "secret");
}