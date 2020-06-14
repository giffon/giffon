package giffon.db;

import thx.Decimal;
using StringTools;
using Lambda;
using js.npm.validator.Validator;
import giffon.db.WishFormData.WishItemDataConst.*;
import giffon.db.WishFormData.WishFormDataConst.*;

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

class WishItemDataConst {
    static public final item_price_max:Int = 200000;
    static public final item_quantity_max:Int = 100;
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

class WishItemData implements DataClass {
    @:validate(_ >= -1)
    public final item_id:Int;

    @:validate(validateItemUrl(_))
    public final item_url:String;

    @:validate(StringTools.trim(_).length > 0)
    public final item_name:String;

    @:validate(_ > 0 && _ <= item_price_max)
    public final item_price:Float;

    @:validate(_ > 0 && _ <= item_quantity_max)
    public final item_quantity:Int;

    public final item_icon_url:Null<String>;
    public final item_icon_label:Null<String>;
}

class WishFormDataConst {
    static public final items_max:Int = 20;
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

class WishFormData implements DataClass {
    @:validate(StringTools.trim(_).length > 0)
    public final wish_title:String;

    @:validate(StringTools.trim(_).length > 0)
    public final wish_description:String;

    @:validate(Type.allEnums(giffon.db.Currency).exists(function(c) return c.getName() == _))
    public final wish_currency:String;

    @:validate(_ == null || _.getTime() > Date.now().getTime())
    public final wish_target_date:Null<Date>;

    @:validate(_ == null || validateBannerUrl(_))
    public final wish_banner_url:Null<String>;

    @:validate(_.length > 0 && _.length <= items_max)
    public final items:Array<WishItemData>;

    @:validate(_.length <= 128)
    public final wish_additional_cost_description:String;

    @:validate(_ >= 0 && _ <= WishItemDataConst.item_price_max)
    public final wish_additional_cost_amount:Float;

    @:validate(_ == true)
    public final acceptTerms:Bool;
}