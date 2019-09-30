package js.npm.paypal.checkout_server_sdk.orders;

@:jsRequire("@paypal/checkout-server-sdk", "orders.OrdersCreateRequest")
extern class OrdersCreateRequest implements Request<Dynamic> {
    public function new():Void;

    public function prefer(v:String):Void;
    public function requestBody(opts:Dynamic):Void;
}