package giffon.db;

import thx.Decimal;
using StringTools;
using Lambda;
using js.npm.validator.Validator;

typedef SettingsFormValues = {
    user_name:String,
    user_primary_email:String,
    user_description:String,
    user_url:String,
}

class SettingsFormData implements DataClass {
    static public var user_name_max(default, never):Int = 64;
    static public var user_primary_email_max(default, never):Int = 128;
    static public var user_description_max(default, never):Int = 300;
    static public var user_url_max(default, never):Int = 64;

    @validate(_.length > 0 && _.length <= user_name_max)
    public var user_name:String;

    @validate(_.length == 0 || _.length <= user_primary_email_max && _.isEmail())
    public var user_primary_email:String;

    @validate(_.length >= 0 && _.length <= user_description_max)
    public var user_description:String;

    @validate(_.length >= 0 && _.length <= user_url_max && ~/^[A-Za-z0-9\._]*$/.match(_))
    public var user_url:String;
}