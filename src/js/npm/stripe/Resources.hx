package js.npm.stripe;

typedef Resources<T> = {
    public function create(arguments:Dynamic, ?options:Options):Promise<T>;
    public function list(?arguments:Dynamic, ?options:Options):{
        public function autoPagingEach(onItem:EachHandler<T>):Promise<Dynamic>;
        public function autoPagingToArray(arguments:{limit:Int}):Promise<Array<T>>;
    }
    public function retrieve(id:String, ?arguments:Dynamic, ?options:Options):Promise<T>;
    public function update(id:String, arguments:Dynamic, ?options:Options):Promise<T>;
}