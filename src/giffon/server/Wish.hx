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
                    case null: Decimal.zero;
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
        var pledgeFormData:giffon.db.PledgeFormData = try {
            dataclass.JsonConverter.fromJson(giffon.db.PledgeFormData, req.body);
        } catch (err:Dynamic) {
            trace(haxe.Json.stringify(err));
            res.sendPlainError(err, BadRequest);
            return;
        }

        var wish_hashid = req.params.wish_hashid;
        var wish_id = @await getWishIdFromHash(wish_hashid);
        if (wish_id == null) {
            res.sendPlainError("There is no such wish.", NotFound);
            return;
        }
        var wish = @await getWish(wish_id);
        if (wish == null) {
            res.sendPlainError("There is no such wish.", NotFound);
            return;
        }

        var user = res.getUser();
        var stripe_customer_id = @await getStripeCustomerIdFromUser(user);

        var charge = try {
            @await stripe.charges.create({
                amount: pledgeFormData.pledge_amount * 100, // unit is cents
                currency: wish.items[0].item_currency.getName().toLowerCase(),
                // customer: stripe_customer_id,
                source: pledgeFormData.pledge_data.id,
                description: 'Supporting ${wish.wish_owner.user_name}\'s wish (${wish.wish_title}).',
            }).toPromise();
        } catch (err:Dynamic) {
            res.sendPlainError(err, InternalError);
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
                pledge_amount: pledgeFormData.pledge_amount,
                pledge_currency: giffon.db.Currency.USD.getName(),
                pledge_method: giffon.db.PledgeMethod.StripeCard.getName(),
            }
        ).toPromise();
        res.redirect('/wish/$wish_hashid');
    };
}