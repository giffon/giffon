import js.Node.*;
import js.npm.express.*;

@:jsRequire("passport-auth0")
extern class Auth0Strategy {
    public function new(options:Dynamic, callb:Dynamic):Void;
}

@:enum abstract ServerlessStage(String) from String {
    var Master = "master";
    var Production = "production";
    var Dev = "dev";
}

class ServerMain {
    static var SERVERLESS_STAGE(default, never):ServerlessStage = process.env["SERVERLESS_STAGE"];

    static function createAuthRouter():Router {
        var passport:Dynamic = require('passport');
        var router = Express.GetRouter();
        var ensureLoggedIn = require('connect-ensure-login').ensureLoggedIn();

        router.get('/login',
            passport.authenticate('auth0', { scope: 'openid profile', connection: 'facebook'}),
            function (req, res) {
                res.redirect("/");
            }
        );

        router.get('/callback',
            passport.authenticate('auth0', { failureRedirect: '/login' }),
            function(req, res:ExpressResponse) {
                if (req.user == null) {
                    throw 'user null';
                }
                res.redirect("/");
            }
        );

        router.get('/user', ensureLoggedIn, function(req, res:ExpressResponse) {
            res.send(haxe.Json.stringify(req.user, null, "  "));
        });

        router.get('/logout', function(req, res:ExpressResponse) {
            req.logout();
            res.redirect('/');
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

        app.use(untyped new Static("www", {
            dotfiles: Ignore,
            redirect: true
        }));

        var session = require("express-session");
        var sessionStore = switch(SERVERLESS_STAGE) {
            case Production | Master:
                var MySQLStore = require('express-mysql-session')(session);
                untyped __js__("new {0}({1})", MySQLStore, {
                    host: 'giffon.cluster-czhm2i8itlng.us-east-1.rds.amazonaws.com',
                    port: 3306,
                    user: 'giffon',
                    password: '5Nrwr4WEGfZa',
                    database: 'giffon_session'
                });
            case _:
                null;
        }
        
        app.use(untyped session({
            secret: 'wm9Y5i7iLQHB8T7',
            store: sessionStore,
            cookie: {
                secure: switch(SERVERLESS_STAGE) {
                    case Production | Master: true;
                    case _: false;
                }
            },
            resave: false,
            saveUninitialized: false
        }));

        var passport = require('passport');
        var strategy = new Auth0Strategy({
                domain: 'giffon.auth0.com',
                clientID: 'iI1IXOjJzqm2QQ6PclJ61HKwhW8QHJXz',
                clientSecret: 'aRMIDi-6bQeRQnUG1GOqU8j2FfL9mz5bcWHn823iAZib78LsSXWpT-6MaF13CGiB',
                callbackURL: switch(SERVERLESS_STAGE) {
                    case Production: "https://giffon.io/callback";
                    case Master: "https://master.giffon.io/callback";
                    case _: "http://localhost:3000/callback";
                }
            },
            function(accessToken, refreshToken, extraParams, profile, done) {
                // accessToken is the token to call Auth0 API (not needed in the most cases)
                // extraParams.id_token has the JSON Web Token
                // profile has all the information from the user
                return done(null, profile);
            }
        );
        passport.use(strategy);
        passport.serializeUser(function(user, done) {
            done(null, user);
        });
        passport.deserializeUser(function(user, done) {
            done(null, user);
        });
        app.use(untyped passport.initialize());
        app.use(untyped passport.session());
        app.use(untyped createAuthRouter());
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