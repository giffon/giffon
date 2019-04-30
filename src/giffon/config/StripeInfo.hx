package giffon.config;

#if nodejs
import giffon.Utils.*;
#end

class StripeInfo {
    static public var apiPubKey(default, never):String = switch(Stage.stage) {
        case Production, Master:
            "pk_live_KfoBMxxf0oRZ9GOEgVo32653";
        case Dev:
            "pk_test_FqNQT96FxmVM42BuCEXEIuEs";
    }
    #if nodejs
    static private var _apiSecKey(default, never) = "sk_test_S2laxf3AVJM00eKYRwY5kgWI";
    static public var apiSecKey(default, never):String = switch(Stage.stage) {
        case Production, Master:
            env("STRIPE_SECKEY", _apiSecKey);
        case Dev:
            _apiSecKey;
    }
    #end
}