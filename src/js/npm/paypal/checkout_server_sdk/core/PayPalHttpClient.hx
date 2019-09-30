package js.npm.paypal.checkout_server_sdk.core;

@:jsRequire("@paypal/checkout-server-sdk", "core.PayPalHttpClient")
extern class PayPalHttpClient {
    public function new(environment:Dynamic):Void;

    public function execute<T>(request:Request<T>):js.lib.Promise<{
        statusCode:Dynamic,
        headers:Dynamic,
        result:T,
    }>;
}