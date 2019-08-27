package giffon.browser;

import js.Browser.*;
import js.fullstory.FS;
import js.jquery.JQuery;
import giffon.browser.*;
import haxe.*;

typedef Session = {
    var access_token:String;
    var id_token:String;
    var expires_at:Float;
}

/**
    https://github.com/js-cookie/js-cookie
**/
@:native("Cookies")
extern class Cookies {
    static public function set(name:String, value:String, ?options:Dynamic):Void;

    @:overload(function():Dynamic<String>{})
    static public function get(name:String):Null<String>;

    static public function getJSON(?name:String):Null<Dynamic>;

    static public function remove(name:String, ?options:Dynamic):Void;
}

class BrowserMain {
    static public var instance:BrowserMain;
    static function main():Void {
        instance = new BrowserMain();
    }

    public var session(get, null):Null<Session>;
    public var language(default, null):giffon.lang.Language;
    public var base(default, null):String;

    public function new():Void {
        new JQuery(onReady);
    }

    function get_session():Null<Session> {
        if (session != null) {
            return session;
        }

        var cookie = Cookies.get();
        if (cookie.id_token != null && cookie.expires_at != null && cookie.access_token != null) {
            var expires_at = Std.parseFloat(cookie.expires_at);
            if (expires_at < Date.now().getTime()) {
                return null;
            }
            return this.session = {
                id_token: cookie.id_token,
                expires_at: expires_at,
                access_token: cookie.access_token
            };
        }
        return null;
    }

    function onReady():Void {
        language = giffon.lang.LanguageTools.langFromCode(document.documentElement.getAttribute("lang"));
        base = document.getElementsByTagName("base")[0].getAttribute("href");

        switch (Cookies.get("doneSignIn")) {
            case null:
                //pass
            case userInfoStr:
                Cookies.remove("doneSignIn");

                // only track production traffic
                switch (giffon.config.Stage.stage) {
                    case Production:
                        var userInfo:{
                            user_id:Int,
                            user_name:String,
                            user_primary_email:String,
                            user_profile_url:String,
                        } = Json.parse(userInfoStr);
                        FS.identify(Std.string(userInfo.user_id), {
                            displayName: userInfo.user_name,
                            email: userInfo.user_primary_email,
                            url: userInfo.user_profile_url,
                        });
                    case _:
                }
        }

        switch (Cookies.get("doneSignOut")) {
            case null:
                //pass
            case _:
                Cookies.remove("doneSignOut");// only track production traffic

                switch (giffon.config.Stage.stage) {
                    case Production:
                        FS.identify(false);
                    case _:
                }
        }

        // https://getbootstrap.com/docs/4.0/components/tooltips/
        var hasTooltip = new JQuery('[data-toggle="tooltip"]');
        (untyped hasTooltip.tooltip)();

        var bodyClasses = document.body.classList;
        if (bodyClasses.contains("page-index")) {
            PageIndex.onReady();
        }

        if (bodyClasses.contains("page-cards")) {
            PageCards.onReady();
        }

        if (bodyClasses.contains("page-wish")) {
            PageWish.onReady();
        }

        if (bodyClasses.contains("page-make-a-wish")) {
            PageMakeAWish.onReady();
        }

        if (bodyClasses.contains("page-edit-wish")) {
            PageEditWish.onReady();
        }

        if (bodyClasses.contains("page-settings")) {
            PageSettings.onReady();
        }
    }

    static function removeHash():Void { 
        var scrollV, scrollH, loc = window.location;
        if (window.history.pushState != null) {
            window.history.pushState("", document.title, loc.pathname + loc.search);
        } else {
            // Prevent scrolling by storing the page's current scroll offset
            scrollV = document.body.scrollTop;
            scrollH = document.body.scrollLeft;

            loc.hash = "";

            // Restore the scroll offset, should be flicker free
            document.body.scrollTop = scrollV;
            document.body.scrollLeft = scrollH;
        }
    }
}
