package giffon.server;

import js.Node.*;
import js.npm.express.*;
import js.npm.mysql2.*;
import js.npm.mysql2.promise.*;
import js.npm.passport.*;
import js.npm.image_data_uri.ImageDataUri;
import js.npm.stripe.Stripe;
import hashids.Hashids;
import haxe.io.*;
import thx.Decimal;
import haxe.Constraints;
import giffon.config.*;
import giffon.view.*;
using js.npm.validator.Validator;
using tink.core.Future.JsPromiseTools;
using giffon.ResponseTools;
using Lambda;

@:enum abstract ServerlessStage(String) from String to String {
    var Production = "production";
    var Master = "master";
    var Dev = "dev";
}

@:jsRequire("passport-facebook", "Strategy")
extern class FacebookStrategy {
    public function new(options:Dynamic, callb:Dynamic):Void;
}

@await
class ServerMain {
    static public var SERVERLESS_STAGE(default, never):Null<ServerlessStage> = process.env["SERVERLESS_STAGE"];
    static public var canonicalBase(default, never) = "https://giffon.io";

    static public function R(path:String) {
        return switch (SERVERLESS_STAGE) {
            case Production, Master:
                Path.join(["https://static.giffon.io", SERVERLESS_STAGE, path]);
            case _:
                path;
        };
    };

    static public function ensureLoggedIn(req:Request, res:Response, next:Dynamic):Void {
        if (res.getUser() == null) {
            res.redirect("/");
        } else {
            next();
        }
    }

    static public var dbConnectionPool:Pool;
    static public var stripe:Stripe;

