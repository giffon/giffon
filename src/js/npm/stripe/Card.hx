package js.npm.stripe;

typedef Card = {
    > Object,
    public var id:String;
    @:optional public var account:String;
    @:optional public var address_city:String;
    @:optional public var address_country:String;
    @:optional public var address_line1:String;
    @:optional public var address_line1_check:String;
    @:optional public var address_line2:String;
    @:optional public var address_state:String;
    @:optional public var address_zip:String;
    @:optional public var address_zip_check:String;
    public var brand:String;
    public var country:String;
    @:optional public var currency:String;
    @:optional public var customer:String;
    @:optional public var cvc_check:String;
    @:optional public var default_for_currency:String;
    @:optional public var dynamic_last4:String;
    public var exp_month:Int;
    public var exp_year:Int;
    public var fingerprint:String;
    public var funding:String;
    public var last4:String;
    public var metadata:Dynamic;
    @:optional public var name:String;
    @:optional public var tokenization_method:String;
}