import Utils.*;

class FacebookInfo {
    static public var FACEBOOK_CLIENT_ID(default, never) = env("FACEBOOK_CLIENT_ID", "fb client id");
    static public var FACEBOOK_APP_SECRET(default, never) = env("FACEBOOK_APP_SECRET", "secret");
}