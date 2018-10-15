package js.npm.stripe;

typedef Source = {
    > Object,
    public var id:String;
    public var ach_credit_transfer:{
        public var account_number:String;
        public var routing_number:String;
        public var fingerprint:String;
        public var bank_name:String;
        public var swift_code:String;
    };
    public var amount:Null<Int>;
    public var client_secret:String;
    public var created:Float;
    public var currency:String;
    public var flow:String;
    public var livemode:Bool;
    public var metadata:Dynamic;
    public var owner:{
        public var address:Null<Dynamic>;
        public var email:String;
        public var name:Null<String>;
        public var phone:Null<String>;
        public var verified_address:Null<Dynamic>;
        public var verified_email:Null<String>;
        public var verified_name:Null<String>;
        public var verified_phone:Null<String>;
    };
    public var receiver:{
        public var address:String;
        public var amount_charged:Int;
        public var amount_received:Int;
        public var amount_returned:Int;
        public var refund_attributes_method:String;
        public var refund_attributes_status:String;
    };
    public var statement_descriptor:Null<String>;
    public var status:String;
    public var type:String;
    public var usage:String;
}