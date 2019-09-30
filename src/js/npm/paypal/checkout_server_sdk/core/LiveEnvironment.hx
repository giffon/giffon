package js.npm.paypal.checkout_server_sdk.core;

@:jsRequire("@paypal/checkout-server-sdk", "core.LiveEnvironment")
extern class LiveEnvironment {
    public function new(clientID:String, clientSecret:String):Void;
}