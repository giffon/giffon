package js.npm.stripe;

@:enum abstract ErrorType(String) from String to String {
    var StripeCardError = "StripeCardError";
    var StripeInvalidRequestError = "StripeInvalidRequestError";
    var StripeAPIError = "StripeAPIError";
    var StripeConnectionError = "StripeConnectionError";
    var StripeAuthenticationError = "StripeAuthenticationError";
    var StripeRateLimitError = "StripeRateLimitError";
}