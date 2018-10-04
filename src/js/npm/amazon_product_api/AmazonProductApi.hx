package js.npm.amazon_product_api;

import js.Promise;

@:jsRequire("amazon-product-api")
extern class AmazonProductApi {
    static public function createClient(options:{
        awsId:String,
        awsSecret:String,
        awsTag:String
    }):Client;
}

extern class Client {
    public function itemSearch(options:Dynamic):Promise<Array<Dynamic>>;
    public function itemLookup(options:Dynamic):Promise<Dynamic>;
    public function browseNodeLookup(options:Dynamic):Promise<Dynamic>;
}