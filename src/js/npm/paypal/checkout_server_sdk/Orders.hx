package js.npm.paypal.checkout_server_sdk;

@:jsRequire("@paypal/checkout-server-sdk", "orders")
extern class Orders {
    static public function OrdersGetRequest(orderID:String):Dynamic;
}