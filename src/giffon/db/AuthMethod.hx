package giffon.db;

import giffon.R.*;
using Lambda;

@:using(giffon.db.AuthMethod.AuthMethodTools)
enum AuthMethod {
    Facebook;
    GitHub;
    Twitter;
    GitLab;
    Google;
    YouTube;
    Twitch;
}

class AuthMethodTools {
    static public function logoImage(a:AuthMethod):String {
        return switch(a) {
            case Facebook: R("/images/Facebook logo 2019.svg");
            case Twitter: R("/images/Twitter_Logo_WhiteOnBlue.svg");
            case Google: R("/images/Google__G__Logo.svg");
            case GitHub: R("/images/github-seeklogo.com.svg");
            case GitLab: R("/images/gitlab-icon-rgb.svg");
            case YouTube: R("/images/YouTube_full-color_icon_(2017).svg");
            case Twitch: R("/images/twitch-seeklogo.com.svg");
        }
    }

    static public function fromString(str:String):Null<AuthMethod>
        return Type.allEnums(AuthMethod)
            .find(a -> a.getName().toLowerCase() == str.toLowerCase());
}