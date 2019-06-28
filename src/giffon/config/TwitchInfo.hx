package giffon.config;

import giffon.Utils.*;

class TwitchInfo {
    static public var TWITCH_CLIENT_ID(default, never) = env("TWITCH_CLIENT_ID", "twitch client id");
    static public var TWITCH_CLIENT_SECRET(default, never) = env("TWITCH_CLIENT_SECRET", "secret");
}