package js.npm.stripe;

import js.Promise;
import haxe.Constraints;
import haxe.extern.*;

typedef EachHandler<T> = EitherType<T->Bool, T->?Bool->Void>;

typedef Options = {
    @:optional var api_key:String;
    @:optional var idempotency_key:String;
    @:optional var stripe_account:String;
    @:optional var stripe_version:String;
}

@:jsRequire("stripe")
extern class Stripe {
    public function new(apiKey:String):Void;

    public var customers(default, null):{
        public function create(arguments:Dynamic, ?options:Options):Promise<Customer>;
        public function createSource(customerId:String, arguments:Dynamic, ?options:Options):Promise<Source>;
        public function list(?arguments:Dynamic, ?options:Options):{
            public function autoPagingEach(onItem:EachHandler<Customer>):Promise<Dynamic>;
            public function autoPagingToArray(arguments:{limit:Int}):Array<Customer>;
        }
        public function update(customerId:String, arguments:Dynamic, ?options:Options):Promise<Customer>;
    };

    public var charges(default, null):{
        public function create(arguments:Dynamic, ?options:Options):Promise<Charge>;
    }

    public var balance(default, null):{
        public function retrieve(arguments:Dynamic, ?options:Options):Promise<Balance>;
    }

    public var webhooks(default, null):{
        public function constructEvent(rawBody:Dynamic, stripeSignatureHeader:Dynamic, secret:Dynamic, ?options:Options):Event;
    }

    public function setTimeout(ms:Float):Void;

    public function setHttpAgent(agent:Dynamic):Void;

    public function on(event:String, callb:Function):Void;

    public function off(event:String, callb:Function):Void;

    public function setAppInfo(arguments:Dynamic):Void;

    public function setApiVersion(version:String):Void;
}

extern class LastResponse {
    public var requestId(default, null):String;
    public var statusCode(default, null):Int;
}

extern class Customer {
    public var lastResponse(default, null):LastResponse;
    public var id(default, null):String;
}

extern class Source {
    public var lastResponse(default, null):LastResponse;
    public var customer(default, null):Customer;
}

extern class Charge {
    public var lastResponse(default, null):LastResponse;
    public var id(default, null):String;
    public function refund(chargeId:String, ?arguments:Dynamic, ?options:Options):Promise<Dynamic>;
}

extern class Balance {
    public var lastResponse(default, null):LastResponse;
}

extern class Event {
}