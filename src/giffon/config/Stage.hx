package giffon.config;

@:enum abstract StageType(String) from String to String {
    var Production = "production";
    var Master = "master";
    var Dev = "dev";
}

class Stage {
    static public var stage =
    #if nodejs
        switch (js.Node.process.env["SERVERLESS_STAGE"]) {
            case null:
                Dev;
            case v:
                v;
        }
    #elseif sys
        switch (Sys.getEnv("SERVERLESS_STAGE")) {
            case null:
                Dev;
            case v:
                v;
        }
    #elseif js
        switch (js.Browser.document.location.hostname) {
            case "giffon.io", "production.giffon.io":
                Production;
            case "master.giffon.io":
                Master;
            case _:
                Dev;
        }
    #else
        #error
    #end
}