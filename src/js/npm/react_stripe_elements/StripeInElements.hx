package js.npm.react_stripe_elements;

import js.stripe.Stripe;
import js.Promise;
import haxe.Constraints;

/*
Within the context of Elements, stripe.createToken and stripe.createSource wrap methods of the same name in Stripe.js.
Calls to them automatically infer and pass the Element object as the first argument.
*/
extern class StripeInElements {
    public function createToken(?tokenData:Dynamic):Promise<{
        @:optional var token:Dynamic;
        @:optional var error:Dynamic;
    }>;

    public function createSource(sourceData:Dynamic):Promise<{
        @:optional var source:Dynamic;
        @:optional var error:Dynamic;
    }>;

    public function createPaymentMethod(type:String, ?paymentMethodData:Dynamic):Promise<{
        @:optional var paymentMethod:Dynamic;
        @:optional var error:Dynamic;
    }>;

    public function handleCardPayment(clientSecret:String, ?paymentMethodData:Dynamic):Promise<{
        @:optional var paymentIntent:Dynamic;
        @:optional var error:Dynamic;
    }>;


    // other functions available on the `stripe` object,
    // as officially documented here: https://stripe.com/docs/elements/reference#the-stripe-object

    public function elements(?options:Dynamic):Elements;

    public function retrieveSource(source:{
        id:String,
        client_secret:String,
    }):Promise<Dynamic>;

    public function paymentRequest(options:Dynamic):PaymentRequest;
}