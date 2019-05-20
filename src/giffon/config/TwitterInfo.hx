package giffon.config;

import giffon.Utils.*;

class TwitterInfo {
    static public var TWITTER_CONSUMER_KEY(default, never) = env("TWITTER_CONSUMER_KEY", "tw client id");
    static public var TWITTER_CONSUMER_SECRET(default, never) = env("TWITTER_CONSUMER_SECRET", "secret");
}