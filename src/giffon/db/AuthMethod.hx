package giffon.db;

import giffon.R.*;

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
}