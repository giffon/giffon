package giffon.config;

import giffon.Utils.*;

class MailInfo {
    static public var host(default, never):String = env("MAIL_HOST", "smtp.mailgun.org");
    static public var port(default, never):Int = Std.parseInt(env("MAIL_PORT", "587"));
    static public var user(default, never):String = env("MAIL_USER", "postmaster@mail.giffon.io");
    static public var password(default, never):String = env("MAIL_PASSWORD", "pass");
}