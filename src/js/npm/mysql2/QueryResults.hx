package js.npm.mysql2;

@:forward
@:arrayAccess
abstract QueryResults(Array<Dynamic>) to Array<Dynamic> {
    public var fieldCount(get, never): Null<Int>;
    inline function get_fieldCount() return untyped this.fieldCount;

    public var affectedRows(get, never): Null<Int>;
    inline function get_affectedRows() return untyped this.affectedRows;

    public var insertId(get, never): Null<Int>;
    inline function get_insertId() return untyped this.insertId;

    public var info(get, never): Null<Dynamic>;
    inline function get_info() return untyped this.info;

    public var serverStatus(get, never): Null<Int>;
    inline function get_serverStatus() return untyped this.serverStatus;

    public var warningStatus(get, never): Null<Int>;
    inline function get_warningStatus() return untyped this.warningStatus;
}