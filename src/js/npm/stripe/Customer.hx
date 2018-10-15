package js.npm.stripe;

typedef Customer = {
    > Object,
    public var id:String;
    public var account_balance:Int;
    public var created:Float;
    public var currency:String;
    public var default_source:Null<Expandable<Source>>;
    public var delinquent:Bool;
    public var description:Null<String>;
    public var discount:Dynamic;
    public var email:Null<String>;
    public var invoice_prefix:String;
    public var livemode:Bool;
    public var metadata:Dynamic;
    public var shipping:Dynamic;
    public var sources: {
        public var object:String;
        public var data:Array<Source>;
        public var has_more:Bool;
        public var total_count:Int;
        public var url:String;
    };
    public var subscriptions: {
        public var object:String;
        public var data:Array<Subscription>;
        public var has_more:Bool;
        public var total_count:Int;
        public var url:String;
    };
    public var tax_info:Dynamic;
    public var tax_info_verification:Dynamic;
    public var deleted:Null<Bool>;
}