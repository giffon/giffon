package js.npm.amazon_helpers;

@:jsRequire("amazon-helpers")
extern class AmazonHelpers {
    static public function getIdent(urlOrAsin:String):String;
    static public function getProductUrl(urlOrAsin:String, ?tld:String):String;
    static public function getIdentByUrl(urlOrAsin:String):{
        asin:String,
        tld:String
    };
}