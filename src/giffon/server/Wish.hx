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
class Wish {
    static public function createRouter():Router {
        var router = new Router();
        router.get("/wish/:wish_hashid", handleGet);
        router.delete("/wish/:wish_hashid", ensureLoggedIn, handleWishCancel);
        router.post("/wish/:wish_hashid/pledge", ensureLoggedIn, handlePledge);
        router.delete("/wish/:wish_hashid/pledge", ensureLoggedIn, handlePledgeCancel);
        return router;
    }

    @await static function handleGet(req, res:Response, next):Void {
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
            ).handleError(next).toPromise()).results;

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

    @await static function handleWishCancel(req:Request, res:Response, next:Dynamic){
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
        if (user.user_id != wish.wish_owner.user_id) {
            res.sendPlainError("Only the wish owner can cancel the wish.", Forbidden);
            return;
        }

        //TODO: use transaction

        @await dbConnectionPool.query(
            "UPDATE wish SET `wish_state` = \"cancelled\" WHERE `wish_id` = ?",
            ([wish_id]:Array<Dynamic>)
        ).handleError(next).toPromise();

        var results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT `stripe_charge_id`, `user_id`
                FROM `pledge_stripe`
                INNER JOIN `pledge` ON `pledge`.`pledge_id` = `pledge_stripe`.`pledge_id`
                WHERE `wish_id` = ?
            ",
            [wish.wish_id]
        ).handleError(next).toPromise()).results;

        for (result in results) {
            var chargeId = result.stripe_charge_id;
            var user_id = result.user_id;
            var charge = @await stripe.charges.retrieve(chargeId).handleError(next).toPromise();
            if (charge.amount_refunded != charge.amount) {
                @await stripe.charges.refund(chargeId).toPromise();
                @await dbConnectionPool.query(
                    "
                        INSERT INTO `pledge` SET ?;
                    ",{
                        user_id: user_id,
                        wish_id: wish_id,
                        pledge_amount: (Decimal.fromFloat(charge.amount_refunded - charge.amount) * 0.01).toFloat(), //cents -> dollars
                        pledge_currency: wish.items[0].item_currency.getName(),
                        pledge_method: giffon.db.PledgeMethod.StripeCard.getName(),
                    }
                ).handleError(next).toPromise();
            }
        }
        res.sendPlainText("done");
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
                amount: (Decimal.fromFloat(pledgeFormData.pledge_amount) * 100).toInt(), // unit is cents
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
                START TRANSACTION;
                INSERT INTO `pledge` SET ?;
                SELECT @pledge_id := LAST_INSERT_ID() AS pledge_id;
                INSERT INTO `pledge_stripe` SET pledge_id = @pledge_id, ?;
                COMMIT;
            ",
            [{
                user_id: user.user_id,
                wish_id: wish_id,
                pledge_amount: pledgeFormData.pledge_amount,
                pledge_currency: wish.items[0].item_currency.getName(),
                pledge_method: giffon.db.PledgeMethod.StripeCard.getName(),
            }, {
                stripe_charge_id: charge.id,
            }]
        ).handleError(next).toPromise();

        res.redirect(absPath('/wish/$wish_hashid'));
    };

    @await static function handlePledgeCancel(req:Request, res:Response, next:Dynamic){
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
        var results:QueryResults = (@await dbConnectionPool.query(
            "
                SELECT `stripe_charge_id`
                FROM `pledge_stripe`
                INNER JOIN `pledge` ON `pledge`.`pledge_id` = `pledge_stripe`.`pledge_id`
                WHERE `user_id` = ? AND `wish_id` = ?
            ",
            [user.user_id, wish.wish_id]
        ).handleError(next).toPromise()).results;

        var chargeIds:Array<String> = results.map(function(r) return r.stripe_charge_id);
        for (chargeId in chargeIds) {
            var charge = @await stripe.charges.retrieve(chargeId).handleError(next).toPromise();
            if (charge.amount_refunded != charge.amount) {
                @await stripe.charges.refund(chargeId).toPromise();
                @await dbConnectionPool.query(
                    "
                        INSERT INTO `pledge` SET ?;
                    ",{
                        user_id: user.user_id,
                        wish_id: wish_id,
                        pledge_amount: (Decimal.fromFloat(charge.amount_refunded - charge.amount) * 0.01).toFloat(), //cents -> dollars
                        pledge_currency: wish.items[0].item_currency.getName(),
                        pledge_method: giffon.db.PledgeMethod.StripeCard.getName(),
                    }
                ).handleError(next).toPromise();
            }
        }
        res.sendPlainText("done");
    }
}