package giffon.config;

import giffon.Utils.*;

class PapertrailInfo {
    static public var host(default, never):String = env("PT_HOST", "logsN.papertrailapp.com");
    static public var port(default, never):Int = Std.parseInt(env("PT_PORT", "00000"));
}