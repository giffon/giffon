package js.npm.stripe;

typedef Charge = {
    > Object,
    public var id:String;
    public var customer:Null<Expandable<Customer>>;

    public var amount:Float;
    public var amount_refunded:Float;
}