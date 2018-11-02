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
import thx.Decimal;
using js.npm.validator.Validator;
using tink.core.Future.JsPromiseTools;
using ResponseTools;
using Lambda;

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
    static var stripe = new Stripe(StripeInfo.apiSecKey);

    @async static function getStripeCustomerIdFromUser(user:{user_id:Int, user_primary_email:String}):Null<String> {
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
            return results[0].stripe_customer_id;
        } else {
            return null;
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

    @async static function getUserIdFromAuth0Payload(payloadObj:Auth0Payload):Null<Int> {
        var results = (@await dbConnectionPool.query(
            "
                SELECT `user_id`
                FROM `user_auth0`
                WHERE `auth0_id` = ?
            ",
            [payloadObj.sub]
        ).toPromise()).results;

        var userId = if (results == null || results.length == 0) {
            null;
        } else if (results.length > 1) {
            throw 'There are ${results.length} users with the auth0_id ${payloadObj.sub}.';
        } else {
            results[0].user_id;
        }

        if (userId != null)
            return userId;
        
        return userId = @await getUserIdFromEmail(payloadObj.email);
    }

    @async static function getUserIdFromEmail(email:String):Null<Int> {
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

    @async static function getUserIdFromHash(user_hashid:String):Null<Int> {
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

    @async static function getCampaignIdFromHash(campaign_hashid:String):Null<Int> {
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

    @async static function getCampaign(campaign_id:Int):db.Campaign {
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

        var campaign_owner = @await getUser(campaign.user_id);

        var campaign_pledged = null;
        var pledge_results = (@await dbConnectionPool.query(
            "
                SELECT SUM(`pledge_amount`) AS `total_pledge`
                FROM `pledge`
                WHERE `campaign_id` = ? AND `pledge_state` = ?
            ",
            [campaign_id, db.PledgeState.Pledged]
        ).toPromise()).results;
        if (pledge_results != null && pledge_results.length != 0) {
            if (pledge_results.length != 1) {
                throw 'SUM(`pledge_amount`) returned ${pledge_results.length} results.';
            }
            campaign_pledged = switch (pledge_results[0].total_pledge) {
                case null: null;
                case str: Decimal.fromString(str).trim();
            }
        }
        var campaign_total_price = item_results.fold(function(item, total:Decimal) return total + Decimal.fromString(item.item_price), Decimal.zero).trim();
        var campaign = {
            campaign_id: campaign.campaign_id,
            campaign_hashid: campaign.campaign_hashid,
            campaign_description: campaign.campaign_description,
            campaign_state: campaign.campaign_state,
            campaign_owner: campaign_owner,
            campaign_total_price: campaign_total_price,
            campaign_total_needed: null,
            campaign_pledged: campaign_pledged,
            campaign_progress: null,
            items: item_results.map(function(item){
                return {
                    item_id: item.item_id,
                    item_url: item.item_url,
                    item_url_screenshot: ImageDataUri.encode(item.item_url_screenshot, "PNG"),
                    item_name: item.item_name,
                    item_price: Decimal.fromString(item.item_price).trim()
                }
            })
        };
        var campaign_total_needed = campaign.campaign_total_needed = ChargeInfo.totalNeeded(campaign);
        campaign.campaign_progress = db.CampaignProgress.CampaignProgressTools.pledgeStateFromAmount(campaign_pledged, campaign_total_needed.amount);
        return campaign;
    }

    @async static function getCampaigns(user_id:Int):Array<db.Campaign> {
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

    @async static function getAmazonItemScreenshot(url:String):js.node.Buffer {
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

    @await static function auth(req:Request, res:Response, next:haxe.Constraints.Function):Void {
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
            var payloadObj:Auth0Payload = JWS.readSafeJSONString(b64utoutf8(token.split(".")[1]));
            // get user_id
            var user_id:Null<Int> = @await getUserIdFromAuth0Payload(payloadObj);
            if (user_id != null) {
                var user = @await getUser(user_id);
                res.setUser(user);
                next();
                return;
            }
            // insert user
            var userEmail = payloadObj.email;
            if (userEmail == null) {
                res.sendPlainError("user has no email info");
                return;
            }
            var cnx:Connection = @await dbConnectionPool.getConnection().toPromise();
            try {
                @await cnx.beginTransaction().toPromise();
            } catch(err:Dynamic) {
                cnx.release();
                res.sendPlainError(err);
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
                @await cnx.query(
                    "INSERT INTO user_auth0 SET ?", {
                        user_id: user_id,
                        auth0_id: payloadObj.sub
                    }
                ).toPromise();
                @await cnx.commit().toPromise();
                cnx.release();
            } catch (err:Dynamic) {
                @await cnx.rollback().toPromise();
                cnx.release();
                res.sendPlainError(err);
                return;
            }
            var user = @await getUser(user_id);
            res.setUser(user);
            next();
        } catch (err:Dynamic) {
            res.sendPlainError(err);
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

    @await static function main():Void {
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
        app.get("/terms", function(req, res:Response) {
            res.render("terms");
        });
        app.get("/privacy", function(req, res:Response) {
            res.render("privacy");
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
                    var campaigns = @await getCampaigns(user_id);
                    res.render("user", {
                        campaigns: campaigns
                    });
                }
            } catch (err:Dynamic) {
                res.sendPlainError(err);
                return;
            }
        });
        app.get("/campaign/:campaign_hashid", @await function(req:Request, res:Response){
            try {
                var campaign_hashid = req.params.campaign_hashid;
                var campaign_id = @await getCampaignIdFromHash(campaign_hashid);
                if (campaign_id == null) {
                    res.sendPlainError("There is no such campaign.", 404);
                    return;
                }
                var campaign = @await getCampaign(campaign_id);
                if (campaign == null) {
                    res.sendPlainError("There is no such campaign.", 404);
                    return;
                }
                var user_total_pledge = null;
                var user = res.getUser();
                if (user != null) {
                    var results = (@await dbConnectionPool.query(
                        "
                            SELECT SUM(`pledge_amount`) AS `total_pledge`
                            FROM `pledge`
                            WHERE `user_id` = ? AND `campaign_id` = ? AND `pledge_state` = ?
                        ",
                        [user.user_id, campaign_id, db.PledgeState.Pledged]
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
                res.render("campaign", {
                    campaign: campaign,
                    user_total_pledge: user_total_pledge
                });
            } catch (err:Dynamic) {
                res.sendPlainError(err);
                return;
            }
        });
        app.post("/campaign/:campaign_hashid/pledge", ensureLoggedIn, @await function(req:Request, res:Response){
            try {
                var campaign_hashid = req.params.campaign_hashid;
                var campaign_id = @await getCampaignIdFromHash(campaign_hashid);
                if (campaign_id == null) {
                    res.sendPlainError("There is no such campaign.", 404);
                    return;
                }
                var campaign = @await getCampaign(campaign_id);
                if (campaign == null) {
                    res.sendPlainError("There is no such campaign.", 404);
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
                        campaign_id: campaign_id,
                        pledge_amount: pledge_amount.toString(),
                        pledge_method: db.PledgeMethod.StripeCard,
                    }
                ).toPromise();
                res.redirect('/campaign/$campaign_hashid');
            } catch (err:Dynamic) {
                res.sendPlainError(err);
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
                    res.sendPlainError("invalid url", 400);
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
                    res.sendPlainError('Unable to scrap item details from $item_url.\n\n${haxe.Json.stringify(err, null, "  ")}');
                    return;
                }
                var screenshot = @await getAmazonItemScreenshot(item_url);
                var cnx:Connection = @await dbConnectionPool.getConnection().toPromise();
                try {
                    @await cnx.beginTransaction().toPromise();
                } catch(err:Dynamic) {
                    cnx.release();
                    res.sendPlainError(err);
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
                    res.sendPlainError(err);
                    return;
                }
            } catch (err:Dynamic) {
                res.sendPlainError(err);
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