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
using tink.core.Future.JsPromiseTools;
using giffon.ResponseTools;

@await
class Wish {
    static public function createRouter():Router {
        var router = new Router();
        router.get("/wish/:wish_hashid", handleGet);
        router.post("/wish/:wish_hashid/pledge", ensureLoggedIn, handlePledge);
        return router;
    }

    @:await static function handleGet(req, res:Response):Void {
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
        var user_total_pledge = Decimal.zero;
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
        res.sendPage(giffon.view.Wish, {
            wish: wish,
            user_total_pledge: user_total_pledge
        });
    }

    @await static function handlePledge(req:Request, res:Response, next:Dynamic){
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
    };
}