package test;

import giffon.Utils.*;

class FacebookTestUsers {
    static public var user1 = {
        email: env("FB_USER1_EMAIL", "open_pvcdapr_user@tfbnw.net"),
        password: env("FB_USER1_PW", ""),
        name: env("FB_USER1_NAME", "Open Graph Test User"),
    };
    static public var user2 = {
        email: env("FB_USER2_EMAIL", "aeijhlqbaz_1541125091@tfbnw.net"),
        password: env("FB_USER2_PW", ""),
        name: env("FB_USER2_NAME", "Will Albiidgaddbag Huisen"),
    };
}