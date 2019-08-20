package js.npm.stripe;

#if (haxe_ver >= 4)
import js.lib.Promise;
#else
import js.Promise;
#end

extern class ListResults<T> extends Promise<{
    data:Array<T>
}> {
    public function autoPagingEach(onItem:EachHandler<T>):Promise<Dynamic>;
    public function autoPagingToArray(arguments:{limit:Int}):Promise<Array<T>>;
}

typedef Resources<T> = {
    public function create(arguments:Dynamic, ?options:Options):Promise<T>;
    public function list(?arguments:Dynamic, ?options:Options):ListResults<T>;
    public function retrieve(id:String, ?arguments:Dynamic, ?options:Options):Promise<T>;
    public function update(id:String, arguments:Dynamic, ?options:Options):Promise<T>;
}