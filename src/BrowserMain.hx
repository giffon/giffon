import auth0.*;
import js.*;
import js.Browser.*;
import js.jquery.JQuery;
import haxe.*;
import promhx.*;
import jsrsasign.*;
import jsrsasign.Global.*;

typedef Session = {
    var access_token:String;
    var id_token:String;
    var expires_at:Float;
}

class BrowserMain {
    static var AUTH0_CLIENT_ID(default, never) = 'iI1IXOjJzqm2QQ6PclJ61HKwhW8QHJXz';
    static var AUTH0_DOMAIN(default, never) = 'giffon.auth0.com';

    static function main():Void {
        new BrowserMain();
    }

    var session(get, null):Null<Session>;
    var webAuth(default, null):WebAuth;
    var userName(default, null):Promise<String>;
    var userNameDeferred(default, null):Deferred<String>;

    public function new():Void {
        webAuth = new WebAuth({
            domain: AUTH0_DOMAIN,
            clientID: AUTH0_CLIENT_ID,
            redirectUri: js.Browser.location.href,
            responseType: 'token id_token',
            scope: 'openid profile',
            leeway: 60
        });

        userNameDeferred = new Deferred();
        userName = userNameDeferred.promise();

        userName.then(function(userName) {
            new JQuery("span.user-name").text(userName);
        });

        new JQuery(onReady);
    }

    function get_session():Null<Session> {
        if (session != null) {
            return session;
        }

        var localStorage = js.Browser.getLocalStorage();
        if (localStorage == null) {
            return null;
        }
        switch (localStorage.getItem("session")) {
            case null:
                return null;
            case sessionStr:
                var session = haxe.Json.parse(sessionStr);
                if (session.expires_at < Date.now().getTime()) {
                    return null;
                }
                return this.session = session;
        }
    }

    function signIn(session:Session):Bool {
        var pubkey = KEYUTIL.getKey(CompileTime.readFile("../auth0/giffon.cer"));
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
            var payloadObj = JWS.readSafeJSONString(b64utoutf8(session.id_token.split(".")[1]));
            userNameDeferred.resolve(payloadObj.name);

            new JQuery("body")
                .addClass("signed-in")
                .removeClass("signed-out");

            this.session = session;


            var localStorage = js.Browser.getLocalStorage();
            if (localStorage == null) {
                Browser.alert("Giffon requires localStorage to work.");
                return false;
            }
            localStorage.setItem("session", Json.stringify(session));

            return true;
        } else {
            return false;
        }
    }

    function signOut():Void {
        var localStorage = js.Browser.getLocalStorage();
        if (localStorage != null) {
            localStorage.removeItem("session");
        }

        new JQuery("body")
            .addClass("signed-out")
            .removeClass("signed-in");
        this.session = null;
        webAuth.logout({
            returnTo: location.origin + location.pathname
        });
    }

    function onReady():Void {
        var localStorage = js.Browser.getLocalStorage();
        var urlParams = new js.html.URLSearchParams(window.location.search);
        switch (urlParams.get("beta")) {
            case null:
                //pass
            case "1":
                localStorage.setItem("beta", "1");
            case _:
                localStorage.removeItem("beta");
        }
        if (localStorage.getItem("beta") == "1") {
            new JQuery("body")
                .addClass("beta");
        }

        new JQuery(".signInBtn").click(function(evt){
            evt.preventDefault();
            if (localStorage == null) {
                Browser.alert("Giffon requires localStorage to work.");
                return;
            }
            webAuth.authorize({
                connection: "facebook"
            });
        });

        new JQuery(".signOutBtn").click(function(evt){
            evt.preventDefault();
            signOut();
        });

        webAuth.parseHash({}, function(err, authResult) {
            if (err != null) {
                console.error(err);
                return;
            }
            if (authResult == null) {
                if (session != null && signIn(session)) {
                    return;
                }
            } else {
                removeHash();

                if (signIn({
                    access_token: authResult.accessToken,
                    id_token: authResult.idToken,
                    expires_at: authResult.expiresIn * 1000 + Date.now().getTime()
                })) {
                    return;
                };
            }

            // not signed in
            new JQuery("body")
                .addClass("signed-out")
                .removeClass("signed-in");
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