package js.npm.price_finder;

import haxe.Constraints;

@:jsRequire("price-finder")
extern class PriceFinder {
    public function new(?options:Dynamic):Void;
    public function findItemPrice(uri:String, callb:Function):Void;
    public function findItemDetails(uri:String, callb:Function):Void;
}