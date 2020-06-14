package giffon.db;

import thx.Decimal;
using StringTools;
using Lambda;
using js.npm.validator.Validator;
import giffon.db.SettingsFormData.SettingsFormDataConst.*;

typedef SettingsFormValues = {
    user_name:String,
    user_primary_email:String,
    user_description:String,
    user_url:String,
    user_avatar:Null<String>,
}

class SettingsFormDataConst {
    static public final user_name_max:Int = 64;
    static public final user_primary_email_max:Int = 128;
    static public final user_description_max:Int = 300;
    static public final user_url_min:Int = 4;
    static public final user_url_max:Int = 64;

}

class SettingsFormData implements DataClass {
    @:validate(_.length > 0 && _.length <= user_name_max)
    public final user_name:String;

    @:validate(_.length == 0 || _.length <= user_primary_email_max && _.isEmail())
    public final user_primary_email:String;

    @:validate(_.length >= 0 && _.length <= user_description_max)
    public final user_description:String;

    @:validate(
        _ == ""

        ||

        _.length >= user_url_min && _.length <= user_url_max

        // define valid characters
        && ~/^[A-Za-z0-9_]*$/.match(_)

        // avoid name crashes with existing pages
        && !["terms", "privacy", "settings", "signout", "signin", "admin", "user", "wish", "connect", "disconnect", "callback"].has(_.toLowerCase())
    )
    public final user_url:String;

    @:validate(_ == null || _.length <= 16777215 && _.startsWith("data:image/"))
    public final user_avatar:Null<String>;
}

typedef SocialSetVisibleValue = {
    social:String,
    visible:Bool,
}

class SocialSetVisibleData implements DataClass {
    @:validate(Type.allEnums(AuthMethod).exists(function(m) return m.getName() == _))
    public final social:String;
    public final visible:Bool;
}
