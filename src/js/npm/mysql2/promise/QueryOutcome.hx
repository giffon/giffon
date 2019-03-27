package js.npm.mysql2.promise;

abstract QueryOutcome(Array<Dynamic>) to Array<Dynamic> {
    public var results(get, never):Null<haxe.extern.EitherType<Array<QueryResults>, QueryResults>>;
    public var fields(get, never):Array<Dynamic>;

    inline function get_results()
        return this[0];

    inline function get_fields()
        return this[1];
}