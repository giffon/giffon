import js.Node.*;
import js.npm.express.*;
import js.npm.mysql.*;
import Auth0Info.*;
import jsrsasign.*;
import jsrsasign.Global.*;
import haxe.io.*;

@:enum abstract ServerlessStage(String) from String {
    var Production = "production";
    var Master = "master";
    var Dev = "dev";
}

class ServerMain {
    static var SERVERLESS_STAGE(default, never):Null<ServerlessStage> = process.env["SERVERLESS_STAGE"];
    static var canonicalBase(default, never) = "https://giffon.io";

    static function ensureLoggedIn(req:Request, res:Response, next:Dynamic):Void {
        if (res.locals.user == null) {
            res.redirect("/");
        } else {
            next();
        }
    }

    static var dbConnection:Connection;

    static function main():Void {
        var isMain = (untyped __js__("require")).main == module;

        dbConnection = Mysql.createConnection({
            host: DBInfo.host,
            user: DBInfo.user,
            password: DBInfo.password,
            database: DBInfo.database,
            connectTimeout: 30.0 * 1000.0, //30 seconds
        });
        dbConnection.connect();

        var app = new Application();
        app.locals.canonicalBase = canonicalBase;
        app.locals.title = "Giffon";

        if (!isMain) {
            var awsServerlessExpressMiddleware = require('aws-serverless-express/middleware');
            app.use(awsServerlessExpressMiddleware.eventContext());
        }

        app.set("view engine", "ejs");

        app.use(require("cookie-parser")());

        app.use(Express.Static("www", {
            dotfiles: "ignore",
            redirect: true
        }));

        //auth
        app.use(function(req, res, next) {
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
                res.locals.user = payloadObj;
            }
            next();
        });

        //template variables
        app.use(function(req:Request, res:Response, next) {
            res.locals.bodyClasses = [];
            res.locals.canonical = Path.join([canonicalBase, req.path]);
            next();
        });

        //check beta
        app.use(function(req:Request, res:Response, next) {
            switch (req.query.beta) {
                case "1":
                    res.locals.isBeta = true;
                    res.cookie("beta", "1");
                    next();
                    return;
                case "0":
                    res.locals.isBeta = false;
                    res.cookie("beta", "0");
                    next();
                    return;
                case _:
                    //pass
            }
            if (req.cookies != null) {
                switch (req.cookies.beta) {
                    case "1":
                        res.locals.isBeta = true;
                        next();
                        return;
                    case "0":
                        res.locals.isBeta = false;
                        next();
                        return;
                    case _:
                        //pass
                }
            }
            res.locals.isBeta = switch (SERVERLESS_STAGE) {
                case Production: false;
                case _: true;
            }
            next();
        });

        app.get("/", function(req:Request, res) {
            res.render("index");
        });
        app.get("/signin", function(req, res:Response) {
            res.render("signin");
        });
        app.get("/home", ensureLoggedIn, function(req, res:Response) {
            var userEmail = res.locals.user.email;
            if (userEmail == null) throw "no email info";
            dbConnection.query("SELECT 1 FROM user WHERE `user_primary_email` = ?", [userEmail],
                function(err, results:Array<Dynamic>, fields:Array<Dynamic>) {
                    if (err) throw err;
                    if (results.length == 0) {
                        dbConnection.query("INSERT INTO user SET ?", {
                            user_primary_email: userEmail
                        }, function(err, results, fields) {
                            if (err) throw err;
                            res.render("home");
                        });
                    } else {
                        res.render("home");
                    }
                }
            );
        });
        app.get("/user", ensureLoggedIn, function(req, res:Response) {
            res.send(haxe.Json.stringify(res.locals.user, null, "  "));
        });
        app.get("/create-campaign", ensureLoggedIn, function(req, res:Response) {
            res.render("create-campaign");
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