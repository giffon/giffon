package js.npm.mysql2;

@:forward
@:arrayAccess
abstract QueryResults<T>(Array<Dynamic>) to Array<Dynamic> {
    public var insertId(get, never):Null<Int>;
    inline function get_insertId() return untyped this.insertId;
}