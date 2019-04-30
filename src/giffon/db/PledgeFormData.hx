package giffon.db;

import thx.Decimal;
using StringTools;
using Lambda;
using js.npm.validator.Validator;

typedef PledgeFormValues = {
    acceptTerms:Bool,
    pledge_method:String,
    pledge_amount:Float,
    pledge_data:Dynamic,
}

class PledgeFormData implements DataClass {
    static public var pledge_amount_min(default, never) = 10;
    static public var pledge_amount_max(default, never) = 500000;

    @validate(_ >= pledge_amount_min && _ <= pledge_amount_max)
    public var pledge_amount:Float;

    @validate(Type.allEnums(PledgeMethod).exists(function(m) return m.getName() == _))
    public var pledge_method:String;

    public var pledge_data:Dynamic;

    @validate(_ == true)
    public var acceptTerms:Bool;
}