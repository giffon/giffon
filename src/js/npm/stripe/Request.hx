package js.npm.stripe;

typedef Request = {
    var api_version:String;
    @:optional var account:String;
    @:optional var idempotency_key:String;
    var method:String;
    var path:String;
}