package js.npm.stripe;

typedef Response = {
    var api_version(default, null):String;
    @:optional var account(default, null):String;
    @:optional var idempotency_key(default, null):String;
    var method(default, null):String;
    var path(default, null):String;
    var status(default, null):Int;
    var request_id(default, null):String;
    var elapsed(default, null):Int;
}