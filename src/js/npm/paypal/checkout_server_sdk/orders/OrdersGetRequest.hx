package js.npm.paypal.checkout_server_sdk.orders;

typedef OrdersGetResponse = {
    id:String,
    status:String,
    intent:String,
    purchase_units:Array<{
        reference_id:String,
        amount: {
            currency_code:String,
            value:String,
        },
        payee: {
            email_address:String,
            merchant_id:String,
        },
        description:String,
        shipping: {
            name: {
                full_name:String,
            },
            address: {
                address_line_1:String,
                admin_area_2:String,
                admin_area_1:String,
                postal_code:String,
                country_code:String,
            }
        },
        payments: {
            captures:Array<{
                id:String,
                status:String,
                amount: {
                    currency_code:String,
                    value:String,
                },
                final_capture:Bool,
                seller_protection: {
                    status:String,
                    dispute_categories:Array<String>,
                },
                seller_receivable_breakdown: {
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
                    }
                },
                links:Array<{
                    href:String,
                    rel:String,
                    method:String,
                }>,
                create_time:String,
                update_time:String,
            }>,
            refunds: Array<{
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
                status:String,
                links:Array<{
                    href:String,
                    rel:String,
                    method:String,
                }>,
                create_time:String,
                update_time:String,
            }>,
        },
        payer: {
            name: {
                given_name:String,
                surname:String,
            },
            email_address:String,
            payer_id:String,
            phone: {
                phone_number: {
                    national_number:String,
                }
            },
            address: {
                country_code:String,
            }
        },
    }>,
    create_time:String,
    update_time:String,
    links:Array<{
        href:String,
        rel:String,
        method:String,
    }>,
}

@:jsRequire("@paypal/checkout-server-sdk", "orders.OrdersGetRequest")
extern class OrdersGetRequest implements Request<OrdersGetResponse> {
    public function new(orderID:String):Void;
    public function prefer(v:String):Void;
    public function requestBody(opts:Dynamic):Void;
}