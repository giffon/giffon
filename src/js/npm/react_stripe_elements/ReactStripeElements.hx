package js.npm.react_stripe_elements;

import react.ReactComponent;

@:jsRequire("react-stripe-elements")
extern class ReactStripeElements {
    static public function injectStripe(component:Dynamic):Dynamic;
}