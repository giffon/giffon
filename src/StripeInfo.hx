#if nodejs
import Utils.*;
#end

class StripeInfo {
    static public var apiTestPubKey(default, never):String = "pk_test_FqNQT96FxmVM42BuCEXEIuEs";
    static public var apiTestSecKey(default, never):String = "sk_test_S2laxf3AVJM00eKYRwY5kgWI";
    static public var apiPubKey(default, never):String = "pk_live_KfoBMxxf0oRZ9GOEgVo32653";
    #if nodejs
    static public var apiSecKey(default, never):String = env("STRIPE_SECKEY", apiTestSecKey);
    #end
}