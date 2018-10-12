package js.npm.stripe;

typedef Request = {
    var api_version(default, null):String;
    @:optional var account(default, null):String;
    @:optional var idempotency_key(default, null):String;
    var method(default, null):String;
    var path(default, null):String;
}