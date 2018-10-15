package js.npm.stripe;

extern class Source {
    public var lastResponse(default, null):LastResponse;
    public var id(default, null):String;
    public var object(default, null):String;
    public var ach_credit_transfer(default, null):{
        public var account_number(default, null):String;
        public var routing_number(default, null):String;
        public var fingerprint(default, null):String;
        public var bank_name(default, null):String;
        public var swift_code(default, null):String;
    };
    public var amount(default, null):Null<Int>;
    public var client_secret(default, null):String;
    public var created(default, null):Float;
    public var currency(default, null):String;
    public var flow(default, null):String;
    public var livemode(default, null):Bool;
    public var metadata(default, null):Dynamic;
    public var owner(default, null):{
        public var address(default, null):Null<Dynamic>;
        public var email(default, null):String;
        public var name(default, null):Null<String>;
        public var phone(default, null):Null<String>;
        public var verified_address(default, null):Null<Dynamic>;
        public var verified_email(default, null):Null<String>;
        public var verified_name(default, null):Null<String>;
        public var verified_phone(default, null):Null<String>;
    };
    public var receiver(default, null):{
        public var address(default, null):String;
        public var amount_charged(default, null):Int;
        public var amount_received(default, null):Int;
        public var amount_returned(default, null):Int;
        public var refund_attributes_method(default, null):String;
        public var refund_attributes_status(default, null):String;
    };
    public var statement_descriptor(default, null):Null<String>;
    public var status(default, null):String;
    public var type(default, null):String;
    public var usage(default, null):String;
}