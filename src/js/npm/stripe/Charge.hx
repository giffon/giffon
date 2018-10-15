package js.npm.stripe;

extern class Charge {
    public var lastResponse(default, null):LastResponse;
    public var id(default, null):String;
    public var object(default, null):String;
    public var customer(default, null):Null<Expandable<Customer>>;
}