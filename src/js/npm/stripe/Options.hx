package js.npm.stripe;

import haxe.extern.*;

typedef Options = EitherType<String, {
    @:optional var api_key:String;
    @:optional var idempotency_key:String;
    @:optional var stripe_account:String;
    @:optional var stripe_version:String;
}>;