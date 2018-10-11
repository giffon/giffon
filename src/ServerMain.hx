import js.Node.*;
import js.npm.express.*;
import js.npm.mysql.*;
import js.npm.request.Request as NodeRequest;
import js.npm.price_finder.PriceFinder;
import js.npm.image_data_uri.ImageDataUri;
import Auth0Info.*;
import jsrsasign.*;
import jsrsasign.Global.*;
import hashids.Hashids;
import haxe.io.*;
import tink.core.*;
import js.Promise;
using js.npm.validator.Validator;
using tink.core.Future.JsPromiseTools;

@:enum abstract ServerlessStage(String) from String {
    var Production = "production";
    var Master = "master";
    var Dev = "dev";
}

@await
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

    static function getUserIdFromEmail(email:String):Promise<Null<Int>> {
        return new Promise(function(resolve, reject) {
            if (!Validator.isEmail(email))
                return reject('$email is not valid email address');
            dbConnectionPool.query(
                "
                    SELECT `user_id`
                    FROM user
                    WHERE `user_primary_email` = ?
                ",
                [email],
                function(err, results:Array<Dynamic>, fields) {
                    if (results == null || results.length == 0) {
                        resolve(null);
                    } else if (results.length > 1) {
                        reject('There are ${results.length} users with the email address ${email}.');
                    } else {
                        resolve(results[0].user_id);
                    }
                }
            );
        });
    }

    static function getUserIdFromHash(user_hashid:String):Promise<Null<Int>> {
        return new Promise(function(resolve, reject) {
            dbConnectionPool.query(
                "
                    SELECT `user_id`
                    FROM user
                    WHERE `user_hashid` = ?
                ",
                [user_hashid],
                function(err, results:Array<Dynamic>, fields) {
                    if (results == null || results.length == 0) {
                        resolve(null);
                    } else if (results.length > 1) {
                        reject('There are ${results.length} users with the hashid ${user_hashid}.');
                    } else  {
                        resolve(results[0].user_id);
                    }
                }
            );
        });
    }

    static function getCampaignIdFromHash(campaign_hashid:String):Promise<Null<Int>> {
        return new Promise(function(resolve, reject) {
            dbConnectionPool.query(
                "
                    SELECT `campaign_id`
                    FROM campaign
                    WHERE `campaign_hashid` = ?
                ",
                [campaign_hashid],
                function(err, results:Array<Dynamic>, fields) {
                    if (results == null || results.length == 0) {
                        resolve(null);
                    } else if (results.length > 1) {
                        reject('There are ${results.length} campaigns with the hashid ${campaign_hashid}.');
                    } else {
                        resolve(results[0].campaign_id);
                    }
                }
            );
        });
    }

    @:async static function getCampaign(campaign_id:Int) {
        return @await tink.core.Future.async(@async function(resolve) {
            dbConnectionPool.query(
                "
                    SELECT `campaign_id`, `user_id`, `campaign_hashid`, `campaign_description`, `campaign_state`, `item_group_id`
                    FROM campaign
                    WHERE `campaign_id` = ?
                ",
                [campaign_id],
                @async function(err, campaign_results:Array<Dynamic>, fields) {
                    if (err != null)
                        throw err;
                    if (campaign_results == null || campaign_results.length != 1)
                        throw 'There are ${campaign_results == null ? 0 : campaign_results.length} campaigns with campaign_id = ${campaign_id}.';
                    var campaign = campaign_results[0];
                    dbConnectionPool.query(
                        "
                            SELECT item.`item_id`, `item_url`, `item_url_screenshot`, `item_name`, `item_price`
                            FROM item, item_group
                            WHERE item.`item_id` = item_group.`item_id` AND `item_group_id` = ?
                        ",
                        [campaign.item_group_id],
                        @async function(err, item_results:Array<Dynamic>, fields) {
                            if (err != null) throw err;
                            var campaign_owner = @:await getUser(campaign.user_id).toPromise();
                            resolve({
                                campaign_id: campaign.campaign_id,
                                campaign_hashid: campaign.campaign_hashid,
                                campaign_description: campaign.campaign_description,
                                campaign_state: campaign.campaign_state,
                                campaign_owner: campaign_owner,
                                items: item_results.map(function(item){
                                    return {
                                        item_id: item.item_id,
                                        item_url: item.item_url,
                                        item_url_screenshot: ImageDataUri.encode(item.item_url_screenshot, "PNG"),
                                        item_name: item.item_name,
                                        item_price: item.item_price
                                    }
                                })
                            });
                        }
                    );
                }
            );
        });
    }

    

    @async static function getCampaigns(user_id:Int) {
        return @await tink.core.Future.async(@async function(resolve) {
            dbConnectionPool.query(
                "
                    SELECT `campaign_id`
                    FROM campaign
                    WHERE `user_id` = ?
                ",
                [user_id],
                @async function (err, campaign_results:Array<Dynamic>, fields) {
                    if (err != null) {
                        throw err;
                    }

                    var campaigns = @await tink.core.Promise.inParallel([
                        for (campaign in campaign_results)
                        getCampaign(campaign.campaign_id)
                    ]);
                    resolve(campaigns);
                }
            );
        });
    }

    static function getUser(user_id:Int) {
        return new Promise(function(resolve, reject){
            dbConnectionPool.query(
                "
                    SELECT `user_id`, `user_hashid`, `user_primary_email`, `user_name`
                    FROM user
                    WHERE `user_id` = ?
                ",
                [user_id],
                function(err, results:Array<Dynamic>, fields) {
                    if (err) {
                        reject(err);
                        return;
                    }
                    if (results == null || results.length != 1)
                        return reject('There are ${results == null ? 0 : results.length} users with user_id = ${user_id}.');
                    var user = results[0];
                    resolve(user);
                }
            );
        });
    }

    static function getAmazonItemScreenshot(url:String):Promise<js.node.Buffer> {
        return new Promise(function(resolve, reject) {
            NodeRequest.get({
                url: "https://kuortzoyx4.execute-api.us-east-1.amazonaws.com/dev/screenshot",
                qs: {
                    url: url,
                    canvasSize: "450*450",
                    mobile: 1,
                    scrollTo: "#productTitleGroupAnchor"
                },
                encoding: null
            }, function(err, response, body) {
                if (err != null) return reject(err);
                resolve(cast body);
            });
        });
    }

    @async static function auth(req:Request, res:Response, next:haxe.Constraints.Function) {
        try {
            if (req == null || req.cookies == null || req.cookies.id_token == null) {
                next();
                return null;
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
            if (!isValid) {
                next();
                return null;
            }
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
            if (userEmail == null) {
                res.status(500).send("user has no email info");
                return null;
            }
            // get user_id
            var user_id:Null<Int> = @await getUserIdFromEmail(userEmail).toPromise();
            if (user_id != null) {
                var user = @await getUser(user_id).toPromise();
                res.locals.user = user;
                next();
                return null;
            }
            // insert user
            dbConnectionPool.getConnection(function(err, cnx:Connection) {
                if (err != null) return res.status(500).send(err);
                cnx.beginTransaction(function(err){
                    if (err != null) return res.status(500).send(err);
                    cnx.query("INSERT INTO user SET ?", {
                        user_primary_email: userEmail,
                        user_name: payloadObj.name
                    }, function(err, results, fields) {
                        if (err != null) {
                            cnx.rollback(function(){
                                cnx.release();
                                res.status(500).send(err);
                            });
                            return;
                        }
                        var user_id = results.insertId;
                        var user_hashid = new Hashids("user" + DBInfo.salt, 4).encode(user_id);
                        cnx.query(
                            "UPDATE user SET `user_hashid` = ? WHERE `user_id` = ?",
                            ([user_hashid, user_id]:Array<Dynamic>),
                            function(err, results, fields){
                                if (err != null) {
                                    cnx.rollback(function(){
                                        cnx.release();
                                        res.status(500).send(err);
                                    });
                                    return;
                                }
                                cnx.commit(function(err){
                                    if (err != null) {
                                        cnx.rollback(function(){
                                            cnx.release();
                                            res.status(500).send(err);
                                        });
                                        return;
                                    }
                                    var user = getUser(user_id).then(function(user){
                                        res.locals.user = user;
                                        cnx.release();
                                        next();
                                    });
                                });
                            }
                        );
                    });
                });
            });
        } catch (err:Dynamic) {
            res.status(500).send(err);
            return null;
        }
    }

    @async static function main():Void {
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
                    return;
                }
                if (isMain) {
                    cnx.query("SHOW TABLES", function(err, results, fields){
                        trace(results);
                        cnx.end();
                    });
                } else {
                    cnx.end();
                }
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
        app.use(auth);

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
        app.get("/home", ensureLoggedIn, @async function(req:Request, res:Response) {
            try {
                var campaigns = @await getCampaigns(res.locals.user.user_id);
                res.render("home", {
                    campaigns: campaigns
                });
            } catch (err:Dynamic) {
                res.status(500).send(err);
                return null;
            }
        });

        // print user data
        switch (SERVERLESS_STAGE) {
            case Production: //pass
            case _:
                app.get("/user", ensureLoggedIn, function(req, res:Response) {
                    res.setHeader('Content-Type', 'application/json');
                    res.send(haxe.Json.stringify(res.locals.user, null, "  "));
                });
        }

        app.get("/user/:user_hashid", @async function(req:Request, res:Response) {
            try {
                var user_hashid = req.params.user_hashid;
                var user_id = @await getUserIdFromHash(user_hashid).toPromise();
                if (user_id == null) {
                    res.status(404).send("There is no such user.");
                } else {
                    var campaigns = @await getCampaigns(user_id);
                    res.render("user", {
                        campaigns: campaigns
                    });
                }
            } catch (err:Dynamic) {
                res.status(500).send(err);
                return null;
            }
        });
        app.get("/campaign/:campaign_hashid", @async function(req:Request, res:Response){
            try {
                var campaign_hashid = req.params.campaign_hashid;
                var campaign_id = @await getCampaignIdFromHash(campaign_hashid).toPromise();
                if (campaign_id == null) {
                    res.status(404).send("There is no such campaign.");
                } else {
                    var campaign = @await getCampaign(campaign_id);
                    res.render("campaign", {
                        campaign: campaign
                    });
                }
            } catch (err:Dynamic) {
                res.status(500).send(err);
                return null;
            }
        });
        app.get("/campaign/:campaign_hashid/pledge", @async function(req:Request, res:Response){
            try {
                var campaign_hashid = req.params.campaign_hashid;
                var campaign_id = @await getCampaignIdFromHash(campaign_hashid).toPromise();
                if (campaign_id == null) {
                    res.status(404).send("There is no such campaign.");
                } else {
                    var campaign = @await getCampaign(campaign_id);
                    res.status(500).send("Not implemented yet");
                }
            } catch (err:Dynamic) {
                res.status(500).send(err);
                return null;
            }
        });
        app.get("/create-campaign", ensureLoggedIn, function(req, res:Response) {
            res.render("create-campaign");
        });
        app.post("/create-campaign", ensureLoggedIn, @async function(req:Request, res:Response) {
            try {
                var item_url:String = req.body.item_url;
                var campaign_description:String = req.body.campaign_description;

                if (!item_url.isURL({
                    protocols: ["https"],
                    require_protocol: true,
                    host_whitelist: ["www.amazon.com"],
                })) {
                    res.status(400).send("invalid url");
                    return null;
                }

                var priceFinder = new PriceFinder();
                var details:{
                    price: Float,
                    category: String,
                    name: String
                } = @await tink.core.Future.async(function(resolve:Outcome<Dynamic,Dynamic>->Void){
                    priceFinder.findItemDetails(item_url, function(err, details) {
                        if (err != null)
                            resolve(Failure(err));
                        else
                            resolve(Success(details));
                    });
                });
                var screenshot = @await getAmazonItemScreenshot(item_url).toPromise();
                dbConnectionPool.getConnection(function(err, cnx:Connection) {
                    if (err != null) return res.status(500).send(err);
                    cnx.beginTransaction(function(err){
                        if (err != null) return res.status(500).send(err);
                        cnx.query("INSERT INTO item SET ?", {
                            item_url: item_url,
                            item_url_screenshot: screenshot,
                            item_name: details.name,
                            item_price: details.price,
                        }, function(err, results, fields) {
                            if (err != null) {
                                cnx.rollback(function(){
                                    cnx.release();
                                    res.status(500).send(err);
                                });
                                return;
                            }
                            var item_id = results.insertId;
                            cnx.query("INSERT INTO item_group SET ?", {
                                item_id: item_id
                            }, function(err, results, fields) {
                                if (err != null) {
                                    cnx.rollback(function(){
                                        cnx.release();
                                        res.status(500).send(err);
                                    });
                                    return;
                                }
                                var item_group_id = results.insertId;
                                cnx.query("INSERT INTO campaign SET ?", {
                                    user_id: res.locals.user.user_id,
                                    campaign_description: campaign_description,
                                    campaign_type: db.CampaignType.Suprise,
                                    item_group_id: item_group_id,
                                }, function(err, results, fields) {
                                    if (err != null) {
                                        cnx.rollback(function(){
                                            cnx.release();
                                            res.status(500).send(err);
                                        });
                                        return;
                                    }
                                    var campaign_id = results.insertId;
                                    var campaign_hashid = new Hashids("campaign" + DBInfo.salt, 4).encode(campaign_id);
                                    cnx.query(
                                        "UPDATE campaign SET `campaign_hashid` = ? WHERE `campaign_id` = ?",
                                        ([campaign_hashid, campaign_id]:Array<Dynamic>),
                                        function(err, results, fields) {
                                            if (err != null) {
                                                cnx.rollback(function(){
                                                    cnx.release();
                                                    res.status(500).send(err);
                                                });
                                                return;
                                            }
                                            cnx.query("INSERT INTO campaign_surprise SET ?", {
                                                campaign_id: campaign_id,
                                            }, function(err, results, fields) {
                                                if (err != null) {
                                                    cnx.rollback(function(){
                                                        cnx.release();
                                                        res.status(500).send(err);
                                                    });
                                                    return;
                                                }
                                                cnx.commit(function(err){
                                                    if (err != null) {
                                                        cnx.rollback(function(){
                                                            cnx.release();
                                                            res.status(500).send(err);
                                                        });
                                                        return;
                                                    }
                                                    cnx.release();
                                                    res.redirect("/home");
                                                });
                                            });
                                        }
                                    );
                                });
                            });
                        });
                    });
                });
            } catch (err:Dynamic) {
                res.status(500).send(err);
                return null;
            }
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