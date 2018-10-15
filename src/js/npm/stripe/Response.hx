package js.npm.stripe;

typedef Response = {
    var api_version:String;
    @:optional var account:String;
    @:optional var idempotency_key:String;
    var method:String;
    var path:String;
    var status:Int;
    var request_id:String;
    var elapsed:Int;
}