package giffon.db;

import thx.Decimal;
using StringTools;
using Lambda;
using js.npm.validator.Validator;

typedef SettingsFormValues = {
    user_name:String,
    user_description:String,
}

class SettingsFormData implements DataClass {
    @validate(_.length > 0 && _.length <= 64 && _ == StringTools.trim(_))
    public var user_name:String;

    @validate(_.length >= 0 && _.length <= 300 && _ == StringTools.trim(_))
    public var user_description:String;
}