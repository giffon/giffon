package js.npm.passport;

typedef Profile = {
    @:optional public var provider:String;
    @:optional public var id:String;
    @:optional public var displayName:String;
    @:optional public var name:{
        @:optional public var familyName:String;
        @:optional public var givenName:String;
        @:optional public var middleName:String;
    };
    @:optional public var emails:Array<{
        @:optional public var value:String;
        @:optional public var type:String;
    }>;
    @:optional public var photos:Array<{
        @:optional public var value:String;
    }>;
}