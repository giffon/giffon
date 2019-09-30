package js.npm.paypal.checkout_server_sdk.core;

@:jsRequire("@paypal/checkout-server-sdk", "core.SandboxEnvironment")
extern class SandboxEnvironment {
    public function new(clientID:String, clientSecret:String):Void;
}