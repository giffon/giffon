package js.npm.stripe;

extern class Customer {
    public var lastResponse(default, null):LastResponse;
    public var id(default, null):String;
    public var object(default, null):String;
    public var account_balance(default, null):Int;
    public var created(default, null):Float;
    public var currency(default, null):String;
    public var default_source(default, null):Null<Expandable<Source>>;
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
        public var data(default, null):Array<Source>;
        public var has_more(default, null):Bool;
        public var total_count(default, null):Int;
        public var url(default, null):String;
    };
    public var subscriptions(default, null): {
        public var object(default, null):String;
        public var data(default, null):Array<Subscription>;
        public var has_more(default, null):Bool;
        public var total_count(default, null):Int;
        public var url(default, null):String;
    };
    public var tax_info(default, null):Dynamic;
    public var tax_info_verification(default, null):Dynamic;
}