    @async static function getStripeCustomerIdFromUser(user:{user_id:Int, user_primary_email:String}):Null<String> {
        var results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT `stripe_customer_id`
                FROM `user_stripe`
                WHERE `user_id` = ?
            ",
            [user.user_id]
        ).toPromise()).results;

        if (results != null && results.length > 0) {
            if (results.length > 1)
                throw 'There are ${results.length} Stripe customers with user_id = ${user.user_id}.';
            return results[0].stripe_customer_id;
        }

        var customers = (@await stripe.customers.list({
            email: user.user_primary_email,
            limit: 5
        }).toPromise()).data;

        if (customers == null || customers.length < 1)
            return null;
        if (customers.length > 1)
            throw 'There are ${customers.length} Stripe customers with email = ${user.user_primary_email}.';

        var stripe_customer_id = customers[0].id;
        @await dbConnectionPool.query(
            "
                INSERT INTO `user_stripe`
                SET ?
            ",
            {
                user_id: user.user_id,
                stripe_customer_id: stripe_customer_id
            }
        ).toPromise();

        return stripe_customer_id;
    }

    @async static function getUserIdFromEmail(email:String):Null<Int> {
        if (!Validator.isEmail(email))
            throw '$email is not valid email address';
        var results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT `user_id`
                FROM user
                WHERE `user_primary_email` = ?
            ",
            [email]
        ).toPromise()).results;

        if (results == null || results.length == 0) {
            return null;
        } else if (results.length > 1) {
            throw 'There are ${results.length} users with the email address ${email}.';
        } else {
            return results[0].user_id;
        }
    }

    @async static function getUserIdFromHash(user_hashid:String):Null<Int> {
        var results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT `user_id`
                FROM user
                WHERE `user_hashid` = ?
            ",
            [user_hashid]
        ).toPromise()).results;

        if (results == null || results.length == 0) {
            return null;
        } else if (results.length > 1) {
            throw 'There are ${results.length} users with the hashid ${user_hashid}.';
        } else  {
            return results[0].user_id;
        }
    }

    @async static function getWishIdFromHash(wish_hashid:String):Null<Int> {
        var results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT `wish_id`
                FROM wish
                WHERE `wish_hashid` = ?
            ",
            [wish_hashid]
        ).toPromise()).results;

        if (results == null || results.length == 0) {
            return null;
        } else if (results.length > 1) {
            throw 'There are ${results.length} wishes with the hashid ${wish_hashid}.';
        } else {
            return results[0].wish_id;
        }
    }

    @async static function getWish(wish_id:Int):giffon.db.Wish {
        var wish_results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT `wish_id`, `user_id`, `wish_hashid`, `wish_description`, `wish_state`
                FROM wish
                WHERE `wish_id` = ?
            ",
            [wish_id]
        ).toPromise()).results;
        if (wish_results == null || wish_results.length < 1)
            return null;
        if (wish_results.length > 1)
            throw 'There are ${wish_results.length} wishes with wish_id = ${wish_id}.';
        var wish = wish_results[0];
        var item_results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT item.`item_id`, `item_url`, `item_url_screenshot`, `item_name`, `item_price`, `item_quantity`
                FROM item
                INNER JOIN wish_item ON item.item_id=wish_item.item_id
                WHERE wish_item.wish_id = ?
            ",
            [wish.wish_id]
        ).toPromise()).results;

        var wish_owner = @await getUser(wish.user_id);

        var wish_pledged = null;
        var pledge_results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT SUM(`pledge_amount`) AS `total_pledge`
                FROM `pledge`
                WHERE `wish_id` = ?
            ",
            [wish_id]
        ).toPromise()).results;
        if (pledge_results != null && pledge_results.length != 0) {
            if (pledge_results.length != 1) {
                throw 'SUM(`pledge_amount`) returned ${pledge_results.length} results.';
            }
            wish_pledged = switch (pledge_results[0].total_pledge) {
                case null: null;
                case str: Decimal.fromString(str).trim();
            }
        }
        var wish_total_price = item_results.fold(function(item, total:Decimal) return total + Decimal.fromString(item.item_price) * Decimal.fromInt(item.item_quantity), Decimal.zero).trim();
        var wish = {
            wish_id: wish.wish_id,
            wish_hashid: wish.wish_hashid,
            wish_description: wish.wish_description,
            wish_state: wish.wish_state,
            wish_owner: wish_owner,
            wish_total_price: wish_total_price,
            wish_total_needed: null,
            wish_pledged: wish_pledged,
            wish_progress: null,
            items: item_results.map(function(item){
                return {
                    item_id: item.item_id,
                    item_url: item.item_url,
                    item_url_screenshot: ImageDataUri.encode(item.item_url_screenshot, "PNG"),
                    item_name: item.item_name,
                    item_price: Decimal.fromString(item.item_price).trim(),
                    item_currency: giffon.db.Currency.USD,
                    item_quantity: item.item_quantity,
                }
            })
        };
        var wish_total_needed = wish.wish_total_needed = ChargeInfo.totalNeeded(wish);
        wish.wish_progress = giffon.db.WishProgress.WishProgressTools.pledgeStateFromAmount(wish_pledged, wish_total_needed.amount);
        return wish;
    }

    @async static function getWishes(user_id:Int):Array<giffon.db.Wish> {
        var wish_results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT `wish_id`
                FROM wish
                WHERE `user_id` = ?
            ",
            [user_id]
        ).toPromise()).results;
        var wishes = @await tink.core.Promise.inParallel([
            for (wish in wish_results)
            getWish(wish.wish_id)
        ]);
        return wishes;
    }

    @async static function getUser(user_id:Int):giffon.db.User {
        var results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT `user_id`, `user_hashid`, `user_primary_email`, `user_name`
                FROM user
                WHERE `user_id` = ?
            ",
            [user_id]
        ).toPromise()).results;
        if (results == null || results.length < 1)
            return null;
        if (results.length > 1)
            throw 'There are ${results == null ? 0 : results.length} users with user_id = ${user_id}.';
        
        var user:{
            user_id:Int,
            user_hashid:String,
            user_primary_email:String,
            user_name:String
        } = results[0];
        var stripe_customer_id = @await getStripeCustomerIdFromUser(user);
        var stripe_customer = if (stripe_customer_id != null) {
            @await stripe.customers.retrieve(stripe_customer_id,{
                expand: ["default_source"],
            }).toPromise();
        } else {
            null;
        }
        return {
            user_id: user.user_id,
            user_hashid: user.user_hashid,
            user_primary_email: user.user_primary_email,
            user_name: user.user_name,
            user_has_card: stripe_customer != null && stripe_customer.default_source != null && stripe_customer.default_source.object == "card",
            stripe_customer: stripe_customer,
        };
    }

    static function __init__():Void {
        js.Node.require("dotenv").config({
            path: Path.join([Sys.getCwd(), "private", ".env"])
        });

        var sms:Dynamic = require("source-map-support");
        sms.install();
        haxe.CallStack.wrapCallSite = sms.wrapCallSite;
    }

    @await static function main():Void {
        haxe.Log.trace = haxe.Log.trace;
        var isMain = (untyped __js__("require")).main == module;

        var dbConfig:Mysql.ConnectionOptions = {
            host: DBInfo.host,
            user: DBInfo.user,
            password: DBInfo.password,
            database: DBInfo.database,
            charset: DBInfo.charset,
            connectTimeout: 10.0 * 1000.0, //10 seconds
        };

        stripe = new Stripe(StripeInfo.apiSecKey);
        stripe.setTimeout(10 * 1000); //10 seconds

        var poolConfig:Mysql.PoolOptions = cast Reflect.copy(dbConfig);
        poolConfig.multipleStatements = true;
        poolConfig.connectionLimit = 3;
        //poolConfig.debug = true;
        dbConnectionPool = Mysql.createPool(poolConfig);

        var app = new Application();
        app.locals.canonicalBase = canonicalBase;
        app.locals.title = "Giffon";

        if (!isMain) {
            var awsServerlessExpressMiddleware = require('aws-serverless-express/middleware');
            app.use(awsServerlessExpressMiddleware.eventContext());
        }

        app.set("view engine", "ejs");

        app.use(require("morgan")("tiny"));

        app.use(require("cookie-parser")());
        app.use(require("body-parser").urlencoded({
            extended: false
        }));
        app.use(require("body-parser").json());

        app.use(Express.Static("www", {
            dotfiles: "ignore",
            redirect: true
        }));

        var session = require("express-session");
        var MySQLStore = require('express-mysql-session')(session);
        var sessionPoolConfig:Mysql.PoolOptions = cast Reflect.copy(poolConfig);
        sessionPoolConfig.connectionLimit = 1;
        sessionPoolConfig.acquireTimeout = 10.0 * 1000.0; //10 seconds
        var sessionStore = untyped __js__("new {0}({1})", MySQLStore, sessionPoolConfig);
        var sess = {
            secret: Utils.env("SESSION_SECRET", "secret"),
            store: sessionStore,
            cookie: {
                secure: switch (SERVERLESS_STAGE) {
                    case Production: true;
                    case _: false;
                }
            },
            resave: false,
            saveUninitialized: true
        };
        app.use(session(sess));

        //https://stackoverflow.com/questions/20739744/passportjs-callback-switch-between-http-and-https
        app.enable("trust proxy");

        var strategy = new FacebookStrategy({
            clientID: FacebookInfo.FACEBOOK_CLIENT_ID,
            clientSecret: FacebookInfo.FACEBOOK_APP_SECRET,
            callbackURL: "/callback/facebook",
            profileFields: ['id', 'displayName', 'email'],
        }, @await function(accessToken, refreshToken, profile:js.npm.passport.Profile, done:Function) {
            if (profile.emails.length <= 0) {
                done("user has no email info");
                return;
            }
            var email = profile.emails[0].value;

            // get user_id
            var user_id:Null<Int> = @await getUserIdFromEmail(email);
            if (user_id != null) {
                var user = @await getUser(user_id);
                done(null, user);
                return;
            }
            // insert user
            var userEmail = email;
            if (userEmail == null) {
                done("user has no email info");
                return;
            }

            try {
                var results:QueryResults = (@await dbConnectionPool.query("INSERT INTO user SET ?", {
                    user_primary_email: userEmail,
                    user_name: profile.displayName,
                }).toPromise()).results;
                user_id = results.insertId;
                var user_hashid = new Hashids("user" + DBInfo.salt, 4).encode(user_id);
                @await dbConnectionPool.query(
                    "UPDATE user SET `user_hashid` = ? WHERE `user_id` = ?",
                    ([user_hashid, user_id]:Array<Dynamic>)
                ).toPromise();
            } catch (err:Dynamic) {
                done(err);
                return;
            }

            var user = @await getUser(user_id);
            done(null, user);
        });

        Passport.serializeUser(function (user:giffon.db.User, done) {
            done(null, user.user_id);
        });
        Passport.deserializeUser(@await function (user_id:Int, done) {
            done(null, @await getUser(user_id));
        });
        Passport.use(strategy);
        app.use(Passport.initialize());
        app.use(Passport.session());

        //template variables
        app.use(function(req:Request, res:Response, next) {
            res.locals.bodyClasses = [];
            res.locals.canonical = Path.join([canonicalBase, req.path]);
            res.locals.R = R;
            if (req.user != null) {
                res.setUser(req.user);
            }
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

        app.get("/", function(req:Request, res:Response) {
            res.sendPage(Index);
            //res.render("index");
        });
        app.get("/terms", function(req, res:Response) {
            res.render("terms");
        });
        app.get("/privacy", function(req, res:Response) {
            res.render("privacy");
        });
        app.get("/signin", function(req, res:Response){
            res.redirect("/signin/facebook");
        });
        app.get("/signin/facebook",
            Passport.authenticate('facebook', {
                scope: ["email"]
            }),
            function(req, res:Response) {
                res.redirect("/");
            }
        );
        app.get("/callback/facebook", function(req, res:Response, next) {
            Passport.authenticate('facebook', function (err, user:giffon.db.User, info) {
                if (err != null) {
                    return res.sendPlainError(err);
                }
                if (user == null) {
                    return res.sendPlainError("unable to login");
                }
                req.login(user, function (err) {
                    if (err != null) {
                        return res.sendPlainError(err);
                    }
                    res.setUser(user);
                    res.redirect('/home');
                });
            })(req, res, next);
        });
        app.get("/signout", function(req, res) {
            req.logout();
            res.redirect('/');
        });

        app.get("/home", ensureLoggedIn, @await function(req:Request, res:Response) {
            try {
                var wishes = @await getWishes(res.getUser().user_id);
                res.render("home", {
                    wishes: wishes
                });
            } catch (err:Dynamic) {
                trace(err);
                res.sendPlainError(err);
                return;
            }
        });

        app.get("/cards", ensureLoggedIn, @await function(req:Request, res:Response){
            res.render("cards");
        });

        app.post("/cards", ensureLoggedIn, @await function(req:Request, res:Response){
            try {
                var user = res.getUser();
                var stripe_customer_id = @await getStripeCustomerIdFromUser(user);

                if (stripe_customer_id != null) {
                    var customer = @await stripe.customers.update(stripe_customer_id, {
                        source: req.body.stripeToken,
                    }).toPromise();
                    res.redirect("/cards");
                    return;
                } else {
                    var customer = @await stripe.customers.create({
                        source: req.body.stripeToken,
                        email: res.getUser().user_primary_email,
                    }).toPromise();

                    @await dbConnectionPool.query(
                        "
                            INSERT INTO `user_stripe`
                            SET ?
                        ",
                        {
                            user_id: user.user_id,
                            stripe_customer_id: customer.id
                        }
                    ).toPromise();

                    res.redirect("/cards");
                    return;
                }
            } catch (err:Dynamic) {
                res.sendPlainError(err);
                return;
            }
        });

        app.get("/card/:card_id/delete", ensureLoggedIn, @await function(req:Request, res:Response){
            try {
                var card_id = req.params.card_id;
                var user = res.getUser();
                if (!user.stripe_customer.sources.data.exists(function(src) {
                    return src.id == card_id;
                })) {
                    res.sendPlainError("You do not have a card with id " + card_id, 400);
                    return;
                }
                @await stripe.customers.deleteCard(user.stripe_customer.id, card_id).toPromise();
                res.redirect("/cards");
                return;
            } catch (err:Dynamic) {
                res.sendPlainError(err);
                return;
            }
        });

        // print user data
        switch (SERVERLESS_STAGE) {
            case Production: //pass
            case _:
                app.get("/user", ensureLoggedIn, function(req, res:Response) {
                    res.setHeader('Content-Type', 'application/json');
                    res.send(haxe.Json.stringify(res.getUser(), null, "  "));
                });
        }

        app.get("/user/:user_hashid", @await function(req:Request, res:Response) {
            try {
                var user_hashid = req.params.user_hashid;
                var user_id = @await getUserIdFromHash(user_hashid);
                if (user_id == null) {
                    res.sendPlainError("There is no such user.", 404);
                } else {
                    var wishes = @await getWishes(user_id);
                    res.render("user", {
                        wishes: wishes
                    });
                }
            } catch (err:Dynamic) {
                res.sendPlainError(err);
                return;
            }
        });
        app.get("/wish/:wish_hashid", @await function(req:Request, res:Response){
            try {
                var wish_hashid = req.params.wish_hashid;
                var wish_id = @await getWishIdFromHash(wish_hashid);
                if (wish_id == null) {
                    res.sendPlainError("There is no such wish.", 404);
                    return;
                }
                var wish = @await getWish(wish_id);
                if (wish == null) {
                    res.sendPlainError("There is no such wish.", 404);
                    return;
                }
                var user_total_pledge = null;
                var user = res.getUser();
                if (user != null) {
                    var results:QueryResults = (@await dbConnectionPool.query(
                        "
                            SELECT SUM(`pledge_amount`) AS `total_pledge`
                            FROM `pledge`
                            WHERE `user_id` = ? AND `wish_id` = ?
                        ",
                        [user.user_id, wish_id]
                    ).toPromise()).results;

                    if (results != null && results.length != 0) {
                        if (results.length != 1) {
                            res.sendPlainError('SUM(`pledge_amount`) returned ${results.length} results.');
                            return;
                        }
                        user_total_pledge = switch (results[0].total_pledge) {
                            case null: null;
                            case str: Decimal.fromString(str).trim();
                        }
                    }
                }
                res.render("wish", {
                    wish: wish,
                    user_total_pledge: user_total_pledge
                });
            } catch (err:Dynamic) {
                res.sendPlainError(err);
                return;
            }
        });
        app.post("/wish/:wish_hashid/pledge", ensureLoggedIn, @await function(req:Request, res:Response){
            try {
                var wish_hashid = req.params.wish_hashid;
                var wish_id = @await getWishIdFromHash(wish_hashid);
                if (wish_id == null) {
                    res.sendPlainError("There is no such wish.", 404);
                    return;
                }
                var wish = @await getWish(wish_id);
                if (wish == null) {
                    res.sendPlainError("There is no such wish.", 404);
                    return;
                }
                var user = res.getUser();
                if (!user.user_has_card) {
                    res.sendPlainError("You have not configured a payment method.", 400);
                }
                var pledge_amount = Decimal.fromString(req.body.pledge_amount);
                if (pledge_amount < 0) {
                    res.sendPlainError("Pledge amount must be larger than 0.", 400);
                    return;
                }
                @await dbConnectionPool.query(
                    "
                        INSERT INTO `pledge`
                        SET ?
                    ",
                    {
                        user_id: user.user_id,
                        wish_id: wish_id,
                        pledge_amount: pledge_amount.toString(),
                        pledge_currency: giffon.db.Currency.USD,
                        pledge_method: giffon.db.PledgeMethod.StripeCard,
                    }
                ).toPromise();
                res.redirect('/wish/$wish_hashid');
            } catch (err:Dynamic) {
                res.sendPlainError(err);
                return;
            }
        });
        app.use(MakeAWish.createRouter());

        app.use(function(err, req, res:Response, next) {
            res.sendPlainError(err, 500);
        });

        module.exports.app = app;

        if (isMain) {
            var port = 3000;
            js.Node.require("httpolyglot").createServer({
                key: js.node.Fs.readFileSync("dev/ssl/key.pem"),
                cert: js.node.Fs.readFileSync("dev/ssl/cert.pem"),
            }, app)
                .listen(port, function(){
                    trace('http://localhost:$port');
                    trace('https://localhost:$port');
                });
        }
    }
}