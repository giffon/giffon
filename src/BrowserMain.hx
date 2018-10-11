import auth0.*;
import js.Browser.*;
import js.jquery.JQuery;
import haxe.io.*;
import jsrsasign.*;
import Auth0Info.*;

typedef Session = {
    var access_token:String;
    var id_token:String;
    var expires_at:Float;
}

extern class Cookies {
    static public function set(name:String, value:String, ?options:Dynamic):Void;

    @:overload(function():Dynamic<String>{})
    static public function get(name:String):Null<String>;

    static public function getJSON(?name:String):Null<Dynamic>;

    static public function remove(name:String, ?options:Dynamic):Void;
}

class BrowserMain {
    static function main():Void {
        new BrowserMain();
    }

    var session(get, null):Null<Session>;
    var webAuth(default, null):WebAuth;

    public function new():Void {
        webAuth = new WebAuth({
            domain: AUTH0_DOMAIN,
            clientID: AUTH0_CLIENT_ID,
            redirectUri: Path.join([js.Browser.location.href, "signin"]),
            responseType: 'token id_token',
            scope: 'openid email profile',
            leeway: 60
        });

        webAuth.parseHash({}, function(err, authResult) {
            if (err != null) {
                console.error(err);
                return;
            }
            if (authResult != null) {
                if (signIn({
                    access_token: authResult.accessToken,
                    id_token: authResult.idToken,
                    expires_at: authResult.expiresIn * 1000 + Date.now().getTime()
                })) {
                    removeHash();
                    window.location.replace("/home");
                };
            }
        });

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

    function signIn(session:Session):Bool {
        var pubkey = KEYUTIL.getKey(AUTH0_PUBKEY);
        var alg = "RS256";
        var isValid = JWS.verifyJWT(
            session.id_token,
            pubkey,
            {
                alg: [alg],
                iss: ['https://${AUTH0_DOMAIN}/'],
                aud: [AUTH0_CLIENT_ID]
            }
        );

        if (isValid) {
            this.session = session;

            Cookies.set("access_token", session.access_token);
            Cookies.set("expires_at", Std.string(session.expires_at));
            Cookies.set("id_token", session.id_token);

            return true;
        } else {
            return false;
        }
    }

    function signOut():Void {
        Cookies.remove("access_token");
        Cookies.remove("expires_at");
        Cookies.remove("id_token");

        this.session = null;
        webAuth.logout({
            returnTo: location.origin
        });
    }

    function onReady():Void {
        new JQuery(".signInBtn").click(function(evt){
            evt.preventDefault();
            webAuth.authorize({
                connection: "facebook"
            });
        });

        new JQuery(".signOutBtn").click(function(evt){
            evt.preventDefault();
            signOut();
        });
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
