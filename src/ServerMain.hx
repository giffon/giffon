import js.Node.*;
import js.npm.express.*;
import Auth0Info.*;

@:jsRequire("passport-jwt", "Strategy")
extern class JwtStrategy {
    public function new(options:Dynamic, callb:Dynamic):Void;
}
@:jsRequire("passport-jwt", "ExtractJwt")
extern class ExtractJwt {
    static public function fromAuthHeaderAsBearerToken():Dynamic;
}

@:enum abstract ServerlessStage(String) from String {
    var Master = "master";
    var Production = "production";
    var Dev = "dev";
}

class ServerMain {
    static var SERVERLESS_STAGE(default, never):ServerlessStage = process.env["SERVERLESS_STAGE"];

    static function createAuthRouter(passport:Dynamic):Router {
        var router = Express.GetRouter();
        var ensureLoggedIn = require('connect-ensure-login').ensureLoggedIn();

        router.get('/user', passport.authenticate('jwt', { session: false }), function(req, res:ExpressResponse) {
            res.send(haxe.Json.stringify(req.user, null, "  "));
        });

        return router;
    }
    static function main():Void {
        var isMain = (untyped __js__("require")).main == module;

        var app = Express.GetApplication();

        if (!isMain) {
            var awsServerlessExpressMiddleware = require('aws-serverless-express/middleware');
            app.use(untyped awsServerlessExpressMiddleware.eventContext());
        }

        app.set("view engine", "ejs");

        app.use(require("cookie-parser")());
        app.use(untyped new Static("www", {
            dotfiles: Ignore,
            redirect: true
        }));

        var passport = require('passport');
        function cookieExtractor(req:Dynamic) {
            var token = null;
            if (req != null && req.cookies != null)
            {
                token = req.cookies.id_token;
            }
            return token;
        };
        var strategy = new JwtStrategy({
            secretOrKey: AUTH0_PUBKEY,
            jwtFromRequest: cookieExtractor,
            issuer: 'https://${AUTH0_DOMAIN}/',
            audience: AUTH0_CLIENT_ID,
        },function(jwt_payload, done) {
            done(null, jwt_payload);
        });
        passport.use(strategy);
        app.use(untyped createAuthRouter(passport));
        app.get("/", function(req, res) {
            res.render("index", {
                signInStatus: req.user == null ? "signed-out" : "signed-in",
                userName: req.user == null ? null : req.user.displayName
            });
        });

        module.exports.app = app;

        if (isMain) {
            var port = 3000;
            app.listen(port, function(){
                trace('listening on port $port');
            });
        }
    }
}