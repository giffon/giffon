import js.Node.*;
import js.npm.express.*;
import js.npm.mysql.*;
import js.npm.amazon_helpers.AmazonHelpers;
import js.npm.price_finder.PriceFinder;
import Auth0Info.*;
import jsrsasign.*;
import jsrsasign.Global.*;
import haxe.io.*;
import js.Promise;
using js.npm.validator.Validator;

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

    static var dbConnectionPool:Pool;

    static function main():Void {
        var isMain = (untyped __js__("require")).main == module;

        var dbConfig:Mysql.ConnectionOptions = {
            host: DBInfo.host,
            user: DBInfo.user,
            password: DBInfo.password,
            database: DBInfo.database,
            charset: DBInfo.charset,
            connectTimeout: 4 * 60 * 1000.0 //4 minutes
        };

        // Let's warm up the database
        {
            var cnx = Mysql.createConnection(dbConfig);
            cnx.connect(function(err) {
                if (err != null) {
                    console.error('error connecting: ' + err.stack);
                }
                cnx.end();
            });
        }

        var poolConfig:Mysql.PoolOptions = cast Reflect.copy(dbConfig);
        poolConfig.connectionLimit = 5;
        poolConfig.connectTimeout = 20.0 * 1000.0; //20 seconds
        poolConfig.acquireTimeout = 20.0 * 1000.0; //20 seconds
        dbConnectionPool = Mysql.createPool(poolConfig);


        var app = new Application();
        app.locals.canonicalBase = canonicalBase;
        app.locals.title = "Giffon";

        if (!isMain) {
            var awsServerlessExpressMiddleware = require('aws-serverless-express/middleware');
            app.use(awsServerlessExpressMiddleware.eventContext());
        }

        app.set("view engine", "ejs");

        app.use(require("cookie-parser")());
        app.use(require("body-parser").urlencoded({
            extended: false
        }));

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
                var payloadObj:{
                    given_name: String,
                    family_name: String,
                    nickname: String,
                    name: String,
                    picture: String,
                    updated_at: String,
                    email: String,
                    email_verified:Bool,
                    iss: String,
                    sub: String,
                    aud: String,
                    iat: Float,
                    exp: Float,
                    at_hash: String,
                    nonce: String
                } = JWS.readSafeJSONString(b64utoutf8(token.split(".")[1]));
                var userEmail = payloadObj.email;
                if (userEmail == null) return res.status(500).send("user has no email info");
                res.locals.user = (payloadObj:Dynamic);

                // get user_id
                dbConnectionPool.query("SELECT user_id FROM user WHERE `user_primary_email` = ?", [userEmail],
                    function(err, results:Array<Dynamic>, fields:Array<Dynamic>) {
                        if (err != null) return res.status(500).send(err);
                        if (results.length >= 1) {
                            res.locals.user.user_id = results[0].user_id;
                            next();
                        } else {
                            // insert user
                            dbConnectionPool.query("INSERT INTO user SET ?", {
                                user_primary_email: userEmail
                            }, function(err, results, fields) {
                                if (err != null) return res.status(500).send(err);
                                res.locals.user.user_id = results.insertId;
                                next();
                            });
                        }
                    }
                );
            } else {
                next();
            }
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

        function getCampaigns(user_id:Int) {
            return new Promise(function(resolve, reject) {
                dbConnectionPool.query("SELECT `campaign_id`, `campaign_description`, `campaign_state` FROM campaign WHERE `user_id` = ?", [user_id], function(err, results, fields) {
                    if (err != null) return reject(err);
                    resolve(results);
                });
            });
        }

        app.get("/", function(req:Request, res) {
            res.render("index");
        });
        app.get("/signin", function(req, res:Response) {
            res.render("signin");
        });
        app.get("/home", ensureLoggedIn, function(req:Request, res:Response):Void {
            getCampaigns(res.locals.user.user_id)
                .then(function(campaigns) {
                    res.render("home", {
                        campaigns: campaigns
                    });
                })
                .catchError(function(err){
                    res.status(500).send(err);
                });
        });
        app.get("/user", ensureLoggedIn, function(req, res:Response) {
            res.send(haxe.Json.stringify(res.locals.user, null, "  "));
        });
        app.get("/create-campaign", ensureLoggedIn, function(req, res:Response) {
            res.render("create-campaign");
        });
        app.post("/create-campaign", ensureLoggedIn, function(req:Request, res:Response) {
            var item_url:String = req.body.item_url;
            var campaign_description:String = req.body.campaign_description;

            if (!item_url.isURL({
                protocols: ["https"],
                require_protocol: true,
                host_whitelist: ["www.amazon.com"],
            })) {
                res.status(400).send("invalid url");
                return;
            }

            var priceFinder = new PriceFinder();
            priceFinder.findItemDetails(item_url, function(err, details:{
                price: Float,
                category: String,
                name: String
            }){
                if (err != null) return res.status(500).send(err);
                dbConnectionPool.getConnection(function(err, cnx:Connection) {
                    if (err != null) return res.status(500).send(err);
                    cnx.beginTransaction(function(err){
                        if (err != null) return res.status(500).send(err);
                        cnx.query("INSERT INTO item SET ?", {
                            item_url: item_url,
                            item_name: details.name,
                            item_price: details.price,
                        }, function(err, results, fields) {
                            var item_id = results.insertId;
                            cnx.query("INSERT INTO item_group SET ?", {
                                item_id: item_id
                            }, function(err, results, fields) {
                                if (err != null) {
                                    return cnx.rollback(function(){
                                        cnx.release();
                                        res.status(500).send(err);
                                    });
                                }
                                var item_group_id = results.insertId;
                                cnx.query("INSERT INTO campaign SET ?", {
                                    user_id: res.locals.user.user_id,
                                    campaign_description: campaign_description,
                                    campaign_type: db.CampaignType.Suprise,
                                    item_group_id: item_group_id,
                                }, function(err, results, fields) {
                                    if (err != null) {
                                        return cnx.rollback(function(){
                                            cnx.release();
                                            res.status(500).send(err);
                                        });
                                    }
                                    var campaign_id = results.insertId;
                                    cnx.query("INSERT INTO campaign_surprise SET ?", {
                                        campaign_id: campaign_id,
                                    }, function(err, results, fields) {
                                        if (err != null) {
                                            return cnx.rollback(function(){
                                                cnx.release();
                                                res.status(500).send(err);
                                            });
                                        }
                                        cnx.commit(function(err){
                                            if (err != null) {
                                                return cnx.rollback(function(){
                                                    cnx.release();
                                                    res.status(500).send(err);
                                                });
                                            }
                                            cnx.release();
                                            res.redirect("/home");
                                        });
                                    });
                                });
                            });
                        });
                    });
                });
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