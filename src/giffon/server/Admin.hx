package giffon.server;

import js.npm.express.*;
import js.npm.mysql2.*;
import react.*;
import react.ReactMacro.jsx;
import thx.Decimal;
import hashids.Hashids;
import giffon.server.ServerMain.*;
import giffon.config.*;
import giffon.browser.*;
import tink.core.Error;
using tink.core.Future.JsPromiseTools;
using giffon.ResponseTools;
using giffon.server.PromiseTools;

@await
class Admin {
    static public function createRouter():Router {
        var router = new Router();
        router.get("/admin", ensureAdmin, handleGet);
        return router;
    }


    @async static function getCompletedWishes():Array<giffon.db.Wish> {
        var wish_results:QueryResults = (@await dbConnectionPool.query(
            '
                SELECT wp.wish_id, wp.pledge_total_amount/wt.wish_total_needed*100.0 AS pledge_percent, pledge_date
                FROM
                    (
                        SELECT wish.wish_id, SUM(pledge_amount) AS pledge_total_amount, MAX(pledge_time_created) AS pledge_date
                        FROM wish
                        INNER JOIN pledge ON wish.wish_id = pledge.wish_id
                        WHERE wish_state = "published"
                        GROUP BY wish.wish_id
                        HAVING pledge_total_amount > 0
                    ) AS wp
                INNER JOIN
                    (
                        SELECT wish.wish_id, CEIL(SUM(item_price * wish_item.item_quantity) * ${giffon.ChargeInfo.serviceChargeRate} * 100.0) / 100.0 AS wish_total_needed
                        FROM wish
                        INNER JOIN wish_item ON wish_item.wish_id = wish.wish_id
                        INNER JOIN item ON wish_item.item_id = item.item_id
                        WHERE wish_state = "published"
                        GROUP BY wish.wish_id
                    ) AS wt ON wp.wish_id = wt.wish_id
                HAVING pledge_percent >= 100
                ORDER BY pledge_date ASC
            ',
            []
        ).toPromise()).results;

        var wishes = @await tink.core.Promise.inParallel([
            for (wish in wish_results)
            getWish(wish.wish_id)
        ]);
        return wishes;
    }

    @await static function handleGet(req, res:Response, next):Void {
        res.sendPage(giffon.view.Admin, {
            completedWishes: @await getCompletedWishes(),
        });
    }
}