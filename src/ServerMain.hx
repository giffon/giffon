import js.Node.*;
import js.npm.express.*;
import Auth0Info.*;
import jsrsasign.*;
import jsrsasign.Global.*;

@:enum abstract ServerlessStage(String) from String {
    var Master = "master";
    var Production = "production";
    var Dev = "dev";
}

class ServerMain {
    static var SERVERLESS_STAGE(default, never):ServerlessStage = process.env["SERVERLESS_STAGE"];

    static function ensureLoggedIn(req:ExpressRequest, res:ExpressResponse, next:Dynamic):Void {
        if ((untyped req.user) == null) {
            res.redirect("/");
        } else {
            next();
        }
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

        app.use(untyped function(req, res, next) {
            if (req == null || req.cookies == null || req.cookies.id_token == null) {
                next();
                return;
            }
            var token = req.cookies.id_token;
            var pubkey = KEYUTIL.getKey(AUTH0_PUBKEY);
            var alg = "RS256";
            var isValid = JWS.verifyJWT(
                token,
                pubkey,
                {
                    alg: [alg],
                    iss: ['https://${AUTH0_DOMAIN}/'],
                    aud: [AUTH0_CLIENT_ID]
                }
            );
            if (isValid) {
                var payloadObj = JWS.readSafeJSONString(b64utoutf8(token.split(".")[1]));
                req.user = payloadObj;
            }
            next();
        });
        app.get("/", function(req, res) {
            res.render("index", {
                signInStatus: req.user == null ? "signed-out" : "signed-in",
                userName: req.user == null ? null : req.user.name
            });
        });
        app.get('/user', ensureLoggedIn, function(req, res:ExpressResponse) {
            res.send(haxe.Json.stringify(req.user, null, "  "));
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