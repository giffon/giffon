package giffon.db;

import thx.Decimal;
using StringTools;
using Lambda;
using js.npm.validator.Validator;
import giffon.db.PledgeFormData.PledgeFormDataConst.*;

typedef PledgeFormValues = {
    acceptTerms:Bool,
    pledge_method:String,
    pledge_amount:Float,
    pledge_data:Dynamic,
    pledge_visibility:String,
    pledge_name_visibility:String,
}

class PledgeFormDataConst {
    static public final pledge_amount_min:Int = 1;
    static public final pledge_amount_max:Int = 500000;
}

class PledgeFormData implements DataClass {
    @:validate(_ >= pledge_amount_min && _ <= pledge_amount_max)
    public final pledge_amount:Float;

    @:validate(Type.allEnums(PledgeMethod).exists(function(m) return m.getName() == _))
    public final pledge_method:String;

    @:validate(validatePledgeVisibility(_))
    public final pledge_visibility:String;

    @:validate(validatePledgeVisibility(_))
    public final pledge_name_visibility:String;

    public final pledge_data:Dynamic;

    @:validate(_ == true)
    public final acceptTerms:Bool;

    static public function validatePledgeVisibility(_:String):Bool {
        return Type.allEnums(PledgeVisibility).exists(function(v) return v.getName() == _);
    }
}