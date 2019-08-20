package js.stripe;

import haxe.Constraints;

#if (haxe_ver >= 4)
import js.lib.Promise;
#else
import js.Promise;
#end

/**
 * Stripe.js and Elements
 * https://stripe.com/docs/stripe-js
 */
@:native("Stripe")
extern class Stripe {
    public function new(publishableKey:String, ?options:Dynamic):Void;

    public function elements(?options:Dynamic):Elements;

    public function createToken(v:Dynamic, ?data:Dynamic):Promise<Dynamic>;

    @:overload(function (element:Dynamic, sourceData:Dynamic):Promise<Dynamic>{})
    public function createSource(sourceData:Dynamic):Promise<Dynamic>;

    public function retrieveSource(source:{
        id:String,
        client_secret:String,
    }):Promise<Dynamic>;

    public function paymentRequest(options:Dynamic):PaymentRequest;
}

extern class Elements {
    public function create(type:String, options:Dynamic):Element;
}

extern class Element extends js.html.EventTarget {
    public function mount(domElement:Dynamic):Void;
    public function on(event:String, handler:Function):Void;

    public function blur():Void;
    public function clear():Void;
    public function destroy():Void;
    public function focus():Void;
    public function unmount():Void;
    public function update(options:Dynamic):Void;
}

extern class PaymentRequest {
    public function canMakePayment():Promise<Dynamic>;
    public function show():Void;
    public function update(options:Dynamic):Void;
    public function on(event:String, handler:Function):Void;
}