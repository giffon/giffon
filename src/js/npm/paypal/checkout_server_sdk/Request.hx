package js.npm.paypal.checkout_server_sdk;

interface Request<Response> {
    public function prefer(v:String):Void;
    public function requestBody(opts:Dynamic):Void;
}