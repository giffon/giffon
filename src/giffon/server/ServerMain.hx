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
using giffon.RequestTools;
using giffon.ResponseTools;
using Lambda;
using StringTools;

@:jsRequire("passport-facebook", "Strategy")
extern class FacebookStrategy {
    public function new(options:Dynamic, callb:Dynamic):Void;
}

@await
class ServerMain {
    static public var canonicalBase(default, never) = "https://giffon.io";
    static public var base(default, never) = switch (Stage.stage) {
        case Production:
            canonicalBase;
        case Master:
            "https://master.giffon.io";
        case _:
            null;
    }
    static public function absPath(path:String):String {
        if (path.startsWith("https://") || path.startsWith("http://")) {
            return path;
        }
        return switch (base) {
            case null: path;
            case _: Path.join([base, path]);
        }
    }

    static public function ensureLoggedIn(req:Request, res:Response, next:Dynamic):Void {
        if (res.getUser() == null) {
            res.redirect(absPath("/signin?redirectTo=" + req.path.urlEncode()));
        } else {
            next();
        }
    }

    static public var dbConnectionPool:Pool;
    static public var stripe:Stripe;

    @async static public function getStripeCustomerIdFromUser(user:{user_id:Int, user_primary_email:String}):Null<String> {
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

        if (customers == null || customers.length < 1) {
            var customer = @await stripe.customers.create({
                email: user.user_primary_email,
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

            return customer.id;
        }

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

    @async static public function getUserIdFromHash(user_hashid:String):Null<Int> {
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

    @async static public function getWishIdFromHash(wish_hashid:String):Null<Int> {
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

    @async static public function getWish(wish_id:Int):giffon.db.Wish {
        var wish_results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT `wish_id`, `user_id`, `wish_hashid`, `wish_title`, `wish_description`, `wish_target_date`, `wish_state`
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
        var supporter_results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT user_id, SUM(pledge_amount) AS pledge_total_amount, MAX(pledge_time_created) AS pledge_date
                FROM pledge
                WHERE wish_id = ?
                GROUP BY user_id
                HAVING pledge_total_amount > 0
                ORDER BY pledge_total_amount DESC, pledge_date ASC
            ",
            [wish.wish_id]
        ).toPromise()).results;
        var item_results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT item.`item_id`, `item_url`, `item_url_screenshot`, `item_name`, `item_price`, `item_currency`, `item_quantity`
                FROM item
                INNER JOIN wish_item ON item.item_id=wish_item.item_id
                WHERE wish_item.wish_id = ?
            ",
            [wish.wish_id]
        ).toPromise()).results;

        var wish_owner = @await getUser(wish.user_id);

        var wish_pledged = Decimal.zero;
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
                case null: Decimal.zero;
                case str: Decimal.fromString(str).trim();
            }
        }
        var wish_total_price = item_results.fold(function(item, total:Decimal) return total + Decimal.fromString(item.item_price) * Decimal.fromInt(item.item_quantity), Decimal.zero).trim();
        var wish:giffon.db.Wish = {
            wish_id: wish.wish_id,
            wish_hashid: wish.wish_hashid,
            wish_title: wish.wish_title,
            wish_description: wish.wish_description,
            wish_target_date: wish.wish_target_date,
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
                    item_url_screenshot: switch (item.item_url_screenshot) {
                        case null: null;
                        case v: ImageDataUri.encode(v, "PNG");
                    },
                    item_name: item.item_name,
                    item_price: Decimal.fromString(item.item_price).trim(),
                    item_currency: giffon.db.Currency.createByName(item.item_currency),
                    item_quantity: item.item_quantity,
                }
            }),
            supporters: supporter_results.map(function(supporter){
                return {
                    user: getUser(supporter.user_id),
                    pledge_amount: Decimal.fromString(supporter.pledge_total_amount).trim(),
                    pledge_date: supporter.pledge_date,
                }
            }),
        };
        if (!wish.items.foreach(function(itm) return itm.item_currency == wish.items[0].item_currency)) {
            throw "All items should be in the same currency";
        }
        var wish_total_needed = wish.wish_total_needed = ChargeInfo.totalNeeded(wish);
        wish.wish_progress = giffon.db.WishProgress.WishProgressTools.pledgeStateFromAmount(wish_pledged, wish_total_needed.amount);
        return wish;
    }

    @async static function getRecentWishes(num:Int):Array<giffon.db.Wish> {
        var wish_results:QueryResults = (@await dbConnectionPool.query(
            '
                SELECT wish_id
                FROM wish
                WHERE wish_state != "cancelled" && wish_state != "created"
                ORDER BY wish_time_publish DESC
                LIMIT ?
            ',
            [num]
        ).toPromise()).results;

        var wishes = @await tink.core.Promise.inParallel([
            for (wish in wish_results)
            getWish(wish.wish_id)
        ]);
        return wishes;
    }

    static public function userAvatarStyle(user:giffon.db.User) {
        if (user.user_avatar == null) {
            return {};
        }

        return {
            backgroundImage: 'url("${user.user_avatar}")',
        }
    }

    @async static public function getWishes(user_id:Int):Array<giffon.db.Wish> {
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

    @async static public function getUser(user_id:Int):giffon.db.User {
        var results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT `user_id`, `user_hashid`, `user_primary_email`, `user_name`, `user_avatar`
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
            user_name:String,
            user_avatar:js.node.Buffer,
        } = results[0];
        return {
            user_id: user.user_id,
            user_hashid: user.user_hashid,
            user_primary_email: user.user_primary_email,
            user_name: user.user_name,
            user_avatar: switch (user.user_avatar) {
                case null:
                    null;
                case buf:
                    ImageDataUri.encode(buf, "JPEG");
            },
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
        var cookieSetting:Dynamic = {
            secure: switch (Stage.stage) {
                case Production: true;
                case _: false;
            },
        };
        if (base != null) {
            cookieSetting.domain = base.substr(base.indexOf("//")+2);
        }
        var sess = {
            secret: Utils.env("SESSION_SECRET", "secret"),
            store: sessionStore,
            cookie: cookieSetting,
            resave: false,
            saveUninitialized: true
        };
        app.use(session(sess));

        //https://stackoverflow.com/questions/20739744/passportjs-callback-switch-between-http-and-https
        app.enable("trust proxy");

        app.use(function(req, res:ExpressResponse, next){
            res.setHeader("Access-Control-Allow-Origin", "*");
            res.setHeader("Access-Control-Allow-Credentials", "true");
            next();
        });

        var strategy = new FacebookStrategy({
            clientID: FacebookInfo.FACEBOOK_CLIENT_ID,
            clientSecret: FacebookInfo.FACEBOOK_APP_SECRET,
            callbackURL: absPath("/callback/facebook"),
            profileFields: ['id', 'displayName', 'email', 'picture.type(large)'],
        }, @await function(accessToken, refreshToken, profile:js.npm.passport.Profile, done:Function) {
            if (profile.emails.length <= 0) {
                done("user has no email info");
                return;
            }
            var email = profile.emails[0].value;
            var avatarUrl = profile.photos == null || profile.photos.length < 1 ? null : profile.photos[0].value;
            // trace(profile);

            // get user_id
            var user_id:Null<Int> = @await getUserIdFromEmail(email);
            if (user_id != null) {
                var user = @await getUser(user_id);
                if (user.user_avatar == null && avatarUrl != null) {
                    var avatar = {
                        var res = @await js.npm.fetch.Fetch.fetch(avatarUrl).toPromise();
                        @await res.buffer().toPromise();
                    };
                    @await dbConnectionPool.query("UPDATE user SET ? WHERE user_id = ?", [{
                        user_avatar: avatar,
                    }, user_id]).toPromise();
                    user = @await getUser(user_id);
                }
                done(null, user);
                return;
            }
            // insert user
            var userEmail = email;
            if (userEmail == null) {
                done("user has no email info");
                return;
            }

            var avatar:Null<js.node.Buffer> = avatarUrl == null ? null : {
                var res = @await js.npm.fetch.Fetch.fetch(avatarUrl).toPromise();
                @await res.buffer().toPromise();
            };

            try {
                var results:QueryResults = (@await dbConnectionPool.query("INSERT INTO user SET ?", {
                    user_primary_email: userEmail,
                    user_name: profile.displayName,
                    user_avatar: avatar,
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
            res.locals.isBeta = switch (Stage.stage) {
                case Production: false;
                case _: true;
            }
            next();
        });

        app.get("/", @await function(req:Request, res:Response) {
            res.sendPage(Index, {
                recentWishes: @await getRecentWishes(5),
            });
        });
        app.get("/terms", function(req, res:Response) {
            res.sendPage(Terms);
        });
        app.get("/privacy", function(req, res:Response) {
            res.sendPage(Privacy);
        });
        app.get("/signin", function(req:Request, res:Response){
            switch (req.query.redirectTo) {
                case null:
                    //pass
                case redirectTo:
                    req.session.redirectTo = redirectTo;
            }
            res.redirect(absPath("/signin/facebook"));
        });
        app.get("/signin/facebook",
            Passport.authenticate('facebook', {
                scope: ["email"]
            }),
            function(req, res:Response) {
                res.redirect(absPath("/"));
            }
        );
        app.get("/callback/facebook", function(req:Request, res:Response, next) {
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
                    var redirectTo = switch (req.getRedirectTo()) {
                        case null: "/";
                        case r: r;
                    }
                    res.redirect(absPath(redirectTo));
                });
            })(req, res, next);
        });
        app.get("/signout", function(req:Request, res) {
            var redirectTo = switch (req.query.redirectTo) {
                case null: "/";
                case r: r;
            }
            req.logout();
            res.redirect(absPath(redirectTo));
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

        // print user data
        switch (Stage.stage) {
            case Production, Master: //pass
            case Dev:
                app.get("/user", ensureLoggedIn, function(req, res:Response) {
                    res.setHeader('Content-Type', 'application/json');
                    res.send(haxe.Json.stringify(res.getUser(), null, "  "));
                });
        }

        // app.get("/user/:user_hashid", @await function(req:Request, res:Response) {
        //     try {
        //         var user_hashid = req.params.user_hashid;
        //         var user_id = @await getUserIdFromHash(user_hashid);
        //         if (user_id == null) {
        //             res.sendPlainError("There is no such user.", 404);
        //         } else {
        //             var wishes = @await getWishes(user_id);
        //             res.render("user", {
        //                 wishes: wishes
        //             });
        //         }
        //     } catch (err:Dynamic) {
        //         res.sendPlainError(err);
        //         return;
        //     }
        // });

        app.use(giffon.server.User.createRouter());
        app.use(giffon.server.Wish.createRouter());
        app.use(giffon.server.MakeAWish.createRouter());

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