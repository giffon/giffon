package giffon.db;

import thx.Decimal;
using StringTools;
using Lambda;
using js.npm.validator.Validator;

typedef WishFormValues = {
    acceptTerms:Bool,
    items:Array<{
        item_id:Int,
        item_url:String,
        item_name:String,
        item_price:Float,
        item_quantity:Int,
        item_icon_url:Null<String>,
        item_icon_label:Null<String>,
    }>,
    wish_additional_cost_description:String,
    wish_additional_cost_amount:Float,
    wish_currency:String,
    wish_title:String,
    wish_description:String,
    wish_target_date:Null<Date>,
    wish_banner_url:Null<String>,
}

class WishItemData implements DataClass {
    static public var item_price_max(default, never) = 200000;
    static public var item_quantity_max(default, never) = 100;

    @validate(_ >= -1)
    public var item_id:Int;

    @validate(validateItemUrl(_))
    public var item_url:String;

    @validate(StringTools.trim(_).length > 0)
    public var item_name:String;

    @validate(_ > 0 && _ <= item_price_max)
    public var item_price:Float;

    @validate(_ > 0 && _ <= item_quantity_max)
    public var item_quantity:Int;

    public var item_icon_url:Null<String>;
    public var item_icon_label:Null<String>;

    static public function validateItemUrl(v:String):Bool {
        if (!v.isURL({
            protocols: ["https", "http"],
            require_protocol: true,
        })) {
            return false;
        }

        return true;
    }
}

class WishFormData implements DataClass {
    static public var items_max(default, never) = 20;

    @validate(StringTools.trim(_).length > 0)
    public var wish_title:String;

    @validate(StringTools.trim(_).length > 0)
    public var wish_description:String;

    @validate(Type.allEnums(giffon.db.Currency).exists(function(c) return c.getName() == _))
    public var wish_currency:String;

    @validate(_.getTime() > Date.now().getTime())
    public var wish_target_date:Null<Date>;

    @validate(validateBannerUrl(_))
    public var wish_banner_url:Null<String>;

    @validate(_.length > 0 && _.length <= items_max)
    public var items:Array<WishItemData>;

    @validate(_.length <= 128)
    public var wish_additional_cost_description:String;

    @validate(_ >= 0 && _ <= WishItemData.item_price_max)
    public var wish_additional_cost_amount:Float;

    @validate(_ == true)
    public var acceptTerms:Bool;

    static public function validateBannerUrl(v:String):Bool {
        if (!v.isURL({
            protocols: ["https"],
            require_protocol: true,
        })) {
            return false;
        }

        return true;
    }
}