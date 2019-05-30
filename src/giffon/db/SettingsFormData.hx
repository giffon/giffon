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
    static public var user_name_max(default, never):Int = 64;
    static public var user_description_max(default, never):Int = 300;

    @validate(_.length > 0 && _.length <= user_name_max)
    public var user_name:String;

    @validate(_.length >= 0 && _.length <= user_description_max)
    public var user_description:String;
}