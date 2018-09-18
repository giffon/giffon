import auth0.*;
import js.*;
import js.Browser.*;
import js.jquery.JQuery;
import haxe.*;
import promhx.*;

typedef Session = {
    var access_token:String;
    var id_token:String;
    var expires_at:Float;
}

class BrowserMain {
    static var AUTH0_CLIENT_ID = 'iI1IXOjJzqm2QQ6PclJ61HKwhW8QHJXz';
    static var AUTH0_DOMAIN = 'giffon.auth0.com';

    static function main():Void {
        new BrowserMain();
    }

    var session(get, null):Null<Session>;
    var webAuth(default, null):WebAuth;
    var userName(default, null):promhx.Promise<String>;
    var userNameDeferred(default, null):promhx.Deferred<String>;

    public function new():Void {
        webAuth = new WebAuth({
            domain: AUTH0_DOMAIN,
            clientID: AUTH0_CLIENT_ID,
            redirectUri: js.Browser.location.href,
            responseType: 'token id_token',
            scope: 'openid profile',
            leeway: 60
        });

        userNameDeferred = new promhx.Deferred();
        userName = userNameDeferred.promise();

        userName.then(function(userName) {
            trace(userName);
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

    function signIn(session:Session):Void {
        trace(session);
        var localStorage = js.Browser.getLocalStorage();
        if (localStorage == null) {
            Browser.alert("Giffon requires localStorage to work.");
            return;
        }

        new JQuery("body")
            .addClass("signed-in")
            .removeClass("signed-out");

        this.session = session;
        localStorage.setItem("session", Json.stringify(session));

        webAuth.client.userInfo(session.access_token, function(err, user):Void {
            userNameDeferred.resolve(user.name);
            trace(user);
        });
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
        new JQuery(".signInBtn").click(function(evt){
            evt.preventDefault();
            var localStorage = js.Browser.getLocalStorage();
            if (localStorage == null) {
                Browser.alert("Giffon requires localStorage to work.");
                return;
            }
            webAuth.authorize({});
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
                if (session != null) {
                    signIn(session);
                } else {
                    new JQuery("body")
                        .addClass("signed-out")
                        .removeClass("signed-in");
                }
                return;
            }
            location.hash = '';
            signIn({
                access_token: authResult.accessToken,
                id_token: authResult.idToken,
                expires_at: authResult.expiresIn * 1000 + Date.now().getTime()
            });
            trace(session);
        });
    }
}