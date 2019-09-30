package js.npm.paypal.checkout_server_sdk.payments;

typedef CapturesRefundResponse = {
    id:String,
    amount: {
        currency_code:String,
        value:String,
    },
    seller_payable_breakdown: {
        gross_amount: {
            currency_code:String,
            value:String,
        },
        paypal_fee: {
            currency_code:String,
            value:String,
        },
        net_amount: {
            currency_code:String,
            value:String,
        },
        total_refunded_amount: {
            currency_code:String,
            value:String,
        }
    },
    invoice_id:String,
    status:String,
    create_time:String,
    update_time:String,
    links:Array<{
        href:String,
        rel:String,
        method:String,
    }>
}

@:jsRequire("@paypal/checkout-server-sdk", "payments.CapturesRefundRequest")
extern class CapturesRefundRequest implements Request<CapturesRefundResponse> {
    public function new(captureId:String):Void;

    public function requestBody(opts:Dynamic):Void;
}