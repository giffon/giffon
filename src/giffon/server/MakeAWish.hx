package giffon.server;

import js.npm.express.*;
import js.npm.mysql2.*;
import js.npm.price_finder.PriceFinder;
import js.npm.request.Request as NodeRequest;
import tink.CoreApi;
import hashids.Hashids;
import giffon.server.ServerMain.*;
import giffon.config.*;
using js.npm.validator.Validator;
using tink.core.Future.JsPromiseTools;
using giffon.ResponseTools;

@await
class MakeAWish {
    static public function createRouter():Router {
        var router = new Router();
        router.get("/make-a-wish", ensureLoggedIn, handleGet);
        router.post("/make-a-wish", ensureLoggedIn, handlePost);
        return router;
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

    static function handleGet(req, res:Response):Void {
        res.render("make-a-wish");
    }

    @await static function handlePost(req:Request, res:Response){
        var wishValues:giffon.db.WishFormData.WishFormValues = req.body;
        var item_url:String = req.body.item_url;
        var wish_description:String = req.body.wish_description;

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

        var results:Array<QueryResults> = (@await dbConnectionPool.query("
            /*0*/ START TRANSACTION;
            /*1*/ INSERT INTO wish SET ?;
            /*2*/ SELECT @wish_id := LAST_INSERT_ID() AS wish_id;
            /*3*/ INSERT INTO item SET ?;
            /*4*/ SELECT @item_id := LAST_INSERT_ID() AS item_id;
            /*5*/ INSERT INTO wish_item SET wish_id=@wish_id, item_id=@item_id, item_quantity=1;
            /*6*/ COMMIT;
        ", [
            {
                user_id: res.getUser().user_id,
                wish_description: wish_description,
            },
            {
                item_url: item_url,
                item_url_screenshot: screenshot,
                item_name: details.name,
                item_price: details.price,
                item_currency: giffon.db.Currency.USD,
            },
        ]).toPromise()).results;

        var wish_id = results[2][0].wish_id;
        var wish_hashid = new Hashids("wish" + DBInfo.salt, 4).encode(wish_id);
        @await dbConnectionPool.query(
            "UPDATE wish SET `wish_hashid` = ? WHERE `wish_id` = ?",
            ([wish_hashid, wish_id]:Array<Dynamic>)
        ).toPromise();

        res.redirect("/home");
    };
}