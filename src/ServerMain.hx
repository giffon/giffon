import js.Node.*;
import js.npm.express.*;
import js.npm.mysql2.promise.*;
import js.npm.request.Request as NodeRequest;
import js.npm.price_finder.PriceFinder;
import js.npm.image_data_uri.ImageDataUri;
import js.npm.stripe.Stripe;
import Auth0Info.*;
import jsrsasign.*;
import jsrsasign.Global.*;
import hashids.Hashids;
import haxe.io.*;
import tink.CoreApi;
using js.npm.validator.Validator;
using tink.core.Future.JsPromiseTools;
using ResponseTools;

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
        if (res.getUser() == null) {
            res.redirect("/");
        } else {
            next();
        }
    }

    static var dbConnectionPool:Pool;

    @async static function getUserIdFromEmail(email:String) {
        if (!Validator.isEmail(email))
            throw '$email is not valid email address';
        var results = (@await dbConnectionPool.query(
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

    @async static function getUserIdFromHash(user_hashid:String) {
        var results = (@await dbConnectionPool.query(
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

    @:async static function getCampaignIdFromHash(campaign_hashid:String) {
        var results = (@await dbConnectionPool.query(
            "
                SELECT `campaign_id`
                FROM campaign
                WHERE `campaign_hashid` = ?
            ",
            [campaign_hashid]
        ).toPromise()).results;

        if (results == null || results.length == 0) {
            return null;
        } else if (results.length > 1) {
            throw 'There are ${results.length} campaigns with the hashid ${campaign_hashid}.';
        } else {
            return results[0].campaign_id;
        }
    }

    @:async static function getCampaign(campaign_id:Int) {
        var campaign_results = (@await dbConnectionPool.query(
            "
                SELECT `campaign_id`, `user_id`, `campaign_hashid`, `campaign_description`, `campaign_state`, `item_group_id`
                FROM campaign
                WHERE `campaign_id` = ?
            ",
            [campaign_id]
        ).toPromise()).results;
        if (campaign_results == null || campaign_results.length < 1)
            return null;
        if (campaign_results.length > 1)
            throw 'There are ${campaign_results.length} campaigns with campaign_id = ${campaign_id}.';
        var campaign = campaign_results[0];
        var item_results = (@await dbConnectionPool.query(
            "
                SELECT item.`item_id`, `item_url`, `item_url_screenshot`, `item_name`, `item_price`
                FROM item, item_group
                WHERE item.`item_id` = item_group.`item_id` AND `item_group_id` = ?
            ",
            [campaign.item_group_id]
        ).toPromise()).results;
        var campaign_owner = @:await getUser(campaign.user_id);
        return {
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
        };
    }

    @async static function getCampaigns(user_id:Int) {
        var campaign_results = (@await dbConnectionPool.query(
            "
                SELECT `campaign_id`
                FROM campaign
                WHERE `user_id` = ?
            ",
            [user_id]
        ).toPromise()).results;
        var campaigns = @await tink.core.Promise.inParallel([
            for (campaign in campaign_results)
            getCampaign(campaign.campaign_id)
        ]);
        return campaigns;
    }

    @async static function getUser(user_id:Int):db.User {
        var results = (@await dbConnectionPool.query(
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
        return results[0];
    }

    @async static function getAmazonItemScreenshot(url:String):Promise<js.node.Buffer> {
        return @await Surprise.async(function(resolve){
            NodeRequest.get({
                url: "https://kuortzoyx4.execute-api.us-east-1.amazonaws.com/dev/screenshot",
                qs: {
                    url: url,
                    canvasSize: "450*450",
                    mobile: 1,
                    scrollTo: "#productTitleGroupAnchor"
                },
                encoding: null
            }, function(err:Dynamic, response, body:Dynamic) {
                if (err != null) {
                    resolve(Failure(err));
                } else {
                    resolve(Success(body));
                }
            });
        });
    }

    @await static function auth(req:Request, res:Response, next:haxe.Constraints.Function) {
        try {
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
            if (!isValid) {
                next();
                return;
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
                res.status(500);
                res.type("text/plain");
                res.send("user has no email info");
                return;
            }
            // get user_id
            var user_id:Null<Int> = @await getUserIdFromEmail(userEmail);
            if (user_id != null) {
                var user = @await getUser(user_id);
                res.setUser(user);
                next();
                return;
            }
            // insert user
            var cnx:Connection = @await dbConnectionPool.getConnection().toPromise();
            try {
                @await cnx.beginTransaction().toPromise();
            } catch(err:Dynamic) {
                cnx.release();
                res.status(500);
                res.type("text/plain");
                res.send(err);
                return;
            }
            try {
                var results = (@await cnx.query("INSERT INTO user SET ?", {
                    user_primary_email: userEmail,
                    user_name: payloadObj.name
                }).toPromise()).results;
                var user_id = results.insertId;
                var user_hashid = new Hashids("user" + DBInfo.salt, 4).encode(user_id);
                @await cnx.query(
                    "UPDATE user SET `user_hashid` = ? WHERE `user_id` = ?",
                    ([user_hashid, user_id]:Array<Dynamic>)
                ).toPromise();
                @await cnx.commit().toPromise();
                cnx.release();
            } catch (err:Dynamic) {
                @await cnx.rollback().toPromise();
                cnx.release();
                res.status(500);
                res.type("text/plain");
                res.send(err);
                return;
            }
            var user = @await getUser(user_id);
            res.setUser(user);
            next();
        } catch (err:Dynamic) {
            res.status(500);
            res.type("text/plain");
            res.send(err);
            return;
        }
    }

    @await static function warmUpDatabase(dbConfig:Mysql.ConnectionOptions, showTable:Bool):Void {
        var cnx = @await Mysql.createConnection(dbConfig).toPromise();
        try {
            if (showTable) {
                var results = (@await cnx.query("SHOW TABLES").toPromise()).results;
                trace(results);
            }
        } catch(err:Dynamic) {
            console.error(err);
        }
        cnx.end();
    }

    @await static function main() {
        var isMain = (untyped __js__("require")).main == module;

        var dbConfig:Mysql.ConnectionOptions = {
            host: DBInfo.host,
            user: DBInfo.user,
            password: DBInfo.password,
            database: DBInfo.database,
            charset: DBInfo.charset,
            connectTimeout: 4 * 60 * 1000.0 //4 minutes
        };

        warmUpDatabase(dbConfig, isMain);

        var poolConfig:Mysql.PoolOptions = cast Reflect.copy(dbConfig);
        poolConfig.connectionLimit = 5;
        poolConfig.connectTimeout = 20.0 * 1000.0; //20 seconds
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
        app.get("/home", ensureLoggedIn, @await function(req:Request, res:Response) {
            try {
                var campaigns = @await getCampaigns(res.getUser().user_id);
                res.render("home", {
                    campaigns: campaigns
                });
            } catch (err:Dynamic) {
                res.status(500);
                res.type("text/plain");
                res.send(err);
                return;
            }
        });

        app.get("/cards", ensureLoggedIn, function(req:Request, res:Response){
            res.render("cards");
        });

        app.post("/cards", ensureLoggedIn, @await function(req:Request, res:Response){
            try {
                var stripe = new Stripe(StripeInfo.apiSecKey);
                var user = res.getUser();

                var results = (@await dbConnectionPool.query(
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
                    var stripe_customer_id:String = results[0].stripe_customer_id;
                    res.status(400);
                    res.type("text/plain");
                    res.send("You already have an existing card. Send us an email if you wanna update the card info.");
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
                }
            } catch (err:Dynamic) {
                res.status(500);
                res.type("text/plain");
                res.send(err);
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
                    res.status(404);
                    res.type("text/plain");
                    res.send("There is no such user.");
                } else {
                    var campaigns = @await getCampaigns(user_id);
                    res.render("user", {
                        campaigns: campaigns
                    });
                }
            } catch (err:Dynamic) {
                res.status(500);
                res.type("text/plain");
                res.send(err);
                return;
            }
        });
        app.get("/campaign/:campaign_hashid", @await function(req:Request, res:Response){
            try {
                var campaign_hashid = req.params.campaign_hashid;
                var campaign_id = @await getCampaignIdFromHash(campaign_hashid);
                if (campaign_id == null) {
                    res.status(404).send("There is no such campaign.");
                    return;
                }
                var campaign = @await getCampaign(campaign_id);
                if (campaign == null) {
                    res.status(404).send("There is no such campaign.");
                    return;
                }
                res.render("campaign", {
                    campaign: campaign
                });
            } catch (err:Dynamic) {
                res.status(500);
                res.type("text/plain");
                res.send(err);
                return;
            }
        });
        app.post("/campaign/:campaign_hashid/pledge", @await function(req:Request, res:Response){
            try {
                var campaign_hashid = req.params.campaign_hashid;
                var campaign_id = @await getCampaignIdFromHash(campaign_hashid);
                if (campaign_id == null) {
                    res.status(404).send("There is no such campaign.");
                    return;
                }
                var campaign = @await getCampaign(campaign_id);
                if (campaign == null) {
                    res.status(404).send("There is no such campaign.");
                    return;
                }
                res.status(500);
                res.type("text/plain");
                res.send("Not implemented yet");
            } catch (err:Dynamic) {
                res.status(500);
                res.type("text/plain");
                res.send(err);
                return;
            }
        });
        app.get("/create-campaign", ensureLoggedIn, function(req, res:Response) {
            res.render("create-campaign");
        });
        app.post("/create-campaign", ensureLoggedIn, @await function(req:Request, res:Response){
            try {
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
                var details:{
                    price: Float,
                    category: String,
                    name: String
                } = try {
                    @await Surprise.async(function(resolve){
                        priceFinder.findItemDetails(item_url, function(err, details) {
                            if (err != null)
                                resolve(Failure(err));
                            else
                                resolve(Success(details));
                        });
                    });
                } catch (err:Dynamic) {
                    res.status(500);
                    res.type("text/plain");
                    res.send('Unable to scrap item details from $item_url.\n\n${haxe.Json.stringify(err, null, "  ")}');
                    return;
                }
                var screenshot = @await getAmazonItemScreenshot(item_url);
                var cnx:Connection = @await dbConnectionPool.getConnection().toPromise();
                try {
                    @await cnx.beginTransaction().toPromise();
                } catch(err:Dynamic) {
                    cnx.release();
                    res.status(500);
                    res.type("text/plain");
                    res.send(err);
                    return;
                }
                try {
                    var results = (@await cnx.query("INSERT INTO item SET ?", {
                        item_url: item_url,
                        item_url_screenshot: screenshot,
                        item_name: details.name,
                        item_price: details.price,
                    }).toPromise()).results;
                    var item_id = results.insertId;
                    var results = (@await cnx.query(
                        "INSERT INTO item_group SET ?",
                        {
                            item_id: item_id
                        }
                    ).toPromise()).results;
                    var item_group_id = results.insertId;
                    var results = (@await cnx.query(
                        "INSERT INTO campaign SET ?",
                        {
                            user_id: res.getUser().user_id,
                            campaign_description: campaign_description,
                            campaign_type: db.CampaignType.Suprise,
                            item_group_id: item_group_id,
                        }
                    ).toPromise()).results;
                    var campaign_id = results.insertId;
                    var campaign_hashid = new Hashids("campaign" + DBInfo.salt, 4).encode(campaign_id);
                    @await cnx.query(
                        "UPDATE campaign SET `campaign_hashid` = ? WHERE `campaign_id` = ?",
                        ([campaign_hashid, campaign_id]:Array<Dynamic>)
                    ).toPromise();
                    @await cnx.query(
                        "INSERT INTO campaign_surprise SET ?",
                        {
                            campaign_id: campaign_id,
                        }
                    ).toPromise();
                    @await cnx.commit().toPromise();
                    cnx.release();
                    res.redirect("/home");
                    return;
                } catch (err:Dynamic) {
                    @await cnx.rollback().toPromise();
                    cnx.release();
                    res.status(500);
                    res.type("text/plain");
                    res.send(err);
                    return;
                }
            } catch (err:Dynamic) {
                res.status(500);
                res.type("text/plain");
                res.send(err);
                return;
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