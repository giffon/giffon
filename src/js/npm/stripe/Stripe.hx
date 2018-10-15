package js.npm.stripe;

import js.Promise;
import haxe.Constraints;

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

    public var sources(default, null):{
        > Resources<Source>,
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
