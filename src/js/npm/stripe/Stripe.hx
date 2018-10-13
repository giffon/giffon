package js.npm.stripe;

import js.Promise;
import haxe.Constraints;
import haxe.extern.*;

typedef EachHandler<T> = EitherType<T->Bool, T->?Bool->Void>;

typedef Options = EitherType<String, {
    @:optional var api_key:String;
    @:optional var idempotency_key:String;
    @:optional var stripe_account:String;
    @:optional var stripe_version:String;
}>;

typedef Resources<T> = {
    public function create(arguments:Dynamic, ?options:Options):Promise<T>;
    public function list(?arguments:Dynamic, ?options:Options):{
        public function autoPagingEach(onItem:EachHandler<T>):Promise<Dynamic>;
        public function autoPagingToArray(arguments:{limit:Int}):Array<T>;
    }
    public function retrieve(id:String, ?options:Options):Promise<T>;
    public function update(id:String, arguments:Dynamic, ?options:Options):Promise<T>;
}

@:jsRequire("stripe")
extern class Stripe {
    public function new(apiKey:String):Void;

    public var customers(default, null):{
        > Resources<Customer>,

        public function del(customerId:String):Promise<Dynamic>;

        @:overload(function(customerId:String, key:String, value:Dynamic):Promise<Dynamic>{})
        public function setMetadata(customerId:String, ?values:Dynamic):Promise<Dynamic>;

        public function deleteDiscount(customerId:String):Promise<Dynamic>;

        public function retrieveSource(customerId:String, sourceId:String, ?options:Options):Promise<Source>;
        public function createSource(customerId:String, arguments:Dynamic, ?options:Options):Promise<Source>;
        public function updateSource(customerId:String, sourceId:String, arguments:Dynamic, ?options:Options):Promise<Source>;
        public function deleteSource(customerId:String, sourceId:String, ?options:Options):Promise<Dynamic>;
        public function listSources(customerId:String):Promise<Dynamic>;
        public function verifySource(customerId:String, sourceId:String, arguments:Dynamic, ?options:Options):Promise<Dynamic>;

        public function retrieveCard(customerId:String, cardId:String, ?options:Options):Promise<Card>;
        public function createCard(customerId:String, arguments:Dynamic, ?options:Options):Promise<Card>;
        public function updateCard(customerId:String, cardId:String, arguments:Dynamic, ?options:Options):Promise<Card>;
        public function deleteCard(customerId:String, cardId:String, ?options:Options):Promise<Dynamic>;
        public function listCards(customerId:String):Promise<Dynamic>;

        public function retrieveSubscription(customerId:String, subscriptionId:String, ?options:Options):Promise<Subscription>;
        public function createSubscription(customerId:String, arguments:Dynamic, ?options:Options):Promise<Subscription>;
        public function updateSubscription(customerId:String, subscriptionId:String, arguments:Dynamic, ?options:Options):Promise<Subscription>;
        public function cancelSubscription(customerId:String, subscriptionId:String, ?arguments:Dynamic, ?options:Options):Promise<Dynamic>;
        public function listSubscriptions(customerId:String):Promise<Dynamic>;
        public function deleteSubscriptionDiscount(customerId:String, subscriptionId:String):Promise<Dynamic>;
    };

    public var charges(default, null):{
        > Resources<Charge>,
        public function capture(chargeId:String, arguments:Dynamic):Promise<Charge>;
        public function refund(chargeId:String, ?arguments:Dynamic, ?options:Options):Promise<Refund>;
    }

    public var balance(default, null):{
        > Resources<Balance>,
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
    public var object(default, null):String;
    public var account_balance(default, null):Int;
    public var created(default, null):Float;
    public var currency(default, null):String;
    public var default_source(default, null):Dynamic;
    public var delinquent(default, null):Bool;
    public var description(default, null):Null<String>;
    public var discount(default, null):Dynamic;
    public var email(default, null):Null<String>;
    public var invoice_prefix(default, null):String;
    public var livemode(default, null):Bool;
    public var metadata(default, null):Dynamic;
    public var shipping(default, null):Dynamic;
    public var sources(default, null): {
        public var object(default, null):String;
        public var data(default, null):Array<Dynamic>;
        public var has_more(default, null):Bool;
        public var total_count(default, null):Int;
        public var url(default, null):String;
    };
    public var subscriptions(default, null): {
        public var object(default, null):String;
        public var data(default, null):Array<Dynamic>;
        public var has_more(default, null):Bool;
        public var total_count(default, null):Int;
        public var url(default, null):String;
    };
    public var tax_info(default, null):Dynamic;
    public var tax_info_verification(default, null):Dynamic;
}

extern class Card {
    public var lastResponse(default, null):LastResponse;
    public var customer(default, null):Customer;
    public var object(default, null):String;
}

extern class Source {
    public var lastResponse(default, null):LastResponse;
    public var customer(default, null):Customer;
    public var object(default, null):String;
}

extern class Charge {
    public var lastResponse(default, null):LastResponse;
    public var id(default, null):String;
    public var object(default, null):String;
}

extern class Subscription {
    public var lastResponse(default, null):LastResponse;
    public var id(default, null):String;
    public var object(default, null):String;
}

extern class Balance {
    public var lastResponse(default, null):LastResponse;
    public var object(default, null):String;
}

extern class Refund {
    public var lastResponse(default, null):LastResponse;
    public var id(default, null):String;
    public var object(default, null):String;
}

extern class Event {
    public var id(default, null):String;
    public var object(default, null):String;
}