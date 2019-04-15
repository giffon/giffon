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
        var results:Array<QueryResults> = (@await dbConnectionPool.query("
            /*0*/   START TRANSACTION;

            /*1*/   CREATE TEMPORARY TABLE insert_items (
                        item_number int(11) NOT NULL AUTO_INCREMENT,
                        item_name varchar(128) COLLATE utf8mb4_bin DEFAULT NULL,
                        item_url varchar(1024) COLLATE utf8mb4_bin NOT NULL,
                        item_price decimal(16,4) DEFAULT NULL,
                        item_currency varchar(16) COLLATE utf8mb4_bin NOT NULL,
                        item_quantity tinyint(3) unsigned,
                        PRIMARY KEY (item_number)
                    );
            /*2*/   INSERT INTO insert_items (item_name, item_url, item_price, item_currency, item_quantity) VALUES ?;

            /*3*/   INSERT INTO wish SET ?;
            /*4*/   SELECT @wish_id := LAST_INSERT_ID() AS wish_id;
            /*5*/
                    INSERT INTO item (item_name, item_url, item_price, item_currency)
                    SELECT item_name, item_url, item_price, item_currency
                    FROM insert_items
                    ORDER BY item_number ASC
                    ;
            /*6*/   SELECT @item_id_first := LAST_INSERT_ID() AS item_id;

            /*7*/   SELECT @item_id := @item_id_first - 1;
            /*8*/
                    INSERT INTO wish_item (wish_id, item_id, item_quantity)
                    SELECT @wish_id, @item_id := @item_id + 1, item_quantity
                    FROM insert_items
                    ORDER BY item_number ASC
                    ;

            /*9*/   DROP TEMPORARY TABLE insert_items;
            /*10*/  COMMIT;
        ", [
            [for (itm in wishValues.items) [itm.item_name, itm.item_url, itm.item_price, wishValues.currency, itm.item_quantity]],
            {
                user_id: res.getUser().user_id,
                wish_description: wishValues.wish_description,
            },
        ]).toPromise()).results;

        var wish_id = results[4][0].wish_id;
        var wish_hashid = new Hashids("wish" + DBInfo.salt, 4).encode(wish_id);
        @await dbConnectionPool.query(
            "UPDATE wish SET `wish_hashid` = ? WHERE `wish_id` = ?",
            ([wish_hashid, wish_id]:Array<Dynamic>)
        ).toPromise();

        res.redirect("/home");
    };
}