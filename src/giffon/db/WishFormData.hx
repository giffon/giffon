package giffon.db;

import thx.Decimal;
using StringTools;
using Lambda;

typedef WishFormValues = {
    acceptTerms:Bool,
    items:Array<{
        item_url:String,
        item_name:String,
        item_price:Float,
        item_quantity:Int,
        item_icon_url:Null<String>,
        item_icon_label:Null<String>,
    }>,
    currency:String,
    wish_title:String,
    wish_description:String,
    wish_target_date:Null<Date>,
}

class WishItemData implements DataClass {
    static public var item_price_max(default, never) = 10000;
    static public var item_quantity_max(default, never) = 100;

    @validate(StringTools.trim(_).length > 0)
    public var item_url:String;

    @validate(StringTools.trim(_).length > 0)
    public var item_name:String;

    @validate(_ > 0 && _ <= item_price_max)
    public var item_price:Float;

    @validate(_ > 0 && _ <= item_quantity_max)
    public var item_quantity:Int;

    public var item_icon_url:Null<String>;
    public var item_icon_label:Null<String>;
}

class WishFormData implements DataClass {
    static public var items_max(default, never) = 20;

    @validate(StringTools.trim(_).length > 0)
    public var wish_title:String;

    @validate(StringTools.trim(_).length > 0)
    public var wish_description:String;

    @validate(Type.allEnums(giffon.db.Currency).exists(function(c) return c.getName() == _))
    public var currency:String;

    @validate(_.getTime() > Date.now().getTime())
    public var wish_target_date:Null<Date>;

    @validate(_.length > 0 && _.length <= items_max)
    public var items:Array<WishItemData>;

    @validate(_ == true)
    public var acceptTerms:Bool;
}