package test;

import Utils.*;

class FacebookTestUsers {
    static public var user1 = {
        email: env("FB_USER_EMAIL", "open_pvcdapr_user@tfbnw.net"),
        password: env("FB_USER_PW", ""),
    };
